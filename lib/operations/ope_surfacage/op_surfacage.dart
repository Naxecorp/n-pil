import 'package:flutter/cupertino.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import '../operation.dart';

class OperationSurfacage extends Operation {
  double ParamA = 10; // Y
  double ParamB = 10; // X
  double ParamC = 1; // Z
  double ParamDf = 3;
  double ParamAP = 0.3;
  double ParamDecalage = 4;

  OperationSurfacage(
      {required super.OriginZ,
      required super.OriginY,
      required super.OriginX,
      super.label,
      required this.ParamA,
      required this.ParamB,
      required this.ParamC,
      required this.ParamDf,
      required this.ParamAP,
      required this.ParamDecalage});

  @override
  void showValues() {
    print('OriginX: $OriginX');
    print('OriginY: $OriginY');
    print('OriginZ: $OriginZ');
    print('ParamA: $ParamA');
    print('ParamB: $ParamB');
    print('ParamC: $ParamC');
    print('ParamDf: $ParamDf');
    print('ParamAp: $ParamAP');
    print('ParamamDecalage: $ParamDecalage');
  }

  @override
  Future<void> construct() async {
    trajectoires.add(';$label');
    trajectoires.add('M453');

    trajectoires.add('G0 Z10 F1500');
    trajectoires.add('M5');
    trajectoires.add('M3 P0 S10000');
    trajectoires.add('G4 S2');

    for (double i = ParamAP; i <= ParamC; i += ParamAP) {
      for (double j = (OriginY + ParamA + ParamDecalage);
          j > OriginY;
          j -= (ParamDf / 2)) {
        trajectoires
            .add('G0 X${(OriginX + ParamB + ParamDecalage).toString()} Y$j');
        trajectoires.add('G1 Z${(-i).toString()}');
        trajectoires.add('G1 X${OriginX - ParamDecalage}');
        trajectoires.add('G0 Z5');

        if (j < OriginY + (ParamDf / 2)) {
          trajectoires.add(
              'G0 X${(OriginX + ParamB + ParamDecalage).toString()} Y${(OriginY - ParamDecalage).toString()}');
          trajectoires.add('G1 Z${(-i).toString()}');
          trajectoires.add('G1 X${OriginX - ParamDecalage}');
          trajectoires.add('G0 Z5');
        }
      }
    }
    for (double t = (OriginY + ParamA + ParamDecalage);
        t > OriginY;
        t -= (ParamDf / 2)) {
      trajectoires
          .add('G0 X${(OriginX + ParamB + ParamDecalage).toString()} Y$t');
      trajectoires.add('G1 Z${(0 - ParamC).toString()}');
      trajectoires.add('G1 X${(OriginX - ParamDecalage).toString()}');
      trajectoires.add('G0 Z5');

      if (t < OriginY + (ParamDf / 2)) {
        trajectoires.add(
            'G0 X${(OriginX + ParamB + ParamDecalage).toString()} Y${(OriginY - ParamDecalage).toString()}');
        trajectoires.add('G1 Z${(0 - ParamC).toString()}');
        trajectoires.add('G1 X${(OriginX - ParamDecalage).toString()}');
        trajectoires.add('G0 Z5');
      }
    }
    trajectoires.add('G0 Z50');
    trajectoires.add('M5');
    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add(';End of $label\n');
  }
}
