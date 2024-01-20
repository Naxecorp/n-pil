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

class ModeMachine extends StatefulWidget {
  const ModeMachine({super.key, this.child});

  final Widget? child;

  @override
  State<ModeMachine> createState() => ModeMachineState();
}

class ModeMachineState extends State<ModeMachine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F0F3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicRadio(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              style: const NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.fff,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand("M451");
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
                await API_Manager().sendGcodeCommand('M98 P"extrudercrea.g"');
              },
              child: const Text(
                "FFF",
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
            NeumorphicRadio(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              style: const NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.laser,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand('M98 P"lasercrea.g"');
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
              },
              child: const Text(
                "Laser",
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
            NeumorphicRadio(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              style: const NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.cnc,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand("M453");
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
                await API_Manager().sendGcodeCommand('M98 P"spindlecrea.g"').then((value) => API_Manager().sendrr_reply());
              },
              child: const Text(
                "CNC",
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
