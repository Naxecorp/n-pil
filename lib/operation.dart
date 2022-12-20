import 'package:flutter/cupertino.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;





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




  double ParamA;
  double ParamB;
  double ParamC;
  double ParamDf;
  double ParamAP;
  double ParamDecalage;

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
    trajectoires.add('G28');
    trajectoires.add('G0 X$OriginX Y$OriginY Z$OriginZ');
    trajectoires.add('G0 Z$OriginZ F1500');
    trajectoires.add('G0 X' + (((OriginX-(ParamA/2))-ParamDecalage)).toString() + ' Y'+ ((OriginY-(ParamB/2)-ParamDecalage)).toString());


    for(int j = 1;j*ParamAP<=ParamC;j++)
    {
      trajectoires.add('G1 Z'+(j*ParamAP).toString());

      for (int i = 0;(ParamB)-((ParamDf/2)*i)>0;i++)
      {
        trajectoires.add('G1 Y'+((OriginY-(ParamB/2))+((ParamDf/2))*i).toString());
        if (i.isEven)
        {
          trajectoires.add('G1 Z'+((OriginZ+1).toString()));
          trajectoires.add('G1 X'+((OriginX+(ParamA/2))+ParamDecalage).toString());
          trajectoires.add('G1 Z'+(j*ParamAP).toString());
        }
        else trajectoires.add('G1 X'+(OriginX-(ParamA/2)-ParamDecalage).toString());
      }

    }
    trajectoires.add(';End of $label\n');



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

    trajectoires.add(';$label');
    trajectoires.add('G0 X$OriginX Y$OriginY Z$OriginZ');
    trajectoires.add('G92 X0 Y0 Z0');
    trajectoires.add('G0 Z1 F1500');
    trajectoires.add('G0 X' + (((ParamA/2)*-1)+ParamDf/2).toString() + ' Y'+ (((ParamB/2)*-1)+ParamDf/2).toString());
    trajectoires.add('G0 Z0');


    for(int j = 1;j*ParamAP<=ParamC;j++)
      {
        trajectoires.add('G1 Z'+(j*ParamAP).toString());

        for (int i = 1;ParamA-ParamDf*(i-1)>0;i++)
        {
          trajectoires.add('G1 Y'+(ParamB/2-ParamDf/2*i).toString());
          trajectoires.add('G1 X'+(ParamA/2-ParamDf/2*i).toString());
          trajectoires.add('G1 Y'+(-ParamB/2+ParamDf/2*i).toString());
          trajectoires.add('G1 X'+(-ParamA/2+ParamDf/2*i).toString());
        }

      }


    trajectoires.add(';End of $label\n');

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
    trajectoires.add('G0 X$OriginX Y$OriginY Z$OriginZ');


    for(int j = 1;j*ParamAP<=ParamC;j++)
    {
      trajectoires.add('G1 Z'+(j*ParamAP).toString());

      for (int i = 1;ParamD-(ParamDf/2)*(i-1)>0;i++)
      {
        trajectoires.add('G1 X'+(ParamDf/2*i).toString()+' Y'+(ParamDf/2*i).toString());
        trajectoires.add('G3 I'+(ParamD-ParamDf/2*i).toString()+' J'+(ParamD-ParamDf/2*i).toString());

      }

    }


    trajectoires.add(';End of $label\n');

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