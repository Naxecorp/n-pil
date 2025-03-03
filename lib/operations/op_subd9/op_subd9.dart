import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import '../operation.dart';

class OperationDb9 extends Operation {
  double ParamC = 3;
  double ParamAP = 1;

  OperationDb9(
      {required super.OriginZ,
      required super.OriginY,
      required super.OriginX,
      super.label,
      required this.ParamC,
      required this.ParamAP});

  Future<String> loadsubd9GcodeFromAsset() async {
    String tutu = await rootBundle.loadString('assets/convGcode/subd9.txt');
    return tutu;
  }

  @override
  Future<void> construct() async {
    trajectoires.add(';$label');
    trajectoires.add('G0 X$OriginX Y$OriginY Z$OriginZ');
    trajectoires.add('G1 Z1');
    trajectoires.add('G1 X-3.66 Y2.60');

    for (int j = 1; j * ParamAP <= ParamC; j++) {
      trajectoires.add('G1 Z-' + (j * ParamAP).toString());
      trajectoires.add(await loadsubd9GcodeFromAsset());
    }
    trajectoires.add(';End of $label\n');
  }
}
