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
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.bold),
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
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.bold),
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
            ),
          ),
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
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Caisson",
                        style: TextStyle(
                            color: Color(0xFF707585),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            (global.machineObjectModel.result?.sensors?.gpIn
                                                ?.length ??
                                            0) <
                                        11 ||
                                    global.machineObjectModel.result?.sensors
                                            ?.gpIn?[10] ==
                                        null
                                ? Icons.key_off_outlined
                                : (global.machineObjectModel.result?.sensors
                                                ?.gpIn?[10]?.value ??
                                            1) ==
                                        1
                                    ? Icons.lock
                                    : Icons.lock_open_rounded,
                            color: (global.machineObjectModel.result?.sensors
                                                ?.gpIn?.length ??
                                            0) <
                                        11 ||
                                    global.machineObjectModel.result?.sensors
                                            ?.gpIn?[10] ==
                                        null
                                ? Colors.grey
                                : (global.machineObjectModel.result?.sensors
                                                ?.gpIn?[10]?.value ??
                                            1) ==
                                        1
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Driver(s)",
                        style: TextStyle(
                            color: Color(0xFF707585),
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            (global.machineObjectModel.result?.sensors
                                        ?.gpIn?[9] ==
                                    null)
                                ? Icons.power_off_outlined
                                : (global.machineObjectModel.result?.sensors
                                                ?.gpIn?[9]?.value ??
                                            0) ==
                                        0
                                    ? Icons.power_rounded
                                    : Icons.power_rounded,
                            color: (global.machineObjectModel.result?.sensors
                                        ?.gpIn?[9] ==
                                    null)
                                ? Colors.grey
                                : (global.machineObjectModel.result?.sensors
                                                ?.gpIn?[9]?.value ??
                                            0) ==
                                        0
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
