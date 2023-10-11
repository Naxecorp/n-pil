import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/operations/operation.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../OpeListView.dart';
import '../ope_surfacage/op_surfacage.dart';
import '../op_poche_carre/op_poche_carre.dart';
import '../op_ligne_droite/op_ligne_droite.dart';
import '../op_poche_ronde/op_poche_ronde.dart';
import '../../opeviewer.dart';

/***************OPERATION DE SUB-D9***************/

class OpeSubd9 extends StatefulWidget {
  const OpeSubd9({super.key});

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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {},
                            icon: Icon(Icons.rotate_right),
                          ),
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
