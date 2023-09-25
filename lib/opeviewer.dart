// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/operation.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'OpeListView.dart';

class GeneralOpeViewer extends StatefulWidget {
  // print(ListOfOperationCurrent.elementAt(selectedIndex).runtimeType.toString());
  const GeneralOpeViewer

  ({super.key});

  @override
  GeneralOpeViewerState createState() => GeneralOpeViewerState();
}

class GeneralOpeViewerState extends State<GeneralOpeViewer> {
  GeneralOpeViewerState();

  @override
  Widget build(BuildContext context) {
    if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationSurfacage')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationPocheCarre')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationPocheRonde')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationPercage')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationPocheCarre')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationContournage')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent
        .elementAt(selectedIndex)
        .runtimeType
        .toString() ==
        'OperationLigneDroite')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else
      return Container(color: Colors.black);
  }
}

/********************************** USINAGE CLASSIQUE ********************************/

/***************OPERATION DE Surfacage***************/

class OpeSurfacage extends StatefulWidget {
  const OpeSurfacage

  ({super.key});

  @override
  OpeSurfacageState createState() => OpeSurfacageState();
}

class OpeSurfacageState extends State<OpeSurfacage> {
  double _ParamA = 10;
  double _ParamB = 10;
  double _ParamC = 0.1;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 10;

  double _ParamDf = 3;
  double _ParamAP = 0.1;
  double _ParamDecalage = 2;

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
                    image: AssetImage('assets/surfacage.png'),
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
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'Décalage ',
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
                            label: _ParamDecalage,
                            onChanged: (text) {
                              _ParamDecalage = double.parse(text);
                            },
                          ),
                        ),
                      ],
                    )
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
                      const Spacer(),
                      Container(
                        alignment: Alignment.bottomLeft,
                        width: 150,
                        child: AddOperation(
                          onPressed: () {
                            ListOfOperationCurrent.add(OperationSurfacage(
                                OriginZ: _ParamZ,
                                OriginY: _ParamY,
                                OriginX: _ParamX,
                                ParamA: _ParamB, // Inversion du a erreur de dessin ...
                                ParamB: _ParamA,
                                ParamC: _ParamC,
                                ParamDf: _ParamDf,
                                ParamAP: _ParamAP,
                                ParamDecalage: _ParamDecalage,
                                label: "Surfacage " +
                                    ListOfOperationCurrent.length.toString()));
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Opération ajoutée'),
                                  duration: const Duration(milliseconds: 400),
                                ),
                              );
                            });
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

/***************OPERATION DE Poche Carre***************/

class OpePocheCarre extends StatefulWidget {
  const OpePocheCarre

  ({super.key});

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
                            ListOfOperationCurrent.add(OperationPocheCarre(
                                OriginZ: _ParamZ,
                                OriginY: _ParamY,
                                OriginX: _ParamX,
                                ParamA: _ParamA,
                                ParamB: _ParamB,
                                ParamC: _ParamC,
                                ParamDf: _ParamDf,
                                ParamAP: _ParamAP,
                                label: "Poche Carrée " +
                                    ListOfOperationCurrent.length.toString()));
                            setState(() {
                              //CurrentLis
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Opération ajoutée'),
                                  duration: const Duration(milliseconds: 400),
                                ),
                              );
                            });
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

/***************OPERATION DE Poche Ronde***************/

class OpePocheRonde extends StatefulWidget {
  const OpePocheRonde

  ({super.key});

  @override
  OpePocheRondeState createState() => OpePocheRondeState();
}

class OpePocheRondeState extends State {
  double _ParamD = 10;
  double _ParamC = 3;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 0;

  double _ParamDf = 3;
  double _ParamAP = 1;

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
                    image: AssetImage('assets/pocheronde.png'),
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
                            'Diametre (mm) ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: OwnTextField(
                            label: _ParamD,
                            onChanged: (text) {
                              _ParamD = double.parse(text);
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
                            'Diamètre fraise (mm) ',
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
                            'Profondeur de passe (mm) ',
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
                            setState(() {
                              ListOfOperationCurrent.add(OperationPocheRonde(
                                  OriginZ: _ParamZ,
                                  OriginY: _ParamY,
                                  OriginX: _ParamX,
                                  ParamD: _ParamD,
                                  ParamC: _ParamC,
                                  ParamDf: _ParamDf,
                                  ParamAP: _ParamAP,
                                  label: "Poche Ronde " +
                                      ListOfOperationCurrent.length
                                          .toString()));
                              setState(() {


                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Opération ajoutée'),
                                  duration: const Duration(milliseconds: 400),
                                ),
                              );
                              });
                            });
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

/***************OPERATION DE PERCAGE***************/

class OpePercage extends StatefulWidget {
  const OpePercage

  ({super.key});

  @override
  OpePercageState createState() => OpePercageState();
}

class OpePercageState extends State<OpePercage> {
  double _ParamA = 0;
  double _ParamB = 0;
  double _ParamC = 0;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 0;

  double _ParamDf = 0;
  double _ParamAP = 0;


// TO COME
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       padding: EdgeInsets.all(30),
  //       child: Row(
  //         children: [
  //           Flexible(
  //               flex: 2,
  //               child: Container(
  //                 margin: EdgeInsets.all(30),
  //                 padding: EdgeInsets.all(30),
  //                 // color: Colors.red,
  //                 child: Image(
  //                   image: AssetImage('assets/percage.png'),
  //                 ),
  //               )),
  //           Flexible(
  //             flex: 1,
  //             child: Container(
  //               //color: Colors.orange,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         child: const Text(
  //                           'A (mm) ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 124, 51, 43),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           onChanged: (text) {
  //                             _ParamA = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         child: const Text(
  //                           'B (mm) ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 27, 109, 160),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           onChanged: (text) {
  //                             _ParamB = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         child: const Text(
  //                           'C (mm) ',
  //                           style: TextStyle(
  //                             color: Colors.black45,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           onChanged: (text) {
  //                             _ParamC = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         padding: EdgeInsets.symmetric(horizontal: 4),
  //                         child: Text(
  //                           'Diamètre fraise ',
  //                           textAlign: TextAlign.justify,
  //                           style: TextStyle(
  //                             color: Color(0xFF5A5A5A),
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           onChanged: (text) {
  //                             _ParamDf = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Flexible(
  //               flex: 1,
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 8),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'X ',
  //                           style: TextStyle(
  //                               color: Color.fromARGB(255, 111, 111, 111),
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 40),
  //                         ),
  //                         Container(
  //                           width: 100,
  //                           child: OwnTextField(
  //                             onChanged: (text) {
  //                               _ParamX = double.parse(text);
  //                             },
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     const SizedBox(height: 15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'Y ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 111, 111, 111),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 40,
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 100,
  //                           child: OwnTextField(
  //                             onChanged: (text) {
  //                               _ParamY = double.parse(text);
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'Z ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 111, 111, 111),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 40,
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 100,
  //                           child: OwnTextField(
  //                             onChanged: (text) {
  //                               _ParamZ = double.parse(text);
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const Spacer(),
  //                     Container(
  //                       alignment: Alignment.bottomLeft,
  //                       width: 150,
  //                       child: AddOperation(
  //                         onPressed: () {
  //                           setState(() {
  //                             //ListOfOperationCurrent.add(Operation)
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: const Text('Opération ajoutée'),
  //                                 duration: const Duration(milliseconds: 400),
  //                               ),
  //                             );
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     const Spacer(),
  //                   ],
  //                 ),
  //               ))
  //         ],
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Bientôt disponible ;)")),);
  }
}


/***************OPERATION DE CONTOURNAGE***************/

class OpeContournage extends StatefulWidget {
  const OpeContournage

  ({super.key});

  @override
  OpeContournageState createState() => OpeContournageState();
}

class OpeContournageState extends State {
  double _ParamA = 10;
  double _ParamB = 10;
  double _ParamC = 5;

  double _ParamX = 50;
  double _ParamY = 50;
  double _ParamZ = 0;

  double _ParamDf = 3;
  double _ParamAP = 0.4;

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       padding: EdgeInsets.all(30),
  //       child: Row(
  //         children: [
  //           Flexible(
  //               flex: 2,
  //               child: Container(
  //                 margin: EdgeInsets.all(30),
  //                 padding: EdgeInsets.all(30),
  //                 // color: Colors.red,
  //                 child: Image(
  //                   image: AssetImage('assets/pochecarre.png'),
  //                 ),
  //               )),
  //           Flexible(
  //             flex: 1,
  //             child: Container(
  //               //color: Colors.orange,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         child: const Text(
  //                           'A (mm) ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 124, 51, 43),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           label: _ParamA,
  //                           onChanged: (text) {
  //                             _ParamA = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         child: const Text(
  //                           'B (mm) ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 27, 109, 160),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           label: _ParamB,
  //                           onChanged: (text) {
  //                             _ParamB = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         child: const Text(
  //                           'C (mm) ',
  //                           style: TextStyle(
  //                             color: Colors.black45,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 24,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           label: _ParamC,
  //                           onChanged: (text) {
  //                             _ParamC = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         padding: EdgeInsets.symmetric(horizontal: 4),
  //                         child: Text(
  //                           'Diamètre fraise ',
  //                           textAlign: TextAlign.justify,
  //                           style: TextStyle(
  //                             color: Color(0xFF5A5A5A),
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           label: _ParamDf,
  //                           onChanged: (text) {
  //                             _ParamDf = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 100,
  //                         padding: EdgeInsets.symmetric(horizontal: 4),
  //                         child: Text(
  //                           'Profondeur de passe ',
  //                           textAlign: TextAlign.justify,
  //                           style: TextStyle(
  //                             color: Color(0xFF5A5A5A),
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: OwnTextField(
  //                           label: _ParamAP,
  //                           onChanged: (text) {
  //                             _ParamAP = double.parse(text);
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Flexible(
  //               flex: 1,
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 8),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'X ',
  //                           style: TextStyle(
  //                               color: Color.fromARGB(255, 111, 111, 111),
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 40),
  //                         ),
  //                         Container(
  //                           width: 100,
  //                           child: OwnTextField(
  //                             label: _ParamX,
  //                             onChanged: (text) {
  //                               _ParamX = double.parse(text);
  //                             },
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     const SizedBox(height: 15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'Y ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 111, 111, 111),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 40,
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 100,
  //                           child: OwnTextField(
  //                             label: _ParamY,
  //                             onChanged: (text) {
  //                               _ParamY = double.parse(text);
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'Z ',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 111, 111, 111),
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 40,
  //                           ),
  //                         ),
  //                         Container(
  //                           width: 100,
  //                           child: OwnTextField(
  //                             label: _ParamZ,
  //                             onChanged: (text) {
  //                               _ParamZ = double.parse(text);
  //                             },
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const Spacer(),
  //                     Container(
  //                       alignment: Alignment.bottomLeft,
  //                       width: 150,
  //                       child: AddOperation(
  //                         onPressed: () {
  //                           ListOfOperationCurrent.add(OperationContournage(
  //                               OriginZ: _ParamZ,
  //                               OriginY: _ParamY,
  //                               OriginX: _ParamX,
  //                               ParamA: _ParamA,
  //                               ParamB: _ParamB,
  //                               ParamC: _ParamC,
  //                               ParamDf: _ParamDf,
  //                               ParamAP: _ParamAP,
  //                               label: "Contournage " +
  //                                   ListOfOperationCurrent.length.toString()));
  //                           setState(() {
  //                             //CurrentLis
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: const Text('Opération ajoutée'),
  //                                 duration: const Duration(milliseconds: 400),
  //                               ),
  //                             );
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     const Spacer(),
  //                   ],
  //                 ),
  //               ))
  //         ],
  //       ));
  // }


  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Bientôt disponible ;)")),);
  }


}

/***************OPERATION LIGNE DROITE***************/

class OpeLigneDroite extends StatefulWidget {
  const OpeLigneDroite

  ({super.key});

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
                    child: FittedBox(fit: BoxFit.contain,
                        child: Icon(Icons.format_list_bulleted))
                )),
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
                            'Décalage ',
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
                            label: _ParamDe,
                            onChanged: (text) {
                              _ParamDe = double.parse(text);
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
                            ListOfOperationCurrent.add(OperationLigneDroite(
                              OriginZ: _ParamZ,
                              OriginY: _ParamY,
                              OriginX: _ParamX,
                              ParamA: _ParamA,
                              ParamC: _ParamC,
                              ParamDf: _ParamDf,
                              ParamAP: _ParamAP,
                              ParamDe: _ParamDe,
                              //NbLigne: _Nbligne,
                              //Interligne: _Interligne,
                              label: "Lignes droites " +
                                  ListOfOperationCurrent.length.toString(),));
                            setState(() {
                              //CurrentLis
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Opération ajoutée'),
                                  duration: const Duration(milliseconds: 400),
                                ),
                              );
                            });
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

/*
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Bientôt disponible ;)")),);
  }

 */
}




/********************************** CONNECTEURS ********************************/

/***************OPERATION DE SUB-D9***************/

class OpeSubd9 extends StatefulWidget {
  const OpeSubd9

  ({super.key});

  @override
  _OpeSubd9 createState() => _OpeSubd9();
}

class _OpeSubd9 extends State<OpeSubd9> {
  double _ParamA = 0;
  double _ParamB = 0;
  double _ParamC = 0;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 0;

  double _ParamDf = 0;
  double _ParamAP = 0;
  double _ParamDecalage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: 140,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 84, 204, 197),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10))
                          ),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {},
                            icon: Icon(Icons.rotate_right),),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Image(
                          image: AssetImage('assets/subd9H.png'),
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(30),
                  padding: EdgeInsets.all(30),
                  // color: Colors.red,
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
                              color: Color.fromARGB(255, 27, 109, 160),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: OwnTextField(
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
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: OwnTextField(
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
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'Décalage ',
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
                            onChanged: (text) {
                              _ParamDecalage = double.parse(text);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: const Text(
                              'X ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 111, 111, 111),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: OwnTextField(
                              onChanged: (text) {
                                _ParamX = double.parse(text);
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: const Text(
                              'Y ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 111, 111, 111),
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: OwnTextField(
                              onChanged: (text) {
                                _ParamY = double.parse(text);
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
                              'Z ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 111, 111, 111),
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: OwnTextField(
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
                            setState(() {
                              //CurrentLis
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Opération ajoutée'),
                                  duration: const Duration(milliseconds: 400),
                                ),
                              );
                            });
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

/***************OPERATION DE SUB-D15***************/

class OpeSubd15 extends StatefulWidget {
  const OpeSubd15

  ({super.key});

  @override
  _OpeSubd15 createState() => _OpeSubd15();
}

class _OpeSubd15 extends State<OpeSubd15> {
  double _ParamA = 0;
  double _ParamB = 0;
  double _ParamC = 0;

  double _ParamX = 0;
  double _ParamY = 0;
  double _ParamZ = 0;

  double _ParamDf = 0;
  double _ParamAP = 0;

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
                    image: AssetImage('assets/subd15H.png'),
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
                              color: Color.fromARGB(255, 27, 109, 160),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: OwnTextField(
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
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: OwnTextField(
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
                            onChanged: (text) {
                              _ParamDf = double.parse(text);
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: const Text(
                              'X ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 111, 111, 111),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: OwnTextField(
                              onChanged: (text) {
                                _ParamX = double.parse(text);
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: const Text(
                              'Y ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 111, 111, 111),
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: OwnTextField(
                              onChanged: (text) {
                                _ParamY = double.parse(text);
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
                              'Z ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 111, 111, 111),
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: OwnTextField(
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
                            setState(() {
                              //CurrentLis
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Opération ajoutée'),
                                  duration: const Duration(milliseconds: 400),
                                ),
                              );
                            });
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

class OwnTextField extends StatefulWidget {
  const OwnTextField({this.onChanged, this.label});

  final ValueChanged<String>? onChanged;
  final double? label;

  @override
  OwnTextFieldState createState() => OwnTextFieldState(onChanged, label);
}

class OwnTextFieldState extends State<OwnTextField> {
  final ValueChanged<String>? _onChanged;
  final double? _label;

  OwnTextFieldState(this._onChanged, this._label);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _label.toString(),
      onChanged: (text) {
        return _onChanged!(text);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gapPadding: 5.0,
        ),
      ),
    );
  }
}

class AddOperation extends StatefulWidget {
  const AddOperation({this.onPressed});

  final VoidCallback? onPressed;

  @override
  AddOperationState createState() => AddOperationState(onPressed);
}

class AddOperationState extends State {
  final VoidCallback? _onPressed;

  AddOperationState(this._onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          backgroundColor: const Color.fromARGB(255, 43, 135, 155),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
      onPressed: () {
        return _onPressed!();
      },
      child: const FittedBox(
          alignment: Alignment.centerLeft, child: Text('Ajouter opé.')),
    );
  }
}
