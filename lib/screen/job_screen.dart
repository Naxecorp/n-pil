import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:nweb/dashBoardWidgets/laser_power.dart';
import 'package:nweb/dashBoardWidgets/print_tool.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../widgetUtils/window.dart';
import '../widgetUtils/account_toolbar_button.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../dashBoardWidgets/coord_machine.dart';
import '../dashBoardWidgets/vitesse_broche.dart';
import '../dashBoardWidgets/baby_stepZ.dart';
import '../dashBoardWidgets/job_info.dart';
import '../dashBoardWidgets/coef_vitesse.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/ArretUrgence.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class _RemoteJobFileRef {
  _RemoteJobFileRef({
    required this.directory,
    required this.fileName,
  });

  final String directory;
  final String fileName;

  String get cacheKey => '$directory/$fileName';
}

class _GcodeLineView {
  _GcodeLineView({
    required this.lineNumber,
    required this.content,
    required this.isCursorLine,
  });

  final int lineNumber;
  final String content;
  final bool isCursorLine;
}

enum _JobPanelMode {
  gcode,
  mode3d,
  hybrid,
}

class JobScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JobScreenState();
  }
}

class JobScreenState extends State<JobScreen> {
  static const int _contextLinesAroundCursor = 70;
  static const double _gcodeLineHeight = 22.0;

  double sliderValue = 0;
  double sliderValueSpeedFactor = 0;
  double? SpindleSpeedBeforePause = 0;
  StreamSubscription? _machineModelSubscription;
  Timer? _gcodeRefreshTimer;
  final ScrollController _gcodeScrollController = ScrollController();
  final DiTreDiController _diTreDiController =
      DiTreDiController(light: vector.Vector3(-0.5, -0.5, 0.5));
  bool _isManagingGcodeCache = false;
  bool _isDownloadingGcode = false;
  bool _isSimulationMode = false;
  _JobPanelMode _jobPanelMode = _JobPanelMode.hybrid;
  File? _cachedJobFile;
  String? _cachedJobRemoteKey;
  String _cachedJobLabel = "";
  String _gcodeStatusMessage = "Aucun job actif.";
  int _cachedFileLengthBytes = 0;
  int _cursorLineIndex = -1;
  int _lastRenderedCursorLine = -1;
  int _simulatedCursorLine = _contextLinesAroundCursor;
  int _simulationTicks = 0;
  int _lastParsedTrajectoryLine = -1;
  bool _isAbsoluteCoordinates = true;
  double _unitFactor = 1.0;
  vector.Vector3 _currentToolPosition = vector.Vector3.zero();
  List<int> _lineStartOffsets = <int>[];
  List<_GcodeLineView> _visibleGcodeLines = <_GcodeLineView>[];
  final List<Line3D> _executedTrajectoryLines = <Line3D>[];

  @override
  void initState() {
    pageToShow = 4;
    super.initState();
    _machineModelSubscription = global.streamMachineObjectModel.listen((value) {
      if (!mounted) return;
      setState(() {});
    });
    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (global.MyMachineN02Config.HasFanOnEnclosure == 1)
        global.checkCaissonOpen(context);
    });

    sliderValue =
        global.machineObjectModel.result?.spindles?[0].current?.toDouble() ??
            24000;
    sliderValue = sliderValue / 24000;
    sliderValueSpeedFactor =
        global.objectModelMove.result?.speedFactor?.toDouble() ?? 2;
    sliderValueSpeedFactor = sliderValueSpeedFactor / 2;

    _gcodeRefreshTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      _handleGcodeCacheLifecycle();
    });
    Future.microtask(
        () => _handleGcodeCacheLifecycle(forceWindowRefresh: true));
  }

  @override
  void dispose() {
    _machineModelSubscription?.cancel();
    _gcodeRefreshTimer?.cancel();
    _gcodeScrollController.dispose();
    _deleteCachedJobFile();
    super.dispose();
  }

  Future<void> _handleGcodeCacheLifecycle(
      {bool forceWindowRefresh = false}) async {
    if (_isManagingGcodeCache || !mounted) return;
    _isManagingGcodeCache = true;

    try {
      if (_isSimulationMode) {
        _simulationTicks++;
        if (_simulationTicks % 2 == 0 &&
            _simulatedCursorLine < _lineStartOffsets.length - 1) {
          _simulatedCursorLine++;
        }
        await _refreshVisibleGcodeWindow(force: true);
        return;
      }

      final bool isJobActive = _isJobActive();

      if (!isJobActive) {
        await _clearCachedJobData();
        return;
      }

      final bool cacheReady = await _ensureCachedFileReady();
      if (!cacheReady) return;

      await _refreshVisibleGcodeWindow(force: forceWindowRefresh);
    } finally {
      _isManagingGcodeCache = false;
    }
  }

  bool _isJobActive() {
    if (_isSimulationMode) return true;

    final String status =
        global.machineObjectModel.result?.state?.status?.toString() ?? "";
    final int filePosition =
        (global.machineObjectModel.result?.job?.filePosition ?? 0).toInt();

    if (status == "processing" ||
        status == "paused" ||
        status == "pausing" ||
        status == "resuming") {
      return true;
    }

    return status != "idle" && filePosition > 0;
  }

  Future<void> _clearCachedJobData() async {
    final bool hadCache = _cachedJobFile != null ||
        _cachedJobRemoteKey != null ||
        _visibleGcodeLines.isNotEmpty;

    await _deleteCachedJobFile();

    if (!mounted) return;
    if (!hadCache && _gcodeStatusMessage == "Aucun job actif.") return;

    setState(() {
      _cachedJobFile = null;
      _cachedJobRemoteKey = null;
      _cachedJobLabel = "";
      _cachedFileLengthBytes = 0;
      _lineStartOffsets = <int>[];
      _visibleGcodeLines = <_GcodeLineView>[];
      _cursorLineIndex = -1;
      _lastRenderedCursorLine = -1;
      _simulatedCursorLine = _contextLinesAroundCursor;
      _simulationTicks = 0;
      _gcodeStatusMessage = "Aucun job actif.";
      _resetTrajectoryState();
    });
  }

  Future<void> _deleteCachedJobFile() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/job.g');
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (_) {}
  }

  Future<bool> _ensureCachedFileReady() async {
    final _RemoteJobFileRef? fileRef = await _resolveRunningJobFileRef();
    if (fileRef == null) {
      _updateStatusMessage(
          "Job actif mais nom de fichier indisponible pour le moment.");
      return false;
    }

    if (_cachedJobRemoteKey == fileRef.cacheKey &&
        _cachedJobFile != null &&
        await _cachedJobFile!.exists() &&
        _lineStartOffsets.isNotEmpty) {
      return true;
    }

    if (_isDownloadingGcode) return false;
    _isDownloadingGcode = true;

    try {
      _updateStatusMessage("Téléchargement du G-code en cours...");
      final bool downloaded = await API_Manager()
          .dlFileToTempDir(fileRef.directory, fileRef.fileName);
      if (!downloaded) {
        _updateStatusMessage("Impossible de télécharger le G-code en cours.");
        return false;
      }

      final Directory tempDir = await getTemporaryDirectory();
      final File localFile = File('${tempDir.path}/job.g');
      if (!await localFile.exists()) {
        _updateStatusMessage("Le cache local du G-code est introuvable.");
        return false;
      }

      await _buildLineOffsetIndex(localFile);
      if (!mounted) return false;

      setState(() {
        _cachedJobFile = localFile;
        _cachedJobRemoteKey = fileRef.cacheKey;
        _cachedJobLabel = fileRef.fileName;
        _lastRenderedCursorLine = -1;
        _resetTrajectoryState();
        _gcodeStatusMessage = "G-code chargé. Suivi en direct actif.";
      });
      return true;
    } finally {
      _isDownloadingGcode = false;
    }
  }

  Future<_RemoteJobFileRef?> _resolveRunningJobFileRef() async {
    String? rawPath = global.objectModelJob.result?.file?.fileName;

    if (rawPath == null || rawPath.trim().isEmpty) {
      try {
        final job = await API_Manager().getMachineJobObjectModel();
        global.objectModelJob = job;
        rawPath = job.result?.file?.fileName;
      } catch (_) {}
    }

    if ((rawPath == null || rawPath.trim().isEmpty) &&
        global.progName.isNotEmpty) {
      rawPath = 'gcodes/${global.progName}';
    }

    if (rawPath == null || rawPath.trim().isEmpty) {
      return null;
    }

    String normalized = rawPath.trim().replaceAll("\\", "/");
    normalized = normalized.replaceFirst(RegExp(r"^0:/"), "");
    normalized = normalized.replaceFirst(RegExp(r"^/+"), "");
    if (normalized.isEmpty) return null;

    final List<String> parts =
        normalized.split("/").where((String e) => e.trim().isNotEmpty).toList();
    if (parts.isEmpty) return null;

    final String fileName = parts.removeLast();
    final String directory = parts.isEmpty ? "gcodes" : parts.join("/");
    return _RemoteJobFileRef(directory: directory, fileName: fileName);
  }

  Future<void> _buildLineOffsetIndex(File file) async {
    final List<int> lineStarts = <int>[0];
    int offset = 0;

    await for (final List<int> chunk in file.openRead()) {
      for (final int byte in chunk) {
        offset++;
        if (byte == 10) {
          lineStarts.add(offset);
        }
      }
    }

    if (lineStarts.length > 1 && lineStarts.last == offset) {
      lineStarts.removeLast();
    }

    _lineStartOffsets = lineStarts;
    _cachedFileLengthBytes = offset;
  }

  void _resetTrajectoryState() {
    _executedTrajectoryLines.clear();
    _lastParsedTrajectoryLine = -1;
    _isAbsoluteCoordinates = true;
    _unitFactor = 1.0;
    _currentToolPosition = vector.Vector3.zero();
  }

  Future<void> _updateTrajectoryUntilCursor(int cursorLine) async {
    if (_cachedJobFile == null || _lineStartOffsets.isEmpty) return;

    if (cursorLine < _lastParsedTrajectoryLine) {
      _resetTrajectoryState();
    }

    final int startLine = _lastParsedTrajectoryLine + 1;
    if (cursorLine < startLine) return;

    final List<String> lines = await _readRawLinesRange(startLine, cursorLine);
    if (lines.isEmpty) return;

    _appendTrajectoryFromLines(lines);
    _lastParsedTrajectoryLine = cursorLine;
  }

  Future<List<String>> _readRawLinesRange(int startLine, int endLine) async {
    if (_cachedJobFile == null ||
        _lineStartOffsets.isEmpty ||
        startLine > endLine) {
      return <String>[];
    }

    final int totalLines = _lineStartOffsets.length;
    final int safeStart = startLine.clamp(0, totalLines - 1);
    final int safeEnd = endLine.clamp(safeStart, totalLines - 1);

    final int startByte = _lineStartOffsets[safeStart];
    final int endByteExclusive = (safeEnd + 1 < totalLines)
        ? _lineStartOffsets[safeEnd + 1]
        : _cachedFileLengthBytes;

    if (endByteExclusive <= startByte) return <String>[];

    final RandomAccessFile raf = await _cachedJobFile!.open();
    try {
      await raf.setPosition(startByte);
      final List<int> bytes = await raf.read(endByteExclusive - startByte);
      final String chunk = utf8.decode(bytes, allowMalformed: true);
      final List<String> lines = const LineSplitter().convert(chunk);
      final int expectedCount = safeEnd - safeStart + 1;
      if (lines.length <= expectedCount) return lines;
      return lines.sublist(0, expectedCount);
    } finally {
      await raf.close();
    }
  }

  void _appendTrajectoryFromLines(List<String> lines) {
    for (final String rawLine in lines) {
      final String line = rawLine.split(";").first.trim();
      if (line.isEmpty) continue;

      final List<String> parts = line
          .toUpperCase()
          .split(RegExp(r"\s+"))
          .where((String e) => e.isNotEmpty)
          .toList();
      if (parts.isEmpty) continue;

      final String cmd = parts.first;
      if (cmd == "G90") {
        _isAbsoluteCoordinates = true;
        continue;
      }
      if (cmd == "G91") {
        _isAbsoluteCoordinates = false;
        continue;
      }
      if (cmd == "G20") {
        _unitFactor = 25.4;
        continue;
      }
      if (cmd == "G21") {
        _unitFactor = 1.0;
        continue;
      }

      if (cmd == "G0" ||
          cmd == "G00" ||
          cmd == "G1" ||
          cmd == "G01" ||
          cmd == "G2" ||
          cmd == "G02" ||
          cmd == "G3" ||
          cmd == "G03") {
        final Map<String, double> axes = _extractAxisValues(parts.skip(1));
        if (axes.isEmpty) continue;

        final vector.Vector3 start = vector.Vector3.copy(_currentToolPosition);
        final vector.Vector3 end = vector.Vector3.copy(_currentToolPosition);

        if (axes.containsKey("X")) {
          final double xValue = axes["X"]! * _unitFactor;
          end.x = _isAbsoluteCoordinates ? xValue : end.x + xValue;
        }
        if (axes.containsKey("Y")) {
          final double yValue = axes["Y"]! * _unitFactor;
          end.y = _isAbsoluteCoordinates ? yValue : end.y + yValue;
        }
        if (axes.containsKey("Z")) {
          final double zValue = axes["Z"]! * _unitFactor;
          end.z = _isAbsoluteCoordinates ? zValue : end.z + zValue;
        }

        final Color color = (cmd == "G0" || cmd == "G00")
            ? Colors.orange.shade300
            : (cmd == "G2" || cmd == "G02" || cmd == "G3" || cmd == "G03")
                ? Colors.purple.shade300
                : Colors.blueGrey.shade700;

        if ((end - start).length2 > 0) {
          _executedTrajectoryLines.add(
            Line3D(
              _toViewerPoint(start),
              _toViewerPoint(end),
              width: 2,
              color: color,
            ),
          );
        }
        _currentToolPosition = end;
      }
    }
  }

  Map<String, double> _extractAxisValues(Iterable<String> tokens) {
    final Map<String, double> axes = <String, double>{};
    for (final String token in tokens) {
      if (token.length < 2) continue;
      final String axis = token[0];
      if (axis != "X" && axis != "Y" && axis != "Z") continue;
      final double? value =
          double.tryParse(token.substring(1).replaceAll(",", "."));
      if (value != null) {
        axes[axis] = value;
      }
    }
    return axes;
  }

  vector.Vector3 _toViewerPoint(vector.Vector3 machinePoint) {
    return vector.Vector3(machinePoint.x, machinePoint.z, machinePoint.y);
  }

  Future<void> _refreshVisibleGcodeWindow({bool force = false}) async {
    if (_cachedJobFile == null || _lineStartOffsets.isEmpty) return;

    final int cursorByte = _currentCursorByte();
    final int cursorLine = _lineIndexForBytePosition(cursorByte);
    if (!force && cursorLine == _lastRenderedCursorLine) return;

    await _updateTrajectoryUntilCursor(cursorLine);
    final List<_GcodeLineView> lines = await _readLinesAroundCursor(cursorLine);
    if (!mounted) return;

    setState(() {
      _cursorLineIndex = cursorLine;
      _lastRenderedCursorLine = cursorLine;
      _visibleGcodeLines = lines;
      if (lines.isEmpty) {
        _gcodeStatusMessage = "Aucune ligne à afficher.";
      } else {
        _gcodeStatusMessage =
            "Lignes ${lines.first.lineNumber}-${lines.last.lineNumber} / ${_lineStartOffsets.length}";
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerCursorLineInView();
    });
  }

  int _currentCursorByte() {
    if (_isSimulationMode && _lineStartOffsets.isNotEmpty) {
      final int safeIndex =
          _simulatedCursorLine.clamp(0, _lineStartOffsets.length - 1);
      return _lineStartOffsets[safeIndex];
    }

    return (global.machineObjectModel.result?.job?.filePosition ?? 0).toInt();
  }

  void _centerCursorLineInView() {
    if (!_gcodeScrollController.hasClients || _visibleGcodeLines.isEmpty)
      return;

    final int cursorIndex =
        _visibleGcodeLines.indexWhere((line) => line.isCursorLine);
    if (cursorIndex < 0) return;

    final ScrollPosition position = _gcodeScrollController.position;
    final double rawOffset = (cursorIndex * _gcodeLineHeight) -
        (position.viewportDimension / 2) +
        (_gcodeLineHeight / 2);

    final double targetOffset =
        rawOffset.clamp(0.0, position.maxScrollExtent).toDouble();

    if ((position.pixels - targetOffset).abs() > 1.0) {
      _gcodeScrollController.jumpTo(targetOffset);
    }
  }

  int _lineIndexForBytePosition(int bytePosition) {
    if (_lineStartOffsets.isEmpty) return 0;
    if (_cachedFileLengthBytes <= 0) return 0;

    final int clampedByte = bytePosition.clamp(0, _cachedFileLengthBytes - 1);
    int low = 0;
    int high = _lineStartOffsets.length - 1;
    int result = 0;

    while (low <= high) {
      final int mid = (low + high) >> 1;
      if (_lineStartOffsets[mid] <= clampedByte) {
        result = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return result;
  }

  Future<List<_GcodeLineView>> _readLinesAroundCursor(
      int cursorLineIndex) async {
    if (_cachedJobFile == null || _lineStartOffsets.isEmpty)
      return <_GcodeLineView>[];

    final int totalLines = _lineStartOffsets.length;
    final int safeCursor = cursorLineIndex.clamp(0, totalLines - 1);
    final int startLine =
        (safeCursor - _contextLinesAroundCursor).clamp(0, totalLines - 1);
    final int endLine =
        (safeCursor + _contextLinesAroundCursor).clamp(0, totalLines - 1);

    final int startByte = _lineStartOffsets[startLine];
    final int endByteExclusive = (endLine + 1 < totalLines)
        ? _lineStartOffsets[endLine + 1]
        : _cachedFileLengthBytes;

    if (endByteExclusive <= startByte) return <_GcodeLineView>[];

    final RandomAccessFile raf = await _cachedJobFile!.open();
    try {
      await raf.setPosition(startByte);
      final List<int> bytes = await raf.read(endByteExclusive - startByte);
      final String chunk = utf8.decode(bytes, allowMalformed: true);
      final List<String> lines = const LineSplitter().convert(chunk);

      final List<_GcodeLineView> result = <_GcodeLineView>[];
      for (int i = 0; i < lines.length; i++) {
        final int lineNumber = startLine + i + 1;
        if (lineNumber > endLine + 1) break;
        result.add(
          _GcodeLineView(
            lineNumber: lineNumber,
            content: lines[i].replaceAll("\r", ""),
            isCursorLine: (lineNumber - 1) == safeCursor,
          ),
        );
      }
      return result;
    } finally {
      await raf.close();
    }
  }

  void _updateStatusMessage(String message) {
    if (!mounted || _gcodeStatusMessage == message) return;
    setState(() {
      _gcodeStatusMessage = message;
    });
  }

  Future<void> _toggleSimulationMode() async {
    if (_isSimulationMode) {
      await _stopSimulationMode();
    } else {
      await _startSimulationMode();
    }
  }

  Future<void> _startSimulationMode() async {
    if (_isDownloadingGcode) return;
    _isDownloadingGcode = true;

    try {
      final File simulatedFile = await _createSimulationFile();
      await _buildLineOffsetIndex(simulatedFile);
      if (!mounted) return;

      setState(() {
        _isSimulationMode = true;
        _simulatedCursorLine = _contextLinesAroundCursor;
        _simulationTicks = 0;
        _cachedJobFile = simulatedFile;
        _cachedJobRemoteKey = "__simulation__/job.g";
        _cachedJobLabel = "job.g (SIMU)";
        _lastRenderedCursorLine = -1;
        _resetTrajectoryState();
        _gcodeStatusMessage = "Mode simulation actif.";
      });

      await _refreshVisibleGcodeWindow(force: true);
    } catch (_) {
      _updateStatusMessage("Impossible de lancer la simulation.");
    } finally {
      _isDownloadingGcode = false;
    }
  }

  Future<void> _stopSimulationMode() async {
    if (!mounted) return;
    setState(() {
      _isSimulationMode = false;
    });
    await _clearCachedJobData();
  }

  Future<File> _createSimulationFile() async {
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/job.g');
    final StringBuffer buffer = StringBuffer();

    buffer.writeln("; SIMULATION - JOB EN COURS");
    buffer.writeln("G90");
    buffer.writeln("G21");
    buffer.writeln("M3 S12000");
    for (int i = 1; i <= 1500; i++) {
      final double x = (i % 320).toDouble();
      final double y = ((i * 2) % 420).toDouble();
      final double z = (i % 15 == 0) ? -0.2 : -0.1;
      buffer.writeln(
          "N${i.toString().padLeft(5, '0')} G1 X${x.toStringAsFixed(3)} Y${y.toStringAsFixed(3)} Z${z.toStringAsFixed(3)} F2500");
      if (i % 120 == 0) {
        buffer.writeln(
            "N${(i + 1).toString().padLeft(5, '0')} G4 P0.2 ; pause simulation");
      }
    }
    buffer.writeln("M5");
    buffer.writeln("M30");

    await file.writeAsString(buffer.toString(), flush: true);
    return file;
  }

  String _panelModeLabel(_JobPanelMode mode) {
    switch (mode) {
      case _JobPanelMode.gcode:
        return "Gcode";
      case _JobPanelMode.mode3d:
        return "3D";
      case _JobPanelMode.hybrid:
        return "Hybride";
    }
  }

  Widget _buildModeSelector() {
    return Wrap(
      spacing: 6,
      children: _JobPanelMode.values.map((_JobPanelMode mode) {
        return ChoiceChip(
          label: Text(_panelModeLabel(mode)),
          selected: _jobPanelMode == mode,
          onSelected: (bool selected) {
            if (!selected) return;
            setState(() {
              _jobPanelMode = mode;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _centerCursorLineInView();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPanelContent() {
    switch (_jobPanelMode) {
      case _JobPanelMode.gcode:
        return _buildGcodeWindow();
      case _JobPanelMode.mode3d:
        return _build3DWindow();
      case _JobPanelMode.hybrid:
        return Column(
          children: [
            Expanded(
              flex: 5,
              child: _build3DWindow(),
            ),
            const Divider(height: 1),
            Expanded(
              flex: 6,
              child: _buildGcodeWindow(),
            ),
          ],
        );
    }
  }

  List<Line3D> _build3DFigures() {
    final List<Line3D> figures = <Line3D>[
      Line3D(
        vector.Vector3(0, 0, 0),
        vector.Vector3(40, 0, 0),
        width: 3,
        color: Colors.red,
      ),
      Line3D(
        vector.Vector3(0, 0, 0),
        vector.Vector3(0, 40, 0),
        width: 3,
        color: Colors.green,
      ),
      Line3D(
        vector.Vector3(0, 0, 0),
        vector.Vector3(0, 0, 40),
        width: 3,
        color: Colors.blue,
      ),
    ];

    figures.addAll(_executedTrajectoryLines);
    return figures;
  }

  Widget _build3DWindow() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: const Color(0xFFF8FAFB),
            child: DiTreDiDraggable(
              controller: _diTreDiController,
              child: DiTreDi(
                figures: _build3DFigures(),
                controller: _diTreDiController,
                config: const DiTreDiConfig(
                  supportZIndex: true,
                ),
              ),
            ),
          ),
        ),
        if (_executedTrajectoryLines.isEmpty)
          const Center(
            child: Text(
              "Aucune trajectoire executee pour le moment.",
              style: TextStyle(color: Color(0xFF707585)),
            ),
          ),
      ],
    );
  }

  Widget _buildLiveGcodePanel() {
    final int cursorByte = _currentCursorByte();
    final String machineStatus = _isSimulationMode
        ? "simulation"
        : (global.machineObjectModel.result?.state?.status?.toString() ??
            "unknown");
    final int totalLines = _lineStartOffsets.length;

    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F2),
              border: Border.all(color: const Color(0xFFB8D7D1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Suivi G-code en direct",
                        style: TextStyle(
                          color: Color(0xFF1F5E53),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                      child: OutlinedButton.icon(
                        onPressed: _toggleSimulationMode,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF20917F)),
                          foregroundColor: const Color(0xFF1F5E53),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        icon: Icon(
                          _isSimulationMode
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline,
                          size: 14,
                        ),
                        label: Text(_isSimulationMode ? "Stop Simu" : "Simu"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _cachedJobLabel.isEmpty
                      ? "Fichier : --"
                      : "Fichier : $_cachedJobLabel",
                  style: const TextStyle(
                    color: Color(0xFF355E56),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                _buildModeSelector(),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text(
                      "Status : $machineStatus",
                      style: const TextStyle(color: Color(0xFF4A6F68)),
                    ),
                    Text(
                      "Byte : $cursorByte",
                      style: const TextStyle(color: Color(0xFF4A6F68)),
                    ),
                    Text(
                      "Ligne : ${_cursorLineIndex >= 0 ? _cursorLineIndex + 1 : '--'} / ${totalLines > 0 ? totalLines : '--'}",
                      style: const TextStyle(color: Color(0xFF4A6F68)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Fenetre locale centree : 70 lignes avant / 70 lignes apres | $_gcodeStatusMessage",
                      style: const TextStyle(
                        color: Color(0xFF5D6170),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildPanelContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGcodeWindow() {
    if (_isDownloadingGcode) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_visibleGcodeLines.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            _gcodeStatusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF707585)),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _gcodeScrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemExtent: _gcodeLineHeight,
      itemCount: _visibleGcodeLines.length,
      itemBuilder: (BuildContext context, int index) {
        final _GcodeLineView line = _visibleGcodeLines[index];
        final bool isCursorLine = line.isCursorLine;

        return Container(
          color: isCursorLine ? const Color(0x5520917F) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  line.lineNumber.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: "monospace",
                    color: isCursorLine
                        ? const Color(0xFF1F8A76)
                        : const Color(0xFF8A8D99),
                    fontWeight:
                        isCursorLine ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  line.content.isEmpty ? " " : line.content,
                  style: const TextStyle(
                    fontFamily: "monospace",
                    fontSize: 12,
                    color: Color(0xFF2E3240),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: Color(0xFFF0F0F3),
        actions: const <Widget>[
          AccountToolbarButton(),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                    child: Image(image: AssetImage("assets/iconnaxe.png")))),
            Flexible(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: ManualGcodeComand,
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),
                            ),
                            onSubmitted: (Commande) {
                              setState(() {
                                global.commandHistory.add(Commande);
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then(
                                    (value) => API_Manager().sendrr_reply());
                              });
                            },
                          ),
                          PopupMenuButton<String>(
                            tooltip: "Historique",
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                ManualGcodeComand.text = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return global.commandHistory
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(flex: 4, child: _buildLiveGcodePanel()),
            Flexible(
              flex: 6,
              child: Container(
                // color: Colors.green,
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Column(
                        children: [
                          Flexible(flex: 80, child: JobInfo()),
                          Flexible(
                            flex: 50,
                            child: Container(
                              //color: Colors.green,
                              height: double.infinity,
                              //color: Colors.white,
                              margin: EdgeInsets.all(0),
                              child: Window(
                                title1: "Capteurs",
                                title2: " machine",
                                child: Container(
                                    //color: Colors.green,
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(1),
                                          //color: Colors.green,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Status",
                                                style: TextStyle(
                                                    color: Color(0xFF707585),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  global.machineObjectModel
                                                          .result?.state?.status
                                                          .toString() ??
                                                      "???",
                                                  style: TextStyle(
                                                      color: global
                                                                  .machineObjectModel
                                                                  .result
                                                                  ?.state
                                                                  ?.status
                                                                  .toString() ==
                                                              "pausing"
                                                          ? Colors.yellowAccent
                                                          : Color(0xFF707585))),
                                            ],
                                          ),
                                        )),
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(1),
                                          //color: Colors.green,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "MCU Température",
                                                style: TextStyle(
                                                    color: Color(0xFF707585),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      global.machineObjectModel
                                                              .result?.boards
                                                              ?.elementAt(0)
                                                              .mcuTemp
                                                              ?.current
                                                              ?.toStringAsFixed(
                                                                  1) ??
                                                          "...",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF707585))),
                                                  Text("°C",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF707585)))
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(1),
                                          //color: Colors.green,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "V12",
                                                style: TextStyle(
                                                    color: Color(0xFF707585),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    global.machineObjectModel
                                                            .result?.boards
                                                            ?.elementAt(0)
                                                            .v12
                                                            ?.current
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        "...",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF707585)),
                                                  ),
                                                  Text(" V",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF707585))),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        //color: Colors.green,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Vin",
                                              style: TextStyle(
                                                  color: Color(0xFF707585),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                    global.machineObjectModel
                                                            .result?.boards
                                                            ?.elementAt(0)
                                                            .vIn
                                                            ?.current
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        "...",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF707585))),
                                                Text(" V",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF707585))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        //color: Colors.green,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Driver(s)",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF707585),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          (global
                                                                          .machineObjectModel
                                                                          .result
                                                                          ?.sensors
                                                                          ?.gpIn?[
                                                                      9] ==
                                                                  null)
                                                              ? Icons
                                                                  .power_off_outlined
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[9]?.value ??
                                                                          0) ==
                                                                      0
                                                                  ? Icons
                                                                      .power_rounded
                                                                  : Icons
                                                                      .power_rounded,
                                                          color: (global
                                                                          .machineObjectModel
                                                                          .result
                                                                          ?.sensors
                                                                          ?.gpIn?[
                                                                      9] ==
                                                                  null)
                                                              ? Colors.grey
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[9]
                                                                              ?.value ??
                                                                          0) ==
                                                                      0
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Caisson",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF707585),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          (global.machineObjectModel.result?.sensors?.gpIn
                                                                              ?.length ??
                                                                          0) <
                                                                      11 ||
                                                                  global.machineObjectModel.result?.sensors
                                                                              ?.gpIn?[
                                                                          10] ==
                                                                      null
                                                              ? Icons
                                                                  .key_off_outlined
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[10]?.value ??
                                                                          1) ==
                                                                      1
                                                                  ? Icons.lock
                                                                  : Icons
                                                                      .lock_open_rounded,
                                                          color: (global.machineObjectModel.result?.sensors?.gpIn
                                                                              ?.length ??
                                                                          0) <
                                                                      11 ||
                                                                  global.machineObjectModel.result?.sensors
                                                                              ?.gpIn?[
                                                                          10] ==
                                                                      null
                                                              ? Colors.grey
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[10]
                                                                              ?.value ??
                                                                          1) ==
                                                                      1
                                                                  ? Colors.green
                                                                  : Colors.orange,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 70,
                              child: Container(
                                height: double.infinity,
                                //color: Colors.white,
                                margin: EdgeInsets.all(0),
                                child: Window(
                                  title1: "Coordonées",
                                  title2: " machine",
                                  child: CoordoneesMachine(),
                                ),
                              )),
                          Flexible(
                              flex: 70,
                              child: Container(
                                height: double.infinity,
                                //color: Colors.white,
                                margin: EdgeInsets.all(0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                        flex: 4,
                                        child: Window(
                                          title1: "Coordonées",
                                          title2: " outil",
                                          child: CoordoneesOutilSansBouton(),
                                        )),
                                    Flexible(
                                        flex: 2,
                                        child: Window(
                                          title1: "Vitesse",
                                          title2: " demandée",
                                          child: Center(
                                              child: Text(
                                                  "${global.machineObjectModel.result?.move?.currentMove?.requestedSpeed.toString() ?? "..."} mm/s")),
                                        )),
                                  ],
                                ),
                              )),
                          Flexible(
                            flex: 260,
                            child: Container(
                              height: double.infinity,
                              //color: Colors.white,
                              margin: EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      //color: Colors.pink,
                                      child: Column(
                                        children: [
                                          Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: CoefVitesse(),
                                              )),
                                          Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: BabyStepZ(),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: (global.machineMode ==
                                              global.MachineMode.cnc)
                                          ? VitesseBroche()
                                          : (global.machineMode ==
                                                  global.MachineMode.fff)
                                              ? PrintToolsTemperature()
                                              : LaserToolPower(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String tempStatus = global
                                            .machineObjectModel
                                            .result
                                            ?.state
                                            ?.status
                                            .toString() ??
                                        "";
                                    if (tempStatus == "paused") {
                                      API_Manager().sendGcodeCommand("M24");
                                      global.isJobPausedByUser = false;
                                    } else {
                                      API_Manager()
                                          .sendGcodeCommand("M25")
                                          .then((value) => API_Manager()
                                              .sendrr_reply()
                                              .then((value) => global
                                                  .isJobPausedByUser = true));
                                    }
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2B519B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: global.machineObjectModel
                                                          .result?.state?.status
                                                          .toString() ==
                                                      "paused"
                                                  ? Colors.orange
                                                  : global
                                                              .machineObjectModel
                                                              .result
                                                              ?.state
                                                              ?.status
                                                              .toString() ==
                                                          "pausing"
                                                      ? Colors.yellowAccent
                                                      : Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Pause Cycle',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: global.machineObjectModel.result
                                              ?.state?.status
                                              .toString() ==
                                          "paused"
                                      ? () async {
                                          await API_Manager()
                                              .sendGcodeCommand("M0");
                                          await API_Manager()
                                              .sendGcodeCommand("M106 P3 S0");
                                          API_Manager().pushDataToDb(
                                              global.MyMachineN02Config.Serie
                                                  .toString(),
                                              "PROGRAMM END UP BY USER");
                                          global.programmEndUpByUser = true;
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFCE711A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Stop Cycle'),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                )),
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                child: ArretUrgence(
                                  notifyParent: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
