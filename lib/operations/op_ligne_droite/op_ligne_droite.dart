import 'package:flutter/cupertino.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import '../operation.dart';

class OperationLigneDroite extends Operation {
  double ParamA = 0; // Y
  double ParamDf = 0; // X

  double ParamC = 1; // pronfondeur
  double ParamAP = 0.3; // profondeur de passe

  OperationLigneDroite({
    required super.OriginZ,
    required super.OriginY,
    required super.OriginX,
    super.label,
    required this.ParamA,
    required this.ParamC,
    required this.ParamDf,
    required this.ParamAP,
  });

  List<String> generateGcodeForLine(double startX, double startY, double startZ,
      double lengthX, double lengthY, double totalDepth, double stepDepthInMM) {
    List<String> gcodeTrajectories = [];

    double endX = startX + lengthX;
    double endY = startY + lengthY;

    // Cas où lengthX ou lengthY est égal à 0
    if (lengthX == 0) {
      // Générer les passes successives uniquement selon l'axe Y
      for (double currentDepth = stepDepthInMM;
          currentDepth <= totalDepth;
          currentDepth += stepDepthInMM) {
        // Ajouter le Gcode pour descendre à la profondeur actuelle
        gcodeTrajectories.add('G1 Z${startZ - currentDepth}');

        // Ajouter le Gcode pour tracer la ligne à la profondeur actuelle
        gcodeTrajectories.add('G1 Y$endY Z${startZ - currentDepth}');

        // ... (La logique pour remonter à la surface, si nécessaire)
      }
    } else if (lengthY == 0) {
      // Générer les passes successives uniquement selon l'axe X
      for (double currentDepth = stepDepthInMM;
          currentDepth <= totalDepth;
          currentDepth += stepDepthInMM) {
        // Ajouter le Gcode pour descendre à la profondeur actuelle
        gcodeTrajectories.add('G1 Z${startZ - currentDepth}');

        // Ajouter le Gcode pour tracer la ligne à la profondeur actuelle
        gcodeTrajectories.add('G1 X$endX Z${startZ - currentDepth}');

        // ... (La logique pour remonter à la surface, si nécessaire)
      }
    } else {
      // Générer les passes successives pour une ligne oblique
      for (double currentDepth = stepDepthInMM;
          currentDepth <= totalDepth;
          currentDepth += stepDepthInMM) {
        // Ajouter le Gcode pour descendre à la profondeur actuelle
        gcodeTrajectories.add('G1 Z${startZ - currentDepth}');

        // Ajouter le Gcode pour tracer la ligne à la profondeur actuelle
        gcodeTrajectories.add('G1 X$endX Y$endY Z${startZ - currentDepth}');

        // ... (La logique pour remonter à la surface, si nécessaire)
      }
    }

    // ... (La logique de remontée finale, si nécessaire)

    return gcodeTrajectories;
  }

  @override
  Future<void> construct() async {
    trajectoires.add(';$label');
    trajectoires.add('M453');
    trajectoires.add('G0 Z10 F1500');

    trajectoires.add('M5');
    trajectoires.add('M3 P0 S10000');
    trajectoires.add('G4 S2');

    List<String> generatedGcode = generateGcodeForLine(
      super.OriginX,
      super.OriginY,
      super.OriginZ,
      ParamDf,
      ParamA,
      ParamC,
      ParamAP,
    );

    trajectoires.addAll(generatedGcode);

    trajectoires.add('G0 Z10');
    trajectoires.add('M5');

    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add(';End of $label\n');
    trajectoires.forEach((element) {
      print(element);
    });
  }
}
