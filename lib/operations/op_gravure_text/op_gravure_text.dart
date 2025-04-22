// Fonction Dart pour générer du G-code à partir d’un texte lettre par lettre via des fichiers .PLT
import 'dart:math' as Math;
import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> convertPltToGCode({
  required String pltContent,
  required double scale,
  required double engravingDepth,
  double offsetX = 0.0,
  double offsetY = 0.0,
}) async {
  final List<String> gcode = [];

  bool penDown = false;
  List<String> lines = pltContent.split(RegExp(r'[;\r\n]+')).map((l) => l.trim()).toList();
  double lastX = 0;
  double lastY = 0;

  for (String line in lines) {
    if (line.isEmpty) continue;

    if (line.startsWith('PU') || line.startsWith('PD')) {
      penDown = line.startsWith('PD');
      final coords = line.substring(2).split(',').map((e) => e.trim()).toList();

      for (int i = 0; i < coords.length - 1; i += 2) {
        double x = double.parse(coords[i]) * scale + offsetX;
        double y = double.parse(coords[i + 1]) * scale + offsetY;

        if (penDown) {
          gcode.add('G0 Z1');
          gcode.add('G0 X${lastX.toStringAsFixed(3)} Y${lastY.toStringAsFixed(3)}');
          gcode.add('G1 Z-${engravingDepth.toStringAsFixed(3)}');
          gcode.add('G1 X${x.toStringAsFixed(3)} Y${y.toStringAsFixed(3)}');
          gcode.add('G0 Z1');
        }

        lastX = x;
        lastY = y;
      }
    }
  }

  return gcode;
}

Future<List<String>> generateTextFromPltAlphabet({
  required String text,
  required double scale,
  required double engravingDepth,
  required double letterSpacing,
}) async {
  final List<String> gcode = [];
  gcode.add('; G-code from PLT alphabet');
  gcode.add('G0 Z10');
  gcode.add('M3 S10000');

  double cursorX = 0;

  for (var char in text.toUpperCase().split('')) {
    if (!RegExp(r'[A-Z]').hasMatch(char)) continue;

    try {
      final plt = await rootBundle.loadString('assets/svg/${char}.plt');
      final letterGCode = await convertPltToGCode(
        pltContent: plt,
        scale: scale,
        engravingDepth: engravingDepth,
        offsetX: cursorX,
        offsetY: 0.0,
      );
      gcode.addAll(letterGCode);
    } catch (e) {
      gcode.add('; Letter $char not found');
    }

    cursorX += letterSpacing;
  }

  gcode.add('G0 Z10');
  gcode.add('M5');
  gcode.add('; End of PLT text generation');
  return gcode;
}
