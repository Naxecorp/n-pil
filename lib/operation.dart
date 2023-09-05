import 'package:flutter/cupertino.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';





class Operation {


  List<String> trajectoires = <String>[];

  double OriginX = 0;
  double OriginY = 0;
  double OriginZ = 0;
  final String? label;

  Operation({required this.OriginZ,required this.OriginY,required this.OriginX,this.label});

  void setOrigin(double _OriginX,double _OriginY,double _OriginZ)
  {
    OriginX = _OriginX;
    OriginY = _OriginY;
    OriginZ = _OriginZ;
  }



  void init() {
    trajectoires.add('Programe initial');
  }

  Future<void> construct ()async{

  }

  void showValues(){


  }


}

class OperationSurfacage extends Operation{


  double ParamA=10;
  double ParamB=10;
  double ParamC=1;
  double ParamDf=3;
  double ParamAP=0.3;
  double ParamDecalage=4;

  OperationSurfacage({required super.OriginZ, required super.OriginY, required super.OriginX,super.label, required this.ParamA,required this.ParamB,required this.ParamC,required this.ParamDf,required this.ParamAP,required this.ParamDecalage});


  @override
  void showValues(){
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
Future<void> construct ()async{

  trajectoires.add(';$label');
  trajectoires.add('M453');
  trajectoires.add('G0 Z10 F1500');
  //trajectoires.add('G0 X$OriginX Y$OriginY');
  trajectoires.add('M5');
  trajectoires.add('M3 P0 S10000');
  trajectoires.add('G4 S2');
  //trajectoires.add('G0 X' + (((ParamA/2)*-1)+ParamDf/2).toString() + ' Y'+ (((ParamB/2)*-1)+ParamDf/2).toString());
  //trajectoires.add('G0 Z$OriginZ');

  trajectoires.add('G1 Y'+((OriginY-(ParamB/2))+((ParamDf/2))).toString());
  trajectoires.add('G1 X'+((OriginX+(ParamA/2))+ParamDecalage).toString());

    for(int j = 1;j*ParamAP<=ParamC;j++)
    {

      for (int i = 0;(ParamB)-((ParamDf/2)*i)>0;i++)
      {
        trajectoires.add('G1 Y'+((OriginY-(ParamB/2))+((ParamDf/2))*i).toString());
        if (i.isEven)
        {
          trajectoires.add('G1 Z'+((OriginZ+1).toString()));
          trajectoires.add('G1 X'+((OriginX+(ParamA/2))+ParamDecalage).toString());
          trajectoires.add('G1 Z-'+(j*ParamAP).toString());
        }
        else trajectoires.add('G1 X'+(OriginX-(ParamA/2)-ParamDecalage).toString());

      }
      trajectoires.add('G1 Z-'+(j*ParamAP).toString());
    }
    trajectoires.add('G0 Z${OriginZ+30}');
    trajectoires.add('M5');
    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add(';End of $label\n');
    trajectoires.forEach((element) {print(element);});
  }


}

class OperationPocheCarre extends Operation{

  double ParamA = 50;
  double ParamB = 100;
  double ParamC = 3;
  double ParamDf = 3;
  double ParamAP = 0.3;

  OperationPocheCarre({required super.OriginZ, required super.OriginY, required super.OriginX,super.label, required this.ParamA,required this.ParamB,required this.ParamC,required this.ParamDf,required this.ParamAP});

  @override
  Future<void> construct ()async{

    print("origine X: $OriginX");
    print("origine Y: $OriginY");
    print("origine Z: $OriginZ");

    print("Param A: $ParamA");
    print("Param B: $ParamB");
    print("Param DF: $ParamDf");


    trajectoires.add(';$label');
    trajectoires.add('M453');
    trajectoires.add('G0 Z10 F1500');
    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add('M5');
    trajectoires.add('M3 P0 S10000');
    trajectoires.add('G4 S2');
    //trajectoires.add('G0 X' + (((ParamA/2)*-1)+ParamDf/2).toString() + ' Y'+ (((ParamB/2)*-1)+ParamDf/2).toString());
    trajectoires.add('G0 Z$OriginZ');
    trajectoires.add('G1 Z'+(OriginZ+10).toString());
    //trajectoires.add('G1 X'+(OriginX-(ParamA/2)+(ParamDf/2)).toString()+' Y'+(OriginY-(ParamB/2)+(ParamDf/2)).toString());


    for(int j = 1;j*ParamAP<=ParamC;j++)
      {
        trajectoires.add('G1 X'+(OriginX-(ParamA/2)+(ParamDf/2)).toString()+' Y'+(OriginY-(ParamB/2)+(ParamDf/2)).toString());
        trajectoires.add('G1 Z'+(-j*ParamAP).toString());

        for (int i = 1;ParamA-ParamDf*(i-1)>0;i++)
        {
          trajectoires.add('G1 Y'+(OriginY+(ParamB/2)-((ParamDf/2)*i)).toString());
          trajectoires.add('G1 X'+(OriginX+(ParamA/2)-((ParamDf/2)*i)).toString());
          trajectoires.add('G1 Y'+(OriginY-(ParamB/2)+((ParamDf/2)*i)).toString());
          trajectoires.add('G1 X'+(OriginX-(ParamA/2)+((ParamDf/2)*i)).toString());
        }
        trajectoires.add("G0 Z"+(OriginZ+10).toString());
      }


    trajectoires.add(';End of $label\n');
    trajectoires.add('G0 Z10');
    trajectoires.add('M5');
    trajectoires.forEach((element) {print(element);});

  }


}

class OperationContournage extends Operation{

  double ParamA = 50;
  double ParamB = 100;
  double ParamC = 3;
  double ParamDf = 3;
  double ParamAP = 0.3;

  OperationContournage({required super.OriginZ, required super.OriginY, required super.OriginX,super.label, required this.ParamA,required this.ParamB,required this.ParamC,required this.ParamDf,required this.ParamAP});

@override
Future<void> construct ()async{

  trajectoires.add(';$label');
  trajectoires.add('M453');
  trajectoires.add('G0 Z10 F1500');
  trajectoires.add('G0 X$OriginX Y$OriginY');
  trajectoires.add('M5');
  trajectoires.add('M3 P0 S10000');
  trajectoires.add('G4 S2');
  //trajectoires.add('G0 X' + (((ParamA/2)*-1)+ParamDf/2).toString() + ' Y'+ (((ParamB/2)*-1)+ParamDf/2).toString());
  trajectoires.add('G0 Z$OriginZ');


  for(int j = 1;j*ParamAP<=ParamC;j++)
  {
    trajectoires.add('G1 Z'+(j*ParamAP).toString());

    trajectoires.add('G1 Y'+(ParamB/2-ParamDf/2).toString());
    trajectoires.add('G1 X'+(ParamA/2-ParamDf/2).toString());
    trajectoires.add('G1 Y'+(-ParamB/2+ParamDf/2).toString());
    trajectoires.add('G1 X'+(-ParamA/2+ParamDf/2).toString());


  }


  trajectoires.add(';End of $label\n');

}


}

class OperationLigneDroite extends Operation{

  double ParamA = 0; // Y
  double ParamDf = 0; // X

  double ParamC = 1; // pronfondeur
  double ParamAP = 0.3; // profondeur de passe

  double ParamDe = 0; // Décalage


  OperationLigneDroite({required super.OriginZ, required super.OriginY, required super.OriginX,super.label, required this.ParamA,required this.ParamC,required this.ParamDf,required this.ParamAP,required this.ParamDe});

@override
Future<void> construct ()async {
  trajectoires.add(';$label');
  trajectoires.add('M453');
  trajectoires.add('G0 Z10 F1500');
  trajectoires.add('M5');
  trajectoires.add('M3 P0 S10000');
  trajectoires.add('G4 S2');

  if(ParamDf == 0) {
    for (double i = ParamAP; i <= ParamC; i += ParamAP) {
      trajectoires.add('G0 Y' + (OriginY ).toString()+' X'+(OriginX + ParamDe).toString());
      trajectoires.add('G0 Z' + (-i).toString());
      trajectoires.add('G1 Y' + (OriginY + ParamA).toString()+' X'+(OriginX + ParamDe).toString());
      trajectoires.add('G0 Z2');
    }
    trajectoires.add('G0 Y'+ (OriginY).toString()+' X'+(OriginX + ParamDe).toString());
    trajectoires.add('G0 Z'+(-ParamC).toString());
    trajectoires.add('G1 Y'+ (OriginY+ParamA).toString()+' X'+(OriginX + ParamDe).toString());
  }
  else if (ParamA == 0)
    {
      for (double i = ParamAP; i <= ParamC; i += ParamAP) {
        trajectoires.add('G0 Y'+ (OriginY + ParamDe).toString()+' X'+(OriginX).toString());
        trajectoires.add('G0 Z' + (-i).toString());
        trajectoires.add('G1 Y' + (OriginY + ParamDe).toString()+' X'+(OriginX + ParamDf).toString());
        trajectoires.add('G0 Z2');
      }
      trajectoires.add('G0 Y'+ (OriginY + ParamDe).toString()+' X'+(OriginX).toString());
      trajectoires.add('G0 Z'+(-ParamC).toString());
      trajectoires.add('G1 Y' + (OriginY + ParamDe).toString()+' X'+(OriginX + ParamDf).toString());
    }
  else{
    for (double i = ParamAP; i <= ParamC; i += ParamAP) {
      trajectoires.add('G0 X$OriginX Y$OriginY');
      trajectoires.add('G0 Z' + (-i).toString());
      trajectoires.add('G1 X'+(OriginX + ParamDf).toString()+' Y'+(OriginY + ParamA).toString());
      trajectoires.add('G0 Z2');
    }
    trajectoires.add('G0 X$OriginX Y$OriginY');
    trajectoires.add('G0 Z'+(-ParamC).toString());
    trajectoires.add('G1 X'+ (OriginX+ParamDf).toString()+' Y'+(OriginY + ParamA).toString());
  }

  trajectoires.add('G0 Z10');
  trajectoires.add('M5');
  trajectoires.add('G0 X$OriginX Y$OriginY');
  trajectoires.add(';End of $label\n');
  trajectoires.forEach((element) {print(element);});


}


}

class OperationPocheRonde extends Operation{


  double ParamD = 20;
  double ParamC = 3;

  double ParamDf = 3;
  double ParamAP = 3;

  OperationPocheRonde({required super.OriginZ, required super.OriginY, required super.OriginX,super.label, required this.ParamD, required this.ParamC,required this.ParamDf,required this.ParamAP});

@override
Future<void> construct ()async{

  trajectoires.add(';$label');
  trajectoires.add('M453');
  trajectoires.add('G0 Z10 F1500');
  trajectoires.add('G0 X$OriginX Y$OriginY');
  trajectoires.add('M5');
  trajectoires.add('M3 P0 S10000');
  trajectoires.add('G4 S2');
  trajectoires.add('G0 Z$OriginZ');


    for(int j = 1;j*ParamAP<=ParamC;j++)
    {
      trajectoires.add('G1 Z-'+(j*ParamAP).toString());


      for (int i = 1;((sqrt(ParamDf))*i)<ParamD;i++)
      {
        trajectoires.add('G1 X'+(OriginX-(ParamDf*i)).toString()+' Y'+(OriginY-(ParamDf*i)).toString());
        trajectoires.add('G2 I'+((ParamDf/1)*i).toString()+' J'+((ParamDf/1)*i).toString());
      }
      trajectoires.add('G1 Z'+(OriginZ+5).toString());
      trajectoires.add('G0 X$OriginX Y$OriginY');

    }

    trajectoires.add('G0 Z10');
    trajectoires.add('M5');
    trajectoires.add(';End of $label\n');
    for(int i=0;i<trajectoires.length;i++)
      {
        print(trajectoires.elementAt(i));
      }
    

  }


}




class OperationDb9 extends Operation{



  double ParamC = 3;
  double ParamAP = 1;


  OperationDb9({required super.OriginZ, required super.OriginY, required super.OriginX,super.label, required this.ParamC,required this.ParamAP});


  Future<String> loadsubd9GcodeFromAsset() async {
    String tutu = await rootBundle.loadString('assets/convGcode/subd9.txt');
    return tutu;
  }

@override
  Future<void> construct () async {
    trajectoires.add(';$label');
    trajectoires.add('G0 X$OriginX Y$OriginY Z$OriginZ');
    trajectoires.add('G1 Z1');
    trajectoires.add('G1 X-3.66 Y2.60');

    for(int j = 1;j*ParamAP<=ParamC;j++)
    {
      trajectoires.add('G1 Z-'+(j*ParamAP).toString());
      trajectoires.add(await loadsubd9GcodeFromAsset());
    }
    trajectoires.add(';End of $label\n');
  }


}