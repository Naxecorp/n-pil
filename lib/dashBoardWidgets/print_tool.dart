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

class PrintToolsTemperature extends StatefulWidget {
  const PrintToolsTemperature({super.key, this.child});

  final Widget? child;

  @override
  State<PrintToolsTemperature> createState() => PrintToolsTemperatureState();
}

class PrintToolsTemperatureState extends State<PrintToolsTemperature> {
  TextEditingController TemperatureValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(flex: 1, child: Text('  Tête')),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Text(
                                            global.machineObjectModel.result
                                                    ?.heat?.heaters?[1].current
                                                    .toString() ??
                                                "???",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF707585)),
                                          ),
                                          const Text(
                                            " °C",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF707585)),
                                          ),
                                        ],
                                      ))),
                            )),
                        Flexible(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              height: double.infinity,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Neumorphic(
                                      style: const NeumorphicStyle(
                                          color: Color(0xFFF0F0F3), depth: -5),
                                      //color: Colors.green,
                                      child: Container(
                                          child: TextField(
                                        controller: TemperatureValueController,
                                        keyboardType: TextInputType.number,
                                      )),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: NeumorphicButton(
                                        style: const NeumorphicStyle(
                                            color: Color(0xFFF0F0F3)),
                                        onPressed: () {
                                          setState(() {
                                            API_Manager()
                                                .sendGcodeCommand(
                                                    "M104 S${TemperatureValueController.text}")
                                                .then((value) {
                                              TemperatureValueController
                                                  .clear();
                                            });
                                          });
                                        },
                                        child: const Icon(
                                          Icons.send,
                                          color: Color(0xFF707585),
                                        ),
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(flex: 1, child: Text('  Lit')),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Text(
                                            global.machineObjectModel.result
                                                    ?.heat?.heaters?[0].current
                                                    .toString() ??
                                                "???",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF707585)),
                                          ),
                                          const Text(
                                            " °C",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF707585)),
                                          ),
                                        ],
                                      ))),
                            )),
                        Flexible(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              height: double.infinity,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Neumorphic(
                                      style: const NeumorphicStyle(
                                          color: Color(0xFFF0F0F3), depth: -5),
                                      //color: Colors.green,
                                      child: Container(
                                          child: TextField(
                                        controller: TemperatureValueController,
                                        keyboardType: TextInputType.number,
                                      )),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: NeumorphicButton(
                                        style: const NeumorphicStyle(
                                            color: Color(0xFFF0F0F3)),
                                        onPressed: () {
                                          setState(() {
                                            API_Manager()
                                                .sendGcodeCommand(
                                                    "M109 S${TemperatureValueController.text}")
                                                .then((value) {
                                              TemperatureValueController
                                                  .clear();
                                            });
                                          });
                                        },
                                        child: const Icon(
                                          Icons.send,
                                          color: Color(0xFF707585),
                                        ),
                                      ))
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
    throw UnimplementedError();
  }
}
