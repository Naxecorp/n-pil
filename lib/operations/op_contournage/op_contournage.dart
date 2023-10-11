import 'package:flutter/cupertino.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import '../operation.dart';

class OperationContournage extends Operation {
  double ParamA = 50;
  double ParamB = 100;
  double ParamC = 3;
  double ParamDf = 3;
  double ParamAP = 0.3;

  OperationContournage(
      {required super.OriginZ,
      required super.OriginY,
      required super.OriginX,
      super.label,
      required this.ParamA,
      required this.ParamB,
      required this.ParamC,
      required this.ParamDf,
      required this.ParamAP});

  @override
  Future<void> construct() async {
    trajectoires.add(';$label');
    trajectoires.add('M453');
    trajectoires.add('G0 Z10 F1500');
    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add('M5');
    trajectoires.add('M3 P0 S10000');
    trajectoires.add('G4 S2');

    for (int j = 1; j * ParamAP <= ParamC; j++) {}

    trajectoires.add(';End of $label\n');
  }
}
