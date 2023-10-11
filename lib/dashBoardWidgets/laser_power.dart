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

class LaserToolPower extends StatefulWidget {
  const LaserToolPower({super.key, this.child});

  final Widget? child;

  @override
  State<LaserToolPower> createState() => LaserToolPowerState();
}

class LaserToolPowerState extends State<LaserToolPower> {
  TextEditingController LaserValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Center(
      child: Container(
          color: const Color(0xFFF0F0F3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    margin: const EdgeInsets.all(20),
                    style: NeumorphicStyle(
                      //depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                      color: const Color(0xFFF0F0F3),
                    ),
                    onPressed: () async {
                      await API_Manager().sendGcodeCommand('M452 C"nil"');
                      await API_Manager().sendGcodeCommand('M950 P1 C"out5-"');
                      await API_Manager().sendGcodeCommand('M42 P1 S0.01');
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            color: Color(0xFF707585),
                          ),
                          const FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                'On',
                                style: TextStyle(color: Color(0xFF707585)),
                              ))
                        ]),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    margin: const EdgeInsets.all(20),
                    style: NeumorphicStyle(
                      //depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                      color: const Color(0xFFF0F0F3),
                    ),
                    onPressed: () async {
                      await API_Manager().sendGcodeCommand('M42 P1 S0');
                      await API_Manager().sendGcodeCommand('M950 P1 C"nil"');
                      await API_Manager().sendGcodeCommand('M452 C"out5-" S1');
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.lightbulb_outlined,
                            color: Color(0xFF707585),
                          ),
                          Text(
                            'Off',
                            style: TextStyle(color: Color(0xFF707585)),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          )),
    );
    throw UnimplementedError();
  }
}
