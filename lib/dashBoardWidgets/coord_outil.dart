import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

class CoordoneesOutil extends StatefulWidget {
  const CoordoneesOutil({super.key, this.child, this.notifyParent});

  final Widget? child;
  final Function()? notifyParent;

  @override
  State<CoordoneesOutil> createState() => CoordoneesOutilState(notifyParent);
}

class CoordoneesOutilState extends State<CoordoneesOutil> {
  final VoidCallback? _notifyParent;

  CoordoneesOutilState(this._notifyParent);

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Container(
            //margin: EdgeInsets.all(10),
            //color: Colors.green,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "X",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(0)!
                                        .userPosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result?.state
                                          ?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 X0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "Set 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result?.state
                                          ?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager().sendGcodeCommand("G0 X0");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "GO TO 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Y",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(1)!
                                        .userPosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result?.state
                                          ?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Y0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "Set 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result?.state
                                          ?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager().sendGcodeCommand("G0 Y0");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "GO TO 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Z",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(2)!
                                        .userPosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result?.state
                                          ?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Z0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "Set 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result?.state
                                          ?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager().sendGcodeCommand("G0 Z0");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "GO TO 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeumorphicButton(
                          onPressed: global.machineObjectModel.result?.state
                                      ?.status ==
                                  "processing"
                              ? null
                              : () {
                                  String contentXYZ =
                                      ';File\n ;is written after set Zero\necho "${global.machineObjectModel.result?.move?.axes?[0].machinePosition}"\necho "${global.machineObjectModel.result?.move?.axes?[1].machinePosition}"\necho "${global.machineObjectModel.result?.move?.axes?[2].machinePosition}"';
                                  API_Manager().upLoadAFile(
                                      "0:/sys/recoveryXYZ.g",
                                      Uint8List.fromList(
                                              utf8.encode(contentXYZ))
                                          .length
                                          .toString(),
                                      Uint8List.fromList(
                                          utf8.encode(contentXYZ)));
                                  API_Manager()
                                      .sendGcodeCommand("G10 L20 P1 X0 Y0 Z0");
                                  API_Manager().sendGcodeCommand("G10 L20 P1");
                                },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Center(
                            child: Text(
                              "Set 0 XYZ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF707585),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeumorphicButton(
                          onPressed: global.machineObjectModel.result?.state
                                      ?.status ==
                                  "processing"
                              ? null
                              : () {
                                  API_Manager().sendGcodeCommand("G53 G0 Z189");
                                  API_Manager().sendGcodeCommand("G0 X0 Y0");
                                  API_Manager().sendGcodeCommand("G0 Z0");
                                },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Center(
                            child: Text(
                              "GO TO 0 XYZ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF707585),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        )));
    throw UnimplementedError();
  }
}
