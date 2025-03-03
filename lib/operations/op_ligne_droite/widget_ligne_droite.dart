import 'package:flutter/material.dart';
import '../../OpeListView.dart';
import 'op_ligne_droite.dart';
import '../../opeviewer.dart';
import '/globals_var.dart' as global;

/***************OPERATION LIGNE DROITE***************/

class OpeLigneDroite extends StatefulWidget {
  const OpeLigneDroite({super.key});

  @override
  OpeLigneDroiteState createState() => OpeLigneDroiteState();
}

class OpeLigneDroiteState extends State<OpeLigneDroite> {
  double _ParamA = 0;
  double _ParamC = 1;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 0;

  double _Nbligne = 3;
  double _Interligne = 3;
  double _ParamDf = 0;
  double _ParamAP = 0.3;
  double _ParamDe = 0;

  double _ParamAvance = 1000;
  double _ParamRotation = 10000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              //color: Colors.blueAccent,
              height: double.infinity,
              width: double.infinity,
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(30),
              // color: Colors.red,
              child: Image(
                image: AssetImage('assets/Icon ligne droites.png'),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              //color: Colors.orange.withOpacity(0.5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Longueur de ligne (Y)',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamA,
                          onChanged: (text) {
                            _ParamA = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Longueur de ligne (X)',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamDf,
                          onChanged: (text) {
                            _ParamDf = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Profondeur ',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamC,
                          onChanged: (text) {
                            _ParamC = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Profondeur de passe ',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamAP,
                          onChanged: (text) {
                            _ParamAP = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Vitesse avance ',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamAvance,
                          onChanged: (text) {
                            _ParamAvance = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  global.machineMode == global.MachineMode.cnc ? Row(
                    children: [
                      Container(
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          'Rotation broche ',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFF5A5A5A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamRotation,
                          onChanged: (text) {
                            _ParamRotation = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ):Container(),
                  
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              //color: Colors.blue.withOpacity(0.5),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'X ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 111, 111, 111),
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamX,
                          onChanged: (text) {
                            _ParamX = double.parse(text);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Y ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamY,
                          onChanged: (text) {
                            _ParamY = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Z ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      Container(
                        width: 100,
                        child: OwnTextField(
                          label: _ParamZ,
                          onChanged: (text) {
                            _ParamZ = double.parse(text);
                          },
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: 150,
                    child: AddOperation(
                      onPressed: () {
                        ListOfOperationCurrent.add(
                          OperationLigneDroite(
                            OriginZ: _ParamZ,
                            OriginY: _ParamY,
                            OriginX: _ParamX,
                            ParamA: _ParamA,
                            ParamC: _ParamC,
                            ParamDf: _ParamDf,
                            ParamAP: _ParamAP,
                            ParamAvance: _ParamAvance,
                            ParamRotation: _ParamRotation,
                            //NbLigne: _Nbligne,
                            //Interligne: _Interligne,
                            label: "Lignes droites " +
                                ListOfOperationCurrent.length.toString(),
                          ),
                        );
                        setState(
                          () {
                            //CurrentLis
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Opération ajoutée'),
                                duration: const Duration(milliseconds: 400),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Bientôt disponible ;)")),);
  }

 */
}
