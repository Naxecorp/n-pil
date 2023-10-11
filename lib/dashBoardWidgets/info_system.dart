import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';
import '../globals_var.dart';
import '../widgetUtils/touche.dart';
import '../widgetUtils/Joystick/my_joystick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfoSystem extends StatefulWidget {
  const InfoSystem({super.key});

  @override
  InfoSystemState createState() => InfoSystemState();
}

class InfoSystemState extends State<InfoSystem> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Text(
                      global.machineObjectModel.result?.state?.status
                              .toString() ??
                          "???",
                      style: const TextStyle(color: Color(0xFF707585))),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "MCU Température",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          global.machineObjectModel.result?.boards
                                  ?.elementAt(0)
                                  .mcuTemp
                                  ?.current
                                  ?.toStringAsFixed(1) ??
                              "...",
                          style: const TextStyle(color: Color(0xFF707585))),
                      const Text("°C",
                          style: TextStyle(color: Color(0xFF707585)))
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "V12",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        global.machineObjectModel.result?.boards
                                ?.elementAt(0)
                                .v12
                                ?.current
                                ?.toStringAsFixed(1) ??
                            "...",
                        style: const TextStyle(color: Color(0xFF707585)),
                      ),
                      const Text(" V",
                          style: TextStyle(color: Color(0xFF707585))),
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Vin",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          global.machineObjectModel.result?.boards?[0].vIn
                                  ?.current
                                  ?.toStringAsFixed(1) ??
                              "...",
                          style: const TextStyle(color: Color(0xFF707585))),
                      const Text(" V",
                          style: TextStyle(color: Color(0xFF707585))),
                    ],
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}
