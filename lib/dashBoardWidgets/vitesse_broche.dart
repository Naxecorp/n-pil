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

class VitesseBroche extends StatefulWidget {
  @override
  State<VitesseBroche> createState() => VitesseBrocheState();
}

class VitesseBrocheState extends State<VitesseBroche> {
  double sliderValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderValue = global.machineObjectModel.result?.spindles?[0].current ?? 0.1;
    sliderValue = sliderValue / 24000;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                          "Vitesse",
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
                          " broche",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.w100,
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
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        global.machineObjectModel.result?.spindles?[0].current
                                .toString() ??
                            "???",
                        style: const TextStyle(
                            fontSize: 35, color: Color(0xFF707585)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if ((sliderValue * 24000) >= 250)
                                    sliderValue =
                                        ((sliderValue * 24000 - 250) / 24000);
                                  if (sliderValue * 24000 > 12000) {
                                    API_Manager()
                                        .sendGcodeCommand("M5 P0")
                                        .then((value) {
                                      API_Manager()
                                          .sendGcodeCommand(
                                              "M3 P0 S${sliderValue * 24000}")
                                          .then((value) {
                                        setState(() {});
                                      });
                                    });
                                  }
                                });
                              },
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontSize: 60, color: Colors.black26),
                              )),
                          Slider(
                              activeColor: const Color(0xFF20917F),
                              inactiveColor:
                                  const Color(0xFF20917F).withOpacity(0.2),
                              onChangeEnd: (double value) {
                                if (sliderValue * 24000 > 12000) {
                                  API_Manager()
                                      .sendGcodeCommand("M5 P0")
                                      .then((value) {
                                    API_Manager()
                                        .sendGcodeCommand(
                                            "M3 P0 S${sliderValue * 24000}")
                                        .then((value) {
                                      setState(() {});
                                    });
                                  });
                                }
                              },
                              value: sliderValue,
                              onChanged: (double value) {
                                setState(() {
                                  sliderValue = value;
                                });
                              }),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if ((sliderValue * 24000) < 24000)
                                    sliderValue =
                                        ((sliderValue * 24000 + 250) / 24000);
                                  if (sliderValue * 24000 > 12000) {
                                    API_Manager()
                                        .sendGcodeCommand("M5 P0")
                                        .then((value) {
                                      API_Manager()
                                          .sendGcodeCommand(
                                              "M3 P0 S${sliderValue * 24000}")
                                          .then((value) {
                                        setState(() {});
                                      });
                                    });
                                  }
                                });
                              },
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontSize: 50, color: Colors.black26),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
