// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'OpeListView.dart';

class GeneralOpeViewer extends StatefulWidget {

  const GeneralOpeViewer({super.key});

  @override
  GeneralOpeViewerState createState() => GeneralOpeViewerState();
}

class GeneralOpeViewerState extends State<GeneralOpeViewer> {
  GeneralOpeViewerState();

  @override
  Widget build(BuildContext context) {
    if (ListOfOperationCurrent.elementAt(selectedIndex)
            .runtimeType
            .toString() ==
        'OperationSurfacage')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent.elementAt(selectedIndex)
            .runtimeType
            .toString() ==
        'OperationPocheCarre')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent.elementAt(selectedIndex)
            .runtimeType
            .toString() ==
        'OperationPocheRonde')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent.elementAt(selectedIndex)
            .runtimeType
            .toString() ==
        'OperationPercage')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent.elementAt(selectedIndex)
            .runtimeType
            .toString() ==
        'OperationPocheCarre')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent.elementAt(selectedIndex)
            .runtimeType
            .toString() ==
        'OperationContournage')
      return Container(
        color: Colors.white,
        child: Center(child: Text('Visualisation bientôt disponible')),
      );
    else if (ListOfOperationCurrent.elementAt(selectedIndex)
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

/***************OPERATION DE PERCAGE***************/

class OpePercage extends StatefulWidget {
  const OpePercage({super.key});

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
    return Container(
      child: Center(child: Text("Bientôt disponible ;)")),
    );
  }
}

/********************************** CONNECTEURS ********************************/

/***************OPERATION DE SUB-D15***************/

class OpeSubd15 extends StatefulWidget {
  const OpeSubd15({super.key});

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
          alignment: Alignment.centerLeft,
          child: Text(
            'Ajouter opé.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }
}
