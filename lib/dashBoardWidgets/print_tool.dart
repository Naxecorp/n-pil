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

  void setTemperaturePopUp(BuildContext context, String heaterToSet) {
    TextEditingController _controllerTempe = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Programmer température :"),
          content: TextFormField(
            controller: _controllerTempe,
            onFieldSubmitted: (value) {
              if (heaterToSet == "head")
                API_Manager().sendGcodeCommand("M104 S$value").then((value) =>
                    API_Manager()
                        .sendrr_reply()
                        .then((response) => global.ReplyList.add(response)));
              if (heaterToSet == "bed")
                API_Manager().sendGcodeCommand("M140 S$value").then((value) =>
                    API_Manager()
                        .sendrr_reply()
                        .then((response) => global.ReplyList.add(response)));
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

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
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  //color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: EdgeInsets.all(
                              (MediaQuery.of(context).size.height * 0.05)
                                  .toDouble()),
                          child: NeumorphicButton(
                            onPressed: () {
                              setTemperaturePopUp(context, "head");
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Head"),
                                Text(global.machineObjectModel.result?.heat
                                        ?.heaters?[0].current
                                        .toString() ??
                                    "..."),
                                Text(
                                    "/ ${(global.machineObjectModel.result?.heat?.heaters?[0].standby) ?? 0}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: EdgeInsets.all(
                              (MediaQuery.of(context).size.height * 0.05)
                                  .toDouble()),
                          child: NeumorphicButton(
                            onPressed: () {
                              setTemperaturePopUp(context, "bed");
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Bed"),
                                Text(global.machineObjectModel.result?.heat
                                        ?.heaters?[1].current
                                        .toString() ??
                                    "..."),
                                Text(
                                    "/ ${(global.machineObjectModel.result?.heat?.heaters?[1].standby) ?? 0}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NeumorphicButton(
                          style:
                              const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                          onPressed: () {
                            setState(() {
                              global.ExtrudeFactor = global.objectModelMove
                                      .result?.extruders?[0].factor?.toDouble() ??
                                  global.ExtrudeFactor;
                              global.ExtrudeFactor += 10;
                              API_Manager().sendGcodeCommand(
                                  "M221 S${global.ExtrudeFactor}");
                            });
                          },
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF707585),
                          ),
                        ),
                        Text("Débit: ${global.objectModelMove.result?.extruders?[0].factor??"..."}"),
                        NeumorphicButton(
                          style:
                              const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                          onPressed: () {
                            setState(() {
                              global.ExtrudeFactor = global.objectModelMove
                                      .result?.extruders?[0].factor?.toDouble() ??
                                  global.ExtrudeFactor;
                              if (global.ExtrudeFactor >= 20)
                                global.ExtrudeFactor -= 10;
                              API_Manager().sendGcodeCommand(
                                  "M221 S${global.ExtrudeFactor}");
                            });
                          },
                          child: const Icon(
                            Icons.remove,
                            color: Color(0xFF707585),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NeumorphicButton(
                          style:
                              const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                          onPressed: () {
                            setState(() {
                              global.VentilatorFan = global.machineObjectModel
                                      .result?.fans?[0]?.actualValue
                                      ?.toDouble() ??
                                  global.VentilatorFan;
                              global.VentilatorFan += 10;
                              API_Manager().sendGcodeCommand(
                                  "M106 P0 S${global.VentilatorFan}").then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                            });
                          },
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF707585),
                          ),
                        ),
                        Text("Fan: ${global.machineObjectModel.result?.fans?[0]?.actualValue??"..."}"),
                        NeumorphicButton(
                          style:const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                          onPressed: () {
                            setState(() {
                              global.VentilatorFan = global.machineObjectModel
                                      .result?.fans?[0]?.actualValue?.toDouble()??global.VentilatorFan;
                              if (global.VentilatorFan >= 20)
                                global.VentilatorFan -= 10;
                              API_Manager().sendGcodeCommand(
                                  "M106 P0 S${global.VentilatorFan}").then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                            });
                          },
                          child: const Icon(
                            Icons.remove,
                            color: Color(0xFF707585),
                          ),
                        )
                      ],
                    ),
                  ],
                ))
          ],
        ));
    throw UnimplementedError();
  }
}
