import 'dart:async' show Future;
import '../operation.dart';

class OperationPocheRonde extends Operation {
  double ParamD = 20; // diametre
  double ParamC = 3; // profondeur

  double ParamDf = 3;
  double ParamAP = 3;

  OperationPocheRonde(
      {required super.OriginZ,
      required super.OriginY,
      required super.OriginX,
      super.label,
      required this.ParamD,
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
    trajectoires.add('G0 Z$OriginZ');

    for (double j = ParamAP; j < ParamC; j += ParamAP) {
      trajectoires.add('G1 X${((OriginX) - (ParamDf / 2)).toString()}');
      trajectoires.add('G1 Z${(0 - j).toString()}');

      for (double i = (ParamDf / 2);
          i < ((ParamD / 2) - (ParamDf / 2));
          i += (ParamDf / 2)) {
        trajectoires.add('G1 X${(OriginX - i).toString()}');
        trajectoires.add('G2 X${(OriginX - i).toString()}  I$i');
      }
      trajectoires
          .add('G1 X${((OriginX - (ParamD / 2)) + (ParamDf / 2)).toString()}');
      trajectoires.add(
          'G2 X+${((OriginX - (ParamD / 2)) + (ParamDf / 2)).toString()} I${((ParamD / 2) - (ParamDf / 2)).toString()}');
    }
    trajectoires.add('G1 Z-$ParamC');
    for (double i = (ParamDf / 2);
        i < ((ParamD / 2) - (ParamDf / 2));
        i += (ParamDf / 2)) {
      trajectoires.add('G1 X${(OriginX - i).toString()}');
      trajectoires.add('G2 X${(OriginX - i).toString()} I$i');
    }
    trajectoires
        .add('G1 X${((OriginX - (ParamD / 2)) + (ParamDf / 2)).toString()}');
    trajectoires.add(
        'G2 X${((OriginX - (ParamD / 2)) + (ParamDf / 2)).toString()} I${((ParamD / 2) - (ParamDf / 2)).toString()}');

    trajectoires.add('G0 Z10');
    trajectoires.add('M5');
    trajectoires.add(';End of $label\n');
    trajectoires.forEach((element) {
      print(element);
    });
  }
}
