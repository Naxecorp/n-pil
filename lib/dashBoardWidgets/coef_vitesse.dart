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

class CoefVitesse extends StatefulWidget {
  @override
  State<CoefVitesse> createState() => CoefVitesseState();
}

class CoefVitesseState extends State<CoefVitesse> {
  double sliderValueSpeedFactor = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderValueSpeedFactor = global.objectModelMove.result?.speedFactor ?? 2;
    sliderValueSpeedFactor = sliderValueSpeedFactor / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
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
                        "Coeficient",
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
                        "  vitesse",
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
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    global.objectModelMove.result?.speedFactor
                            ?.toStringAsFixed(1) ??
                        "???",
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xFF707585)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              sliderValueSpeedFactor =
                                  ((sliderValueSpeedFactor * 200 - 10) / 200);
                              API_Manager()
                                  .sendGcodeCommand(
                                      "M220 S${sliderValueSpeedFactor * 200}")
                                  .then((value) {
                                setState(() {});
                              });
                            });
                          },
                          child: const Text(
                            "-",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                          )),
                      Slider(
                          activeColor: const Color(0xFF20917F),
                          inactiveColor:
                              const Color(0xFF20917F).withOpacity(0.2),
                          onChangeEnd: (double value) {
                            API_Manager()
                                .sendGcodeCommand(
                                    "M220 S${sliderValueSpeedFactor * 200}")
                                .then((value) {
                              setState(() {});
                            });
                          },
                          value: sliderValueSpeedFactor,
                          onChanged: (double value) {
                            setState(() {
                              sliderValueSpeedFactor = value;
                            });
                          }),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              sliderValueSpeedFactor =
                                  ((sliderValueSpeedFactor * 200 + 10) / 200);
                              API_Manager()
                                  .sendGcodeCommand(
                                      "M220 S${sliderValueSpeedFactor * 200}")
                                  .then((value) {
                                setState(() {});
                              });
                            });
                          },
                          child: const Text(
                            "+",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                          )),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
