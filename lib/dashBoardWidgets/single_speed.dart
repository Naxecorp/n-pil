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

class SpindleSpeed extends StatefulWidget {
  const SpindleSpeed({super.key, this.child});

  final Widget? child;

  @override
  State<SpindleSpeed> createState() => SpindleSpeedState();
}

class SpindleSpeedState extends State<SpindleSpeed> {
  TextEditingController SpindleValueController = TextEditingController();
  bool SpindleFanIsOn = false;
  bool SpindleIsOn = false;

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Column(
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
                          child: Column(
                            children: [
                              Text(
                                global.machineObjectModel.result?.spindles?[0]
                                        .current
                                        .toString() ??
                                    "???",
                                style: const TextStyle(
                                    fontSize: 2000, color: Color(0xFF707585)),
                              ),
                              const Text(
                                " Trs/min",
                                style: TextStyle(
                                    fontSize: 800, color: Color(0xFF707585)),
                              ),
                            ],
                          ))),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Neumorphic(
                          style: const NeumorphicStyle(
                              color: Color(0xFFF0F0F3), depth: -5),
                          //color: Colors.green,
                          child: Container(
                              child: TextField(
                            controller: SpindleValueController,
                            keyboardType: TextInputType.number,
                          )),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: NeumorphicButton(
                            style:
                                const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                            onPressed: () {
                              setState(() {
                                API_Manager()
                                    .sendGcodeCommand("M5 P0")
                                    .then((value) {
                                  API_Manager()
                                      .sendGcodeCommand(
                                          "M3 P0 S${SpindleValueController.text}")
                                      .then((value) {
                                    SpindleValueController.clear();
                                  });
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
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(15),
                          style: NeumorphicStyle(
                            depth: global.machineObjectModel.result!.fans![3]!
                                        .actualValue! >
                                    0
                                ? -5
                                : 5, //SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            if (global.machineObjectModel.result!.fans![3]!
                                    .actualValue! >
                                0)
                              API_Manager()
                                  .sendGcodeCommand("M106 P3 S0")
                                  .then((value) {
                                setState(() {});
                              });
                            else
                              API_Manager()
                                  .sendGcodeCommand("M106 P3 S255")
                                  .then((value) {
                                setState(() {});
                              });
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.thermostat_outlined,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Vent. Broche',
                                      style:
                                          TextStyle(color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(15),
                          style: NeumorphicStyle(
                            depth: global.machineObjectModel.result!
                                        .spindles![0]!.current! >
                                    0
                                ? -5
                                : 5, //SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            if (global.machineObjectModel.result!.spindles![0]!
                                    .current ==
                                0)
                              API_Manager()
                                  .sendGcodeCommand("M5 P0")
                                  .then((value) {
                                API_Manager().sendGcodeCommand("M3 P0 S6000");
                                setState(() {});
                              });
                            else
                              API_Manager()
                                  .sendGcodeCommand("M5 P0")
                                  .then((value) {
                                setState(() {});
                              });
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.rotate_left,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '10% Broche',
                                      style:
                                          TextStyle(color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(15),
                          style: NeumorphicStyle(
                            depth: global.machineObjectModel.result!
                                        .spindles![0]!.current! >
                                    0
                                ? 5
                                : -5, //SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            if (global.machineObjectModel.result!.spindles![0]!
                                    .current! >
                                0)
                              API_Manager()
                                  .sendGcodeCommand("M5 P0")
                                  .then((value) {
                                setState(() {});
                              });
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.do_disturb_alt_outlined,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Stop Broche',
                                      style:
                                          TextStyle(color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
    throw UnimplementedError();
  }
}
