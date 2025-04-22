import 'dart:async' show Future;
import '../operation.dart';
  import 'dart:math' as Math;

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

  double radius = ParamDf / 2;
  double previousDepth = 0;

  for (double j = ParamAP; j < ParamC; j += ParamAP) {
    double currentDepth = -j;
    double startZ = previousDepth + 1; // 1 mm au-dessus de la passe précédente
    double endZ = currentDepth;

    double totalDepth = startZ - endZ; // positive value
    int helixSteps = (totalDepth / (ParamAP / 5)).ceil();
    double deltaZ = totalDepth / helixSteps;

    // Sécurité remontée + recentrage
    trajectoires.add('G0 Z${OriginZ + 3}');
    trajectoires.add('G0 X$OriginX Y$OriginY');

    // ✅ Hélice descendante
    for (int s = 0; s <= helixSteps; s++) {
      double angle = 2 * Math.pi * s / helixSteps;
      double x = OriginX + radius * Math.cos(angle);
      double y = OriginY + radius * Math.sin(angle);
      double z = startZ - deltaZ * s;
      trajectoires.add('G1 X${x.toStringAsFixed(3)} Y${y.toStringAsFixed(3)} Z${z.toStringAsFixed(3)} F750');
    }

    // ✅ Fraisage circulaire
    for (double i = (ParamDf / 2); i < ((ParamD / 2) - (ParamDf / 2)); i += (ParamDf / 2)) {
      double x = OriginX - i;
      trajectoires.add('G1 X${x.toStringAsFixed(3)}');
      trajectoires.add('G2 X${x.toStringAsFixed(3)} I$i');
    }

    double dernierX = (OriginX - (ParamD / 2)) + (ParamDf / 2);
    double dernierI = (ParamD / 2) - (ParamDf / 2);
    trajectoires.add('G1 X${dernierX.toStringAsFixed(3)}');
    trajectoires.add('G2 X${dernierX.toStringAsFixed(3)} I${dernierI.toStringAsFixed(3)}');

    previousDepth = currentDepth;
  }

  // ✅ Dernière descente à fond
  trajectoires.add('G1 Z-${ParamC.toString()}');

  // Dernier cercle
  for (double i = (ParamDf / 2); i < ((ParamD / 2) - (ParamDf / 2)); i += (ParamDf / 2)) {
    double x = OriginX - i;
    trajectoires.add('G1 X${x.toStringAsFixed(3)}');
    trajectoires.add('G2 X${x.toStringAsFixed(3)} I$i');
  }

  double dernierX = (OriginX - (ParamD / 2)) + (ParamDf / 2);
  double dernierI = (ParamD / 2) - (ParamDf / 2);
  trajectoires.add('G1 X${dernierX.toStringAsFixed(3)}');
  trajectoires.add('G2 X${dernierX.toStringAsFixed(3)} I${dernierI.toStringAsFixed(3)}');

  // Fin de programme
  trajectoires.add('G0 Z10');
  trajectoires.add('M5');
  trajectoires.add(';End of $label\n');

  trajectoires.forEach((element) => print(element));
}

}
