import 'dart:async' show Future;
import '../operation.dart';
import 'dart:math' as Math;

class OperationPocheCarre extends Operation {
  double ParamA = 50;
  double ParamB = 100;
  double ParamC = 3;
  double ParamDf = 3;
  double ParamAP = 0.3;

  OperationPocheCarre(
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
  print("origine X: $OriginX");
  print("origine Y: $OriginY");
  print("origine Z: $OriginZ");

  print("Param A: $ParamA");
  print("Param B: $ParamB");
  print("Param C: $ParamC");
  print("Param DF: $ParamDf");

  trajectoires.add(';$label');
  trajectoires.add('M453');

  trajectoires.add('G0 Z10 F1500');
  trajectoires.add('G0 X$OriginX Y$OriginY');
  trajectoires.add('M5');
  trajectoires.add('M3 P0 S10000');
  trajectoires.add('G4 S2');

  if ((ParamA / 2) > (ParamB / 2)) {
    for (double i = ParamAP; i <= ParamC; i += ParamAP) {
      // Remontée sécurité et retour à l'origine
      trajectoires.add('G0 Z${OriginZ + 3}');
      trajectoires.add('G0 X$OriginX Y$OriginY');

      // Entrée hélicoïdale
      int steps = 10;
      double radius = ParamDf / 2;
      double targetZ = -i;
      double deltaZ = targetZ / steps;

      for (int s = 0; s <= steps; s++) {
        double angle = 2 * Math.pi * s / steps;
        double x = OriginX + radius * Math.cos(angle);
        double y = OriginY + radius * Math.sin(angle);
        double z = deltaZ * s;
        trajectoires.add('G1 X${x.toStringAsFixed(3)} Y${y.toStringAsFixed(3)} Z${z.toStringAsFixed(3)} F750');
      }

      // Parcours de la poche
      for (double y = (ParamDf / 2); y < (ParamA / 2); y += (ParamDf / 2)) {
        double x = y;

        if (y < ((ParamA / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 Y${(OriginY + y)}');
        } else {
          trajectoires.add('G1 Y${(OriginY + ((ParamA / 2) - (ParamDf / 2)))}');
        }

        if (y < ((ParamB / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 X${(OriginX + x)}');
        } else {
          trajectoires.add('G1 X${(OriginX + ((ParamB / 2) - (ParamDf / 2)))}');
        }

        if (y < ((ParamA / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 Y${(OriginY - y)}');
        } else {
          trajectoires.add('G1 Y${(OriginY - ((ParamA / 2) - (ParamDf / 2)))}');
        }

        if (y < ((ParamB / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 X${(OriginX - x)}');
        } else {
          trajectoires.add('G1 X${(OriginX - ((ParamB / 2) - (ParamDf / 2)))}');
        }
      }
    }
  } else {
    for (double i = ParamAP; i <= ParamC; i += ParamAP) {
      // Remontée sécurité et retour à l'origine
      trajectoires.add('G0 Z${OriginZ + 3}');
      trajectoires.add('G0 X$OriginX Y$OriginY');

      // Entrée hélicoïdale
      int steps = 10;
      double radius = ParamDf / 2;
      double targetZ = -i;
      double deltaZ = targetZ / steps;

      for (int s = 0; s <= steps; s++) {
        double angle = 2 * Math.pi * s / steps;
        double x = OriginX + radius * Math.cos(angle);
        double y = OriginY + radius * Math.sin(angle);
        double z = deltaZ * s;
        trajectoires.add('G1 X${x.toStringAsFixed(3)} Y${y.toStringAsFixed(3)} Z${z.toStringAsFixed(3)} F750');
      }

      // Parcours de la poche
      for (double x = (ParamDf / 2); x < (ParamB / 2); x += (ParamDf / 2)) {
        double y = x;

        if (y < ((ParamA / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 Y${(OriginY + y)}');
        } else {
          trajectoires.add('G1 Y${(OriginY + ((ParamA / 2) - (ParamDf / 2)))}');
        }

        if (y < ((ParamB / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 X${(OriginX + x)}');
        } else {
          trajectoires.add('G1 X${(OriginX + ((ParamB / 2) - (ParamDf / 2)))}');
        }

        if (y < ((ParamA / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 Y${(OriginY - y)}');
        } else {
          trajectoires.add('G1 Y${(OriginY - ((ParamA / 2) - (ParamDf / 2)))}');
        }

        if (y < ((ParamB / 2) - (ParamDf / 2))) {
          trajectoires.add('G1 X${(OriginX - x)}');
        } else {
          trajectoires.add('G1 X${(OriginX - ((ParamB / 2) - (ParamDf / 2)))}');
        }
      }
    }
  }

  // Nettoyage du contour final
  trajectoires.add('G1 Y${(OriginY + ((ParamA / 2) - (ParamDf / 2)))}');
  trajectoires.add('G1 X${(OriginX + ((ParamB / 2) - (ParamDf / 2)))}');
  trajectoires.add('G1 Y${(OriginY - ((ParamA / 2) - (ParamDf / 2)))}');
  trajectoires.add('G1 X${(OriginX - ((ParamB / 2) - (ParamDf / 2)))}');

  trajectoires.add('G0 Z10');
  trajectoires.add('M5');
  trajectoires.add(';End of $label\n');

  trajectoires.forEach((element) => print(element));
}

}
