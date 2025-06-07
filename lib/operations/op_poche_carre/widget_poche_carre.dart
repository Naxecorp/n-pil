import 'package:flutter/material.dart';
import '../../OpeListView.dart';
import 'op_poche_carre.dart';
import '../../opeviewer.dart';

/***************OPERATION DE Poche Carre***************/

class OpePocheCarre extends StatefulWidget {
  const OpePocheCarre({super.key});

  @override
  OpePocheCarreState createState() => OpePocheCarreState();
}

class OpePocheCarreState extends State {
  double _ParamA = 10;
  double _ParamB = 10;
  double _ParamC = 5;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 0;

  double _ParamDf = 3;
  double _ParamAP = 0.4;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  // color: Colors.red,
                  child: Image(
                    image: AssetImage('assets/pochecarre.png'),
                  ),
                )),
            Flexible(
              flex: 1,
              child: Container(
                //color: Colors.orange,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          child: const Text(
                            'A (mm) ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 124, 51, 43),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
                          child: const Text(
                            'B (mm) ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 64, 152, 124),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: OwnTextField(
                            label: _ParamB,
                            onChanged: (text) {
                              _ParamB = double.parse(text);
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
                          child: const Text(
                            'C (mm) ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 75, 96, 209),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
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
                            'Diamètre fraise ',
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
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
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
                            // Vérification des paramètres
                            if (_ParamA != 0 &&
                                _ParamB != 0 &&
                                _ParamC != 0 &&
                                _ParamDf != 0 &&
                                _ParamAP != 0) {
                              // Ajout de l'opération
                              ListOfOperationCurrent.add(OperationPocheCarre(
                                OriginZ: _ParamZ,
                                OriginY: _ParamY,
                                OriginX: _ParamX,
                                ParamA: _ParamA,
                                ParamB: _ParamB,
                                ParamC: _ParamC,
                                ParamDf: _ParamDf,
                                ParamAP: _ParamAP,
                                label:
                                    "Poche Carrée ${ListOfOperationCurrent.length}",
                              ));
                              // Mise à jour de l'interface utilisateur
                              setState(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Opération ajoutée'),
                                    duration: Duration(milliseconds: 400),
                                  ),
                                );
                              });
                            } else {
                              // Affichage d'un message d'erreur si un paramètre est égal à 0
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Paramètres invalides'),
                                    content: const Text(
                                      'L\'opération n\'a pas été ajoutée car un ou plusieurs paramètres sont égaux à 0.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ))
          ],
        ));
  }
}
