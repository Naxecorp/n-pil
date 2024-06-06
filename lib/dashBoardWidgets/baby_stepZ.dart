import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';
import '../globals_var.dart';
import '../widgetUtils/touche.dart';
import '../widgetUtils/Joystick/my_joystick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BabyStepZ extends StatefulWidget {
  @override
  _BabyStepZState createState() => _BabyStepZState();
}

class _BabyStepZState extends State<BabyStepZ> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      surfaceTintColor: Color.fromRGBO(240, 240, 243, 1),
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 1, maxHeight: 30),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: 35, minHeight: 15, maxWidth: 1000),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 5.0),
                        child: Text(
                          "formated",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 35,
                        minHeight: 15,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          " Z",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.w100,
                              fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: 35, minHeight: 15, maxWidth: 1000),
                      child: Padding(
                        padding: EdgeInsets.only(left: 100.0, top: 5.0),
                        child: Text(
                          "${NumberFormat('0.0#').format(global.compensation)}",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              API_Manager().sendGcodeCommand("M290 S+0.1");
                              global.compensation += 0.1;
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF20917F)),
                            child: Container(
                                width: 50,
                                child: const Text(
                                  "+ 0.1",
                                  textAlign: TextAlign.center,
                                ))),
                        const Padding(padding: EdgeInsets.only(top: 3)),
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M290 S-0.1");
                            global.compensation -= 0.1;
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF20917F)),
                          child: Container(
                            width: 50,
                            child: const Text(
                              "- 0.1",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              API_Manager().sendGcodeCommand("M290 S+0.01");
                              global.compensation += 0.01;
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF20917F)),
                            child: Container(
                                width: 50,
                                child: const Text(
                                  "+ 0.01",
                                  textAlign: TextAlign.center,
                                ))),
                        const Padding(padding: EdgeInsets.only(top: 3)),
                        ElevatedButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("M290 S-0.01");
                            global.compensation -= 0.01;
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF20917F)),
                          child: Container(
                            width: 50,
                            child: const Text(
                              "- 0.01",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
