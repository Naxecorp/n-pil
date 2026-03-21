import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nweb/service/outils.dart';
import 'package:path_provider/path_provider.dart';
import '../ObjectModelManager.dart';
import '../ObjectModelMoveManager.dart';
import '../ObjectModelJobManager.dart';
import 'package:nweb/globals_var.dart' as global;
import '../system/SystemsFiles.dart';
import '../gCode/ListGcodeProgram.dart';
import '../gCode/gCodeProgram.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../nwc-settings/nwc-settings.dart';
import '../system/SystemsFilesElement.dart';

class _HeightmapData {
  const _HeightmapData({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.pointsX,
    required this.pointsY,
    required this.values,
  });

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final int pointsX;
  final int pointsY;
  final List<double> values;

  double get _stepX => pointsX > 1 ? (maxX - minX) / (pointsX - 1) : 0;
  double get _stepY => pointsY > 1 ? (maxY - minY) / (pointsY - 1) : 0;

  double _valueAt(int col, int row) {
    final int safeCol = col.clamp(0, pointsX - 1);
    final int safeRow = row.clamp(0, pointsY - 1);
    return values[(safeRow * pointsX) + safeCol];
  }

  double compensationAt(double xMachine, double yMachine) {
    if (pointsX < 2 || pointsY < 2 || values.isEmpty) {
      return 0;
    }

    final double stepX = _stepX;
    final double stepY = _stepY;
    if (stepX.abs() < 1e-9 || stepY.abs() < 1e-9) {
      return _valueAt(0, 0);
    }

    final double fxRaw = (xMachine - minX) / stepX;
    final double fyRaw = (yMachine - minY) / stepY;
    final double fx = fxRaw.clamp(0.0, (pointsX - 1).toDouble());
    final double fy = fyRaw.clamp(0.0, (pointsY - 1).toDouble());

    final int x0 = fx.floor().clamp(0, pointsX - 1);
    final int y0 = fy.floor().clamp(0, pointsY - 1);
    final int x1 = (x0 + 1).clamp(0, pointsX - 1);
    final int y1 = (y0 + 1).clamp(0, pointsY - 1);
    final double tx = fx - x0;
    final double ty = fy - y0;

    final double z00 = _valueAt(x0, y0);
    final double z10 = _valueAt(x1, y0);
    final double z01 = _valueAt(x0, y1);
    final double z11 = _valueAt(x1, y1);
    final double zx0 = z00 + ((z10 - z00) * tx);
    final double zx1 = z01 + ((z11 - z01) * tx);
    return zx0 + ((zx1 - zx0) * ty);
  }
}

class API_Manager {
  static const _token = '9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825';
  static const _lastSyncKey = 'last_sync_timestamp';
  static final RegExp _gCodeRegex =
      RegExp(r'(^|\s)G\s*([0-9]+)(?=\s|$|[A-Z])', caseSensitive: false);
  static final RegExp _mCodeRegex =
      RegExp(r'(^|\s)M\s*([0-9]+)(?=\s|$|[A-Z])', caseSensitive: false);
  static final RegExp _axisValueRegexTemplate =
      RegExp(r'([XYZ])\s*([+\-]?(?:\d+(?:\.\d+)?|\.\d+))', caseSensitive: false);
  static final RegExp _axisPresenceRegexTemplate =
      RegExp(r'([XYZ])(?=\s|[+\-]|\d|\.)', caseSensitive: false);
  static const Duration _heightmapCacheTtl = Duration(seconds: 3);
  _HeightmapData? _cachedHeightmap;
  String? _cachedHeightmapKey;
  DateTime? _cachedHeightmapTimestamp;

  Future<MachineObjectModel> getdataMachineObjectModel() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?flags=d99fn');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        //print("toto ${response.body}");
        final MachineObjectModel Machine =
            machineObjectModelFromJson(response.body);

        return Machine;
      } else {
        //print('Fail to get data, error : ' + response.statusCode.toString());
        return MachineObjectModel();
      }
    } catch (e) {
      if (e.toString() == "XMLHttpRequest error.") return MachineObjectModel();
      if (e.toString().startsWith("TimeoutException"))
        return MachineObjectModel();
      return MachineObjectModel();
    }
  }


  Future<String> sendGcodeCommand(String command) async {
    if (await _shouldBlockGcodeForZEndstopSafety(command)) {
      const String warning =
          "SECURITE Z: montee Z interdite (endstop Z detecte). Mouvement bloque, verifier la machine puis refaire un homing Z.";
      global.ReplyListFiFo.addItem(warning);
      global.showZSafetyPopup(warning);
      debugPrint(warning);
      return 'nok';
    }

    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_gcode?gcode=$command');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        return 'ok';
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'nok';
    }
  }

  bool _isZEndstopTriggered() {
    final List<Endstop>? endstops = global.machineObjectModel.result?.sensors?.endstops;
    if (endstops == null || endstops.length <= 2) {
      return false;
    }
    return endstops[2].triggered == true;
  }

  bool _isCompensationActive() {
    final String type =
        global.objectModelMove.result?.compensation?.type?.toString().toLowerCase() ??
            "none";
    return type != "none" && type != "nil" && type.isNotEmpty;
  }

  String _stripComment(String line) {
    final int semicolonIndex = line.indexOf(";");
    if (semicolonIndex < 0) {
      return line;
    }
    return line.substring(0, semicolonIndex);
  }

  bool _lineHasGCode(String lineUpper, int code) {
    final Iterable<Match> matches = _gCodeRegex.allMatches(lineUpper);
    for (final Match match in matches) {
      final int? value = int.tryParse(match.group(2) ?? "");
      if (value == code) {
        return true;
      }
    }
    return false;
  }

  bool _lineHasMoveGCode(String lineUpper) {
    final Iterable<Match> matches = _gCodeRegex.allMatches(lineUpper);
    for (final Match match in matches) {
      final int? value = int.tryParse(match.group(2) ?? "");
      if (value != null && value >= 0 && value <= 3) {
        return true;
      }
    }
    return false;
  }

  bool _lineHasMCode(String lineUpper, int code) {
    final Iterable<Match> matches = _mCodeRegex.allMatches(lineUpper);
    for (final Match match in matches) {
      final int? value = int.tryParse(match.group(2) ?? "");
      if (value == code) {
        return true;
      }
    }
    return false;
  }

  bool _lineHasAxis(String lineUpper, String axis) {
    final RegExp axisRegex = RegExp(
      _axisPresenceRegexTemplate.pattern.replaceFirst("[XYZ]", axis),
      caseSensitive: false,
    );
    return axisRegex.hasMatch(lineUpper);
  }

  double? _extractAxisValue(String lineUpper, String axis) {
    final RegExp axisRegex = RegExp(
      _axisValueRegexTemplate.pattern.replaceFirst("[XYZ]", axis),
      caseSensitive: false,
    );
    final Match? match = axisRegex.firstMatch(lineUpper);
    if (match == null) {
      return null;
    }
    return double.tryParse(match.group(2) ?? "");
  }

  MapEntry<String, String>? _resolveCompensationPath(String rawPath) {
    String value = rawPath.trim();
    if (value.isEmpty || value == "-" || value.toLowerCase() == "none") {
      return null;
    }
    value = value.replaceAll('"', '').replaceAll("\\", "/");

    final int sdPrefixIndex = value.indexOf(":/");
    if (sdPrefixIndex >= 0) {
      value = value.substring(sdPrefixIndex + 2);
    }
    if (value.startsWith("/")) {
      value = value.substring(1);
    }
    if (value.isEmpty) {
      return null;
    }

    final List<String> parts =
        value.split("/").where((segment) => segment.isNotEmpty).toList();
    if (parts.isEmpty) {
      return null;
    }
    final String fileName = parts.last;
    final String path = parts.length > 1 ? parts.sublist(0, parts.length - 1).join("/") : "sys";
    return MapEntry<String, String>(path, fileName);
  }

  _HeightmapData? _parseHeightmapCsv(String content) {
    final List<String> lines = content
        .split(RegExp(r"\r?\n"))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.length < 4) {
      return null;
    }

    int descriptorLineIndex = -1;
    List<String> descriptor = <String>[];
    for (int i = 0; i < lines.length; i++) {
      final List<String> values = lines[i].split(",").map((e) => e.trim()).toList();
      if (values.length >= 11 &&
          values[0].toUpperCase() == "X" &&
          values[1].toUpperCase() == "Y") {
        descriptorLineIndex = i;
        descriptor = values;
        break;
      }
    }
    if (descriptorLineIndex < 0) {
      return null;
    }

    final double? minX = double.tryParse(descriptor[2].replaceAll(",", "."));
    final double? maxX = double.tryParse(descriptor[3].replaceAll(",", "."));
    final double? minY = double.tryParse(descriptor[4].replaceAll(",", "."));
    final double? maxY = double.tryParse(descriptor[5].replaceAll(",", "."));
    final int? pointsX = int.tryParse(descriptor[9]);
    final int? pointsY = int.tryParse(descriptor[10]);
    if (minX == null ||
        maxX == null ||
        minY == null ||
        maxY == null ||
        pointsX == null ||
        pointsY == null ||
        pointsX < 2 ||
        pointsY < 2) {
      return null;
    }

    final int firstDataLine = descriptorLineIndex + 1;
    if (lines.length < firstDataLine + pointsY) {
      return null;
    }

    final List<double> values = <double>[];
    for (int row = 0; row < pointsY; row++) {
      final List<String> rowValues =
          lines[firstDataLine + row].split(",").map((e) => e.trim()).toList();
      if (rowValues.length < pointsX) {
        return null;
      }
      for (int col = 0; col < pointsX; col++) {
        final double parsed = double.tryParse(rowValues[col].replaceAll(",", ".")) ?? 0;
        values.add(parsed);
      }
    }

    return _HeightmapData(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      pointsX: pointsX,
      pointsY: pointsY,
      values: values,
    );
  }

  Future<_HeightmapData?> _getActiveHeightmapData() async {
    final String compensationFileRaw =
        global.objectModelMove.result?.compensation?.file?.toString() ?? "";
    final MapEntry<String, String>? resolved = _resolveCompensationPath(compensationFileRaw);
    if (resolved == null) {
      return null;
    }

    final String cacheKey = "${resolved.key}/${resolved.value}";
    if (_cachedHeightmap != null &&
        _cachedHeightmapKey == cacheKey &&
        _cachedHeightmapTimestamp != null &&
        DateTime.now().difference(_cachedHeightmapTimestamp!) < _heightmapCacheTtl) {
      return _cachedHeightmap;
    }

    final String content = await downLoadAFile(resolved.key, resolved.value);
    if (content.toLowerCase() == "nok") {
      return null;
    }

    final _HeightmapData? parsed = _parseHeightmapCsv(content);
    if (parsed == null) {
      return null;
    }

    _cachedHeightmap = parsed;
    _cachedHeightmapKey = cacheKey;
    _cachedHeightmapTimestamp = DateTime.now();
    return parsed;
  }

  Future<bool> _wouldXYMoveRaiseZ({
    required String lineUpper,
    required bool isRelativeMode,
  }) async {
    if (!_isCompensationActive()) {
      return false;
    }
    if (!_lineHasAxis(lineUpper, "X") && !_lineHasAxis(lineUpper, "Y")) {
      return false;
    }

    final axes = global.machineObjectModel.result?.move?.axes;
    if (axes == null || axes.length <= 1) {
      return false;
    }
    final double? currentMachineX =
        double.tryParse(axes.elementAt(0).machinePosition?.toString() ?? "");
    final double? currentMachineY =
        double.tryParse(axes.elementAt(1).machinePosition?.toString() ?? "");
    final double? currentUserX =
        double.tryParse(axes.elementAt(0).userPosition?.toString() ?? "");
    final double? currentUserY =
        double.tryParse(axes.elementAt(1).userPosition?.toString() ?? "");
    if (currentMachineX == null || currentMachineY == null) {
      return false;
    }

    double targetMachineX = currentMachineX;
    double targetMachineY = currentMachineY;
    final double? xValue = _extractAxisValue(lineUpper, "X");
    final double? yValue = _extractAxisValue(lineUpper, "Y");
    final bool isG53 = _lineHasGCode(lineUpper, 53);

    if (xValue != null) {
      if (isG53) {
        targetMachineX = isRelativeMode ? currentMachineX + xValue : xValue;
      } else if (isRelativeMode) {
        targetMachineX = currentMachineX + xValue;
      } else if (currentUserX != null) {
        targetMachineX = (xValue + (currentMachineX - currentUserX));
      }
    }
    if (yValue != null) {
      if (isG53) {
        targetMachineY = isRelativeMode ? currentMachineY + yValue : yValue;
      } else if (isRelativeMode) {
        targetMachineY = currentMachineY + yValue;
      } else if (currentUserY != null) {
        targetMachineY = (yValue + (currentMachineY - currentUserY));
      }
    }

    final _HeightmapData? map = await _getActiveHeightmapData();
    if (map == null) {
      return false;
    }

    final double currentComp = map.compensationAt(currentMachineX, currentMachineY);
    final double targetComp = map.compensationAt(targetMachineX, targetMachineY);
    return targetComp > (currentComp + 1e-6);
  }

  bool _isPositiveZMove({
    required String lineUpper,
    required bool isRelativeMode,
  }) {
    final bool hasZ = _lineHasAxis(lineUpper, "Z");
    if (!hasZ) {
      return false;
    }

    final double? parsedZ = _extractAxisValue(lineUpper, "Z");
    if (parsedZ == null) {
      // Z present but non-numeric expression => block for safety.
      return true;
    }

    if (isRelativeMode) {
      return parsedZ > 0.000001;
    }

    final double? currentMachineZ = double.tryParse(
      global.machineObjectModel.result?.move?.axes?[2].machinePosition?.toString() ?? "",
    );
    if (currentMachineZ == null) {
      return parsedZ > 0.000001;
    }
    return parsedZ > (currentMachineZ + 0.000001);
  }

  Future<bool> _shouldBlockGcodeForZEndstopSafety(String command) async {
    if (!_isZEndstopTriggered()) {
      return false;
    }

    final List<String> lines = command.split(RegExp(r"\r?\n"));
    final bool hasAllowedSafetyCommand = lines.any((rawLine) {
      final String line = _stripComment(rawLine).trim();
      if (line.isEmpty) return false;
      final String lineUpper = line.toUpperCase();
      return _lineHasMoveGCode(lineUpper) || _lineHasMCode(lineUpper, 120);
    });
    if (!hasAllowedSafetyCommand) {
      return false;
    }

    bool isRelativeMode = false; // Default machine mode in most GCode streams is absolute.

    for (final String rawLine in lines) {
      final String line = _stripComment(rawLine).trim();
      if (line.isEmpty) {
        continue;
      }

      final String lineUpper = line.toUpperCase();
      if (_lineHasGCode(lineUpper, 91)) {
        isRelativeMode = true;
      }
      if (_lineHasGCode(lineUpper, 90)) {
        isRelativeMode = false;
      }

      if (!_lineHasMoveGCode(lineUpper)) {
        continue;
      }

      if (_isPositiveZMove(lineUpper: lineUpper, isRelativeMode: isRelativeMode)) {
        return true;
      }

      if (await _wouldXYMoveRaiseZ(
        lineUpper: lineUpper,
        isRelativeMode: isRelativeMode,
      )) {
        return true;
      }
    }

    return false;
  }

Future<bool> moveToPositionAndConfirm({
  double? x,
  double? y,
  double? z,
  double tolerance = 0.1,
}) async {
  // Étape 0 : déplacement initial de Z à 189 si Z final est demandé
  if (z != null) {
    final resultZ = await sendGcodeCommand('G53 G0 Z189');
    if (resultZ != 'ok') {
      print("Erreur lors du pré-positionnement de Z.");
      return false;
    }

    // Attente que Z atteigne 189
    final startZ = DateTime.now();
    while (DateTime.now().difference(startZ).inSeconds < 10) {
      await Future.delayed(const Duration(milliseconds: 250));
      final axes = global.machineObjectModel.result?.move?.axes;
      if (axes == null || axes.length < 3) continue;

      final posZ = double.tryParse(axes.elementAt(2).machinePosition?.toString() ?? '') ?? 0.0;
      if ((posZ - 189).abs() < tolerance) break;
    }
  }

  // Étape 1 : construction du G-code
  final buffer = StringBuffer('G53 G0');
  if (x != null) buffer.write(' X${x.toStringAsFixed(3)}');
  if (y != null) buffer.write(' Y${y.toStringAsFixed(3)}');
  if (z != null) buffer.write(' Z${z.toStringAsFixed(3)}');

  // Étape 2 : envoi du G-code
  final sendResult = await sendGcodeCommand(buffer.toString());
  if (sendResult != 'ok') {
    print("Erreur lors de l'envoi du G-code final.");
    return false;
  }

  // Étape 3 : boucle de vérification
  final startTime = DateTime.now();
  while (DateTime.now().difference(startTime).inSeconds < 45) {
    await Future.delayed(const Duration(milliseconds: 250));

    final axes = global.machineObjectModel.result?.move?.axes;
    if (axes == null || axes.length < 3) continue;

    final posX = double.tryParse(axes.elementAt(0).machinePosition?.toString() ?? '') ?? 0.0;
    final posY = double.tryParse(axes.elementAt(1).machinePosition?.toString() ?? '') ?? 0.0;
    final posZ = double.tryParse(axes.elementAt(2).machinePosition?.toString() ?? '') ?? 0.0;

    final isXOk = x == null || (posX - x).abs() < tolerance;
    final isYOk = y == null || (posY - y).abs() < tolerance;
    final isZOk = z == null || (posZ - z).abs() < tolerance;

    if (isXOk && isYOk && isZOk) return true;
  }

  return false;
}

Future<bool> waitUntilMachineIsStill({
  Duration stableDuration = const Duration(seconds: 1),
  Duration maxWait = const Duration(seconds: 30),
  double tolerance = 0.01,
}) async {
  DateTime? stableSince;
  final startTime = DateTime.now();

  List<double>? lastPositions;

  while (DateTime.now().difference(startTime) < maxWait) {
    await Future.delayed(const Duration(milliseconds: 250));

    final axes = global.machineObjectModel.result?.move?.axes;
    if (axes == null || axes.length < 3) continue;

    final current = [
      double.tryParse(axes[0].machinePosition?.toString() ?? '') ?? 0.0,
      double.tryParse(axes[1].machinePosition?.toString() ?? '') ?? 0.0,
      double.tryParse(axes[2].machinePosition?.toString() ?? '') ?? 0.0,
    ];

    if (lastPositions == null) {
      lastPositions = current;
      stableSince = DateTime.now();
      continue;
    }

    final moved = List.generate(3, (i) => (current[i] - lastPositions![i]).abs() > tolerance)
        .any((v) => v);

    if (moved) {
      // Reset timer if motion detected
      lastPositions = current;
      stableSince = DateTime.now();
    } else {
      final stableTime = DateTime.now().difference(stableSince!);
      if (stableTime >= stableDuration) {
        return true; // Machine stable assez longtemps
      }
    }
  }

  return false; // Timeout
}

Future<bool> canUnlockDoorSafely({
  Duration stableDuration = const Duration(milliseconds: 200),
  Duration maxWait = const Duration(seconds: 5),
  double positionTolerance = 0.01,
}) async {
  DateTime? stableSince;
  final startTime = DateTime.now();
  List<double>? lastPositions;

  while (DateTime.now().difference(startTime) < maxWait) {
    await Future.delayed(const Duration(milliseconds: 20));

    final model = global.machineObjectModel.result;
    if (model == null) continue;

    // 1️⃣ Etat machine
    final status = model.state?.status;
    if (status != 'idle' && status != 'paused') {
      stableSince = null;
      continue;
    }

    // 2️⃣ Spindle OFF (sécurité)
    final spindleCurrent = model.spindles?[0].current ?? 0;
    if (spindleCurrent > 0) {
      print(spindleCurrent);
      stableSince = null;
      continue;
    }

    // 3️⃣ Mouvement en cours (Duet)
    final move = model.move;
    if ( (move?.currentMove?.requestedSpeed ?? 0) > 0) {
      print("requestedSpeed: ${move?.currentMove?.requestedSpeed}");
      stableSince = null;
      continue;
    }

    // 4️⃣ Vérification position axes
    final axes = move?.axes;
    if (axes == null || axes.length < 3) continue;

    final currentPos = [
      double.tryParse(axes[0].machinePosition?.toString() ?? '') ?? 0.0,
      double.tryParse(axes[1].machinePosition?.toString() ?? '') ?? 0.0,
      double.tryParse(axes[2].machinePosition?.toString() ?? '') ?? 0.0,
    ];

    if (lastPositions == null) {
      lastPositions = currentPos;
      stableSince = DateTime.now();
      continue;
    }

    final hasMoved = List.generate(
      3,
      (i) => (currentPos[i] - lastPositions![i]).abs() > positionTolerance,
    ).any((v) => v);

    if (hasMoved) {
      lastPositions = currentPos;
      stableSince = DateTime.now();
      continue;
    }

    // 5️⃣ Stable assez longtemps
    if (stableSince != null &&
        DateTime.now().difference(stableSince) >= stableDuration) {
      return true; // ✅ Safe to unlock
    }
  }

  return false; // ❌ Timeout ou condition non remplie
}







  Future<String> sendrr_reply() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "text/plain",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse('http://${global.MyMachineN02Config.IP}/rr_reply');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        if (response.body.length > 2 && RegExp(r'[a-zA-Z0-9]').hasMatch(response.body))
          global.ReplyListFiFo.addItem(response.body);
        return response.body;
      } else {
        print('Send Reply as occured : Fail to Send commnand, error : ' +
            response.statusCode.toString());
        return 'Error : ${response.statusCode}';
      }
    } catch (e) {
      print(e.toString());
      return 'Error : ${e.toString()}';
    }
  }

  // Function to execute sendrr_reply at a specified interval for a specified duration
  Future<void> sendrr_replyEveryIforD(
      int durationMillis, int intervalMillis) async {
    final int repetitions = durationMillis ~/ intervalMillis;

    for (int i = 0; i < repetitions; i++) {
      await sendrr_reply();
      await Future.delayed(Duration(milliseconds: intervalMillis));
    }
  }

  Future<global.MachineMode> getMachineMode() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?key=state.machineMode');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        if (response.body.toString().contains("FFF"))
          return global.MachineMode.fff;
        if (response.body.toString().contains("CNC"))
          return global.MachineMode.cnc;
        if (response.body.toString().contains("Laser"))
          return global.MachineMode.laser;
        else
          return global.MachineMode.unknow;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return global.MachineMode.unknow;
      }
    } catch (e) {
      print(e.toString());
      return global.MachineMode.unknow;
    }
  }

  Future<ObjectModelMove> getMachineMoveObjectModel() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?key=move&flags=d99vn');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        final ObjectModelMove myObjectModelMove =
            objectModelMoveFromJson(response.body);
        return myObjectModelMove;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return ObjectModelMove();
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return ObjectModelMove();
    }
  }

  Future<ObjectModelJob> getMachineJobObjectModel() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?key=job&flags=d99vn');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        final ObjectModelJob myObjectModelJob =
            objectModelJobFromJson(response.body);
        return myObjectModelJob;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return ObjectModelJob();
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return ObjectModelJob();
    }
  }

  Future<List<FileElement?>?> getfileList() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_filelist?dir=0:/gcodes&first=0');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        final ReturnedListGcodeProgram myReturnedListGcodeProgram =
            returnedListGcodeProgramFromJson(response.body);
        return myReturnedListGcodeProgram.files;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return <FileElement>[];
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return <FileElement>[];
    }
  }

  Future<List<SysFileElement?>?> getfileListSys() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json,text/plain",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_filelist?dir=0:/sys/&first=0');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 6));
      if (response.statusCode == 200) {
        final SystemsFiles myReturnedListofFiles =
            systemsFilesFromJson(response.body);
        return myReturnedListofFiles.files;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return <SysFileElement>[];
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return <SysFileElement>[];
    }
  }

  Future<String> upLoadAFile(
      String path, String ContentLength, Uint8List FileContent) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Content-Length": FileContent.length.toString(),
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_upload?name=$path');

    try {
      var response = await http
          .post(uri, headers: requestHeaders, body: FileContent)
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        return 'ok';
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'nok';
    }
  }

  Future<String> deleteAFile(String FileName, String path) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_delete?name=0:/$path/$FileName');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return "ok";
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'nok';
    }
  }

  Future<String> downLoadAFile(String path, String FileName) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/$path/$FileName');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 50));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'NOK';
    }
  } // Pour obtenir le répertoire temporaire

  
  Future<bool> dlFileToTempDir(String path, String fileName) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/$path/$fileName');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        // Obtenir le répertoire temporaire
        Directory tempDir = await getTemporaryDirectory();
        fileName = "job.g";
        String tempPath = '${tempDir.path}/$fileName';

        // Écrire le fichier téléchargé dans le répertoire temporaire
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(response.bodyBytes);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<MachineN02Config> downLoadNwcSettings() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/sys/nwc-settings.json');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        final MachineN02Config Myconfig =
            returnedMachineN02ConfigFromJson(response.body);
        //print(response.body);
        return Myconfig;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return global.MyMachineN02Config;
      }
    } catch (e) {
      print(e.toString());
      return global.MyMachineN02Config;
    }
  }

  Future<PlacementOutil> downLoadToolSettings() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/sys/outil-settings.json');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final PlacementOutil Myconfig = returnedOutilFromJson(response.body);
        //print(response.body);
        return Myconfig;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return global.magasinOutil;
      }
    } catch (e) {
      print(e.toString());
      return global.magasinOutil;
    }
  }

  // Insertion en BDD
  Future<String> pushDataToDb(String serie, String action) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    if (global.MyMachineN02Config.HasWebAcess==1){
    var uri = Uri.parse(
            'http://naxe.fr/naxen02/post.php?serie=${serie}&action=${action}');
        try {
          var response = await http
              .get(uri, headers: requestHeaders)
              .timeout(Duration(seconds: 10));

          if (response.statusCode == 200) {
            return 'ok';
          } else {
            return 'nok';
          }
        } catch (e) {
          return 'nok';
        }
    }
    else {
      return 'no web access';
    }
      
    
  }

  Future<String> sendGcodeToServer({
    required String filename,
    required String content,
    required bool overwrite,
    required String serial,
  }) async {
    const token = '9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825';
    final baseUrl = 'https://naxe.fr/naxen02/reception.php';

    // Joindre les caractères en une seule chaîne
if(global.MyMachineN02Config.HasWebAcess==1){
final uri = Uri.parse(
        '$baseUrl?filename=$filename&overwrite=${overwrite.toString()}&serial=$serial');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'text/plain',
          'Authorization': 'Bearer $token',
          "Access-Control-Allow-Headers": "*",
          "Accept": "*/*",
          "Accept-Encoding": "gzip, deflate",
          "Access-Control-Allow-Origin": "*",
          "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
        },
        body: content,
      ).timeout(Duration(seconds:10));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Succès : ${responseBody['message']}");
        print("📄 Fichier enregistré sous : ${response.body}");
        return response.statusCode.toString();
      } else {
        print("❌ Erreur : ${responseBody['message']}");
        return response.statusCode.toString();
      }
    } catch (e) {
      print("⚠️ Erreur lors de l’envoi : $e");
      return "404";
    }
}
else {
  return 'no web access';
}
    
  }

  Future<void> showUploadProgressDialog({
    required BuildContext context,
    required List<SysFileElement> files,
    required bool overwrite,
    required String serial,
  }) async {
    final progressNotifier = ValueNotifier<double>(0.0);
    final stepTextNotifier = ValueNotifier<String>("Préparation...");
    bool cancelRequested = false;

    // Afficher la boîte modale de progression
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Envoi en cours'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: progressNotifier,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(value: value);
                    },
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable: stepTextNotifier,
                    builder: (context, value, _) => Text(value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cancelRequested = true;
                    Navigator.of(context).pop(); // Ferme le popup immédiatement
                  },
                  child: Text('Annuler'),
                ),
              ],
            );
          },
        );
      },
    );

    int total = files.length;
    int done = 0;
    int successCount = 0;
    int failCount = 0;

    for (final file in files) {
      if (cancelRequested) break;

      done++;

      if (file.name == null) {
        failCount++;
        progressNotifier.value = done / total;
        continue;
      }

      stepTextNotifier.value = 'Téléchargement : ${file.name}';

      try {
        final content = await downLoadAFile('sys', file.name!);

        if (content.toLowerCase() == 'nok') {
          failCount++;
        } else {
          stepTextNotifier.value = 'Envoi : ${file.name}';
          await sendGcodeToServer(
            filename: file.name!,
            content: content,
            overwrite: overwrite,
            serial: serial,
          );
          
          successCount++;
        }
      } catch (e) {
        failCount++;
      }

      progressNotifier.value = done / total;
    }

    // Affiche un résumé seulement si ce n'était pas annulé
    if (!cancelRequested) {
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Résultat de l\'envoi'),
            content: Text('✔️ Succès : $successCount\n❌ Échecs : $failCount'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> getUpdatedFiles(
      String serial, int since) async {
    if(global.MyMachineN02Config.HasWebAcess==1){
      final uri = Uri.parse(
          'https://naxe.fr/naxen02/get_updated_files.php?serial=$serial&since=$since');

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer 9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825',
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return List<Map<String, dynamic>>.from(json['files']);
        }
      }

      throw Exception('Erreur lors de la récupération des fichiers mis à jour');
    }
    else {
      throw Exception('no web access');
    }
    
    
  }

  /// Fonction principale de synchronisation
  Future<void> synchronizeFilesToMachine({
    required BuildContext context,
    required String serial,
  }) async {
    int successCount = 0;
    int failCount = 0;
    final StringBuffer logBuffer = StringBuffer();

    try {
      // 1️⃣ Demander le numéro de série à l'utilisateur
      String enteredSerial = await _promptSerialNumber(context, serial);
      if (enteredSerial.isEmpty) {
        print('⚠️ Annulé par l\'utilisateur');
        return;
      }

      // 2️⃣ Vérifier si le numéro correspond à celui configuré
      if (enteredSerial != serial) {
        final confirm =
            await _confirmSerialMismatch(context, serial, enteredSerial);
        if (!confirm) {
          print('⚠️ Annulé par l\'utilisateur après mismatch');
          return;
        }
      }

      // 3️⃣ Récupérer la liste complète des fichiers sur le serveur
      List<Map<String, dynamic>> filesOnServer = [];
      try {
        filesOnServer = await getAllFilesOnServer(enteredSerial);
      } catch (e) {
        print('❌ Erreur lors de la récupération de la liste des fichiers : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur récupération fichiers $e')),
        );
        return;
      }

      if (filesOnServer.isEmpty) {
        print('ℹ️ Aucun fichier à synchroniser');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun fichier à synchroniser')),
        );
        return;
      }

      // 4️⃣ Ouvrir le dialogue de progression
      final progressNotifier = ValueNotifier<double>(0.0);
      final stepTextNotifier = ValueNotifier<String>('Préparation...');
      bool cancelRequested = false;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Synchronisation'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: progressNotifier,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(value: value);
                    },
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable: stepTextNotifier,
                    builder: (context, value, _) => Text(value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cancelRequested = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('Annuler'),
                ),
              ],
            );
          });
        },
      );

      // 5️⃣ Synchroniser chaque fichier
      int total = filesOnServer.length;
      int done = 0;

      for (final file in filesOnServer) {
        if (cancelRequested) break;

        final filename = file['filename'];

        final now = DateTime.now();
        final timestamp =
            "[${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}]";

        stepTextNotifier.value = 'Téléchargement : $filename';

        String downloadStatus = 'nok';
        String uploadStatus = 'nok';

        try {
          // Télécharger le fichier depuis le serveur
          final content = await downloadFileFromServer(enteredSerial, filename);
          downloadStatus = 'ok';

          // Convertir en Uint8List
          final fileContent = Uint8List.fromList(utf8.encode(content));

          // Envoyer à la machine
          stepTextNotifier.value = 'Envoi à la machine : $filename';

          final result = await upLoadAFile(
              "0:/sys/$filename", fileContent.length.toString(), fileContent);

          if (result.toLowerCase() == 'ok') {
            uploadStatus = 'ok';
            successCount++;
          } else {
            uploadStatus = 'nok';
            failCount++;
          }
        } catch (e) {
          print('⚠️ Erreur avec $filename : $e');
          failCount++;
        }

        // Ajout au log
        logBuffer.writeln(
            '$timestamp Nom: $filename | Serial: $enteredSerial | Téléchargement: $downloadStatus | Upload: $uploadStatus');

        done++;
        progressNotifier.value = done / total;
      }

      // 6️⃣ Fermer la modale après traitement
      Navigator.of(context).pop();

      // 7️⃣ Envoyer le log à la machine CNC et au serveur
      if (!cancelRequested) {
        final logContent = logBuffer.toString();
        final logBytes = Uint8List.fromList(utf8.encode(logContent));

        final now = DateTime.now();
        final formattedDate =
            "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}_${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}";
        final logFilename = 'log_synchro_$formattedDate.txt';

        final logResult = await upLoadAFile(
            "0:/sys/$logFilename", logBytes.length.toString(), logBytes);
        print('📄 Transfert du log à la machine : $logResult');

        final serverResult =
            await sendLogFileToServer(enteredSerial, logFilename, logContent);
        print('🌐 Transfert du log au serveur : $serverResult');
      }

      // 8️⃣ Résumé final
      if (!cancelRequested) {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text('Synchronisation terminée'),
              content: Text('✔️ Succès : $successCount\n❌ Échecs : $failCount'),
              actions: [
                TextButton(
                  onPressed: () async {
                    await API_Manager()
                        .getfileList()
                        .then((value) => global.ListofGcodeFile = value)
                        .timeout(Duration(seconds: 5));
                    Navigator.of(dialogContext).pop();
                    Navigator.pushNamed(context, '/admin');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on TimeoutException catch (_) {
      print('⏱️ Synchronisation annulée (timeout)');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : synchronisation annulée (timeout)')),
      );
    }
  }

  /// Boîte de dialogue pour demander le numéro de série
  Future<String> _promptSerialNumber(
      BuildContext context, String defaultSerial) async {
    String enteredSerial = '';
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final controller = TextEditingController(text: defaultSerial);
        return AlertDialog(
          title: Text('Numéro de série'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Numéro de série'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                enteredSerial = controller.text.trim();
                Navigator.of(dialogContext).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
    return enteredSerial;
  }

  /// Boîte de confirmation si le numéro saisi ne correspond pas
  Future<bool> _confirmSerialMismatch(
      BuildContext context, String expectedSerial, String enteredSerial) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Numéro de série différent'),
          content: Text(
              'Le numéro de série saisi ($enteredSerial) est différent de celui attendu ($expectedSerial). Voulez-vous continuer ?'),
          actions: [
            TextButton(
              onPressed: () {
                confirmed = false;
                Navigator.of(dialogContext).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                confirmed = true;
                Navigator.of(dialogContext).pop();
              },
              child: Text('Continuer'),
            ),
          ],
        );
      },
    );
    return confirmed;
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Appelle le serveur pour récupérer tous les fichiers du répertoire du serial
  Future<List<Map<String, dynamic>>> getAllFilesOnServer(String serial) async {
    if(global.MyMachineN02Config.HasWebAcess==1){
        final uri =
          Uri.parse('https://naxe.fr/naxen02/file_list.php?serial=$serial');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer 9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825',
      });

      if (response.statusCode == 200) {
        print(response.body);
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          return List<Map<String, dynamic>>.from(json['files']);
        } else {
          throw Exception('Erreur du serveur : ${json['message']}');
        }
      }
      throw Exception('Erreur lors de la récupération des fichiers ${response.statusCode}');
    }
    throw Exception('no web access');
  }

  Future<String> sendLogFileToServer(
      String serial, String logContent, String filename) async {
    if(global.MyMachineN02Config.HasWebAcess==1){
        final uri = Uri.parse('https://naxe.fr/naxen02/upload_log.php');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer 9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'serial': serial,
          'filename': filename,
          'content': logContent,
        }),
      );

      if (response.statusCode == 200) {
        return 'ok';
      } else {
        return 'nok';
      }
      
    }
    return 'no web access';
  }

  /// Télécharger un fichier individuel
  Future<String> downloadFileFromServer(String serial, String filename) async {
    if (global.MyMachineN02Config.HasWebAcess==1){
        final uri = Uri.parse(
          'https://naxe.fr/naxen02/get_file.php?serial=$serial&filename=${Uri.encodeComponent(filename)}');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $_token'
      }).timeout(Duration(seconds: 3));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Erreur téléchargement $filename');
      }
    }
    else{
      return 'no web acess';
    } 
    
  }
}
