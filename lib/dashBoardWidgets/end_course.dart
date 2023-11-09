import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../../globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';
import '../../globals_var.dart';
import '../../widgetUtils/touche.dart';
import '../widgetUtils/Joystick/my_joystick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EndCourses extends StatefulWidget {
  const EndCourses({super.key});

  @override
  EndCoursesState createState() => EndCoursesState();
}

class EndCoursesState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //color: Colors.orange,
        child: Center(
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: global.machineObjectModel.result?.sensors
                                    ?.endstops?[0]!.triggered
                                    .toString() ==
                                'true'
                            ? Colors.orange
                            : Colors.green,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              color: global.machineObjectModel.result?.sensors
                                          ?.endstops?[1]!.triggered
                                          .toString() ==
                                      'true'
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              color: global.machineObjectModel.result?.sensors
                                          ?.endstops?[2]!.triggered
                                          .toString() ==
                                      'true'
                                  ? Colors.orange
                                  : Colors.green,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: global.machineObjectModel.result?.sensors
                                    ?.endstops?[2]!.triggered
                                    .toString() ==
                                'true'
                            ? Colors.orange
                            : Colors.green,
                      )
                    ],
                  )),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      color: global.machineObjectModel.result?.sensors
                                  ?.endstops?[2]!.triggered
                                  .toString() ==
                              'true'
                          ? Colors.orange
                          : Colors.green,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 10,
                      width: 10,
                      color: global.machineObjectModel.result?.sensors
                                  ?.endstops?[2]!.triggered
                                  .toString() ==
                              'true'
                          ? Colors.orange
                          : Colors.green,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
