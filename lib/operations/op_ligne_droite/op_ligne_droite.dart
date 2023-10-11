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

  double ParamDe = 0; // Décalage

  OperationLigneDroite(
      {required super.OriginZ,
      required super.OriginY,
      required super.OriginX,
      super.label,
      required this.ParamA,
      required this.ParamC,
      required this.ParamDf,
      required this.ParamAP,
      required this.ParamDe});

  @override
  Future<void> construct() async {
    trajectoires.add(';$label');
    trajectoires.add('M453');
    trajectoires.add('G0 Z10 F1500');

    trajectoires.add('M5');
    trajectoires.add('M3 P0 S10000');
    trajectoires.add('G4 S2');

    if (ParamDf == 0) {
      for (double i = ParamAP; i <= ParamC; i += ParamAP) {
        trajectoires.add('G0 Y' +
            (OriginY).toString() +
            ' X' +
            (OriginX + ParamDe).toString());
        trajectoires.add('G0 Z' + (-i).toString());
        trajectoires.add('G1 Y' +
            (OriginY + ParamA).toString() +
            ' X' +
            (OriginX + ParamDe).toString());
        trajectoires.add('G0 Z2');
      }
      trajectoires.add('G0 Y' +
          (OriginY).toString() +
          ' X' +
          (OriginX + ParamDe).toString());
      trajectoires.add('G0 Z' + (-ParamC).toString());
      trajectoires.add('G1 Y' +
          (OriginY + ParamA).toString() +
          ' X' +
          (OriginX + ParamDe).toString());
    } else if (ParamA == 0) {
      for (double i = ParamAP; i <= ParamC; i += ParamAP) {
        trajectoires.add('G0 Y' +
            (OriginY + ParamDe).toString() +
            ' X' +
            (OriginX).toString());
        trajectoires.add('G0 Z' + (-i).toString());
        trajectoires.add('G1 Y' +
            (OriginY + ParamDe).toString() +
            ' X' +
            (OriginX + ParamDf).toString());
        trajectoires.add('G0 Z2');
      }
      trajectoires.add('G0 Y' +
          (OriginY + ParamDe).toString() +
          ' X' +
          (OriginX).toString());
      trajectoires.add('G0 Z' + (-ParamC).toString());
      trajectoires.add('G1 Y' +
          (OriginY + ParamDe).toString() +
          ' X' +
          (OriginX + ParamDf).toString());
    } else {
      for (double i = ParamAP; i <= ParamC; i += ParamAP) {
        trajectoires.add('G0 X$OriginX Y$OriginY');
        trajectoires.add('G0 Z' + (-i).toString());
        trajectoires.add('G1 X' +
            (OriginX + ParamDf).toString() +
            ' Y' +
            (OriginY + ParamA).toString());
        trajectoires.add('G0 Z2');
      }
      trajectoires.add('G0 X$OriginX Y$OriginY');
      trajectoires.add('G0 Z' + (-ParamC).toString());
      trajectoires.add('G1 X' +
          (OriginX + ParamDf).toString() +
          ' Y' +
          (OriginY + ParamA).toString());
    }

    trajectoires.add('G0 Z10');
    trajectoires.add('M5');

    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add(';End of $label\n');
    trajectoires.forEach((element) {
      print(element);
    });
  }
}
