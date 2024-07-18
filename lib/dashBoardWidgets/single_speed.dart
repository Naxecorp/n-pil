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
  final TextEditingController spindleValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F0F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSpindleSpeedDisplay(),
          _buildSpindleControl(),
          _buildActionButtons(),
          if (global.MyMachineN02Config.HasACT == 1) _buildToolStatus(),
        ],
      ),
    );
  }

  Widget _buildSpindleSpeedDisplay() {
    return Flexible(
      flex: 20,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(13),
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              children: [
                Text(
                  global.machineObjectModel.result?.spindles?[0].current
                          .toString() ??
                      "???",
                  style:
                      const TextStyle(fontSize: 2000, color: Color(0xFF707585)),
                ),
                const Text(
                  " tr/min",
                  style: TextStyle(fontSize: 800, color: Color(0xFF707585)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpindleControl() {
    return Flexible(
      flex: 15,
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 7,
              child: Neumorphic(
                style:
                    const NeumorphicStyle(color: Color(0xFFF0F0F3), depth: -5),
                child: TextField(
                  controller: spindleValueController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 2,
              child: NeumorphicButton(
                style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                onPressed: _onSpindleSubmit,
                child: const Icon(Icons.send, color: Color(0xFF707585)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSpindleSubmit() {
    if (int.parse(spindleValueController.text) >
        int.parse(global.MyMachineN02Config.VitesseBroche.toString())) {
      _showAlertDialog("La vitesse saisie est trop élevée !");
      spindleValueController.clear();
    } else if (int.parse(spindleValueController.text) <
        int.parse(global.MyMachineN02Config.VitesseDefaut.toString())) {
      _showAlertDialog("La vitesse saisie est trop faible !");
      spindleValueController.clear();
    } else {
      API_Manager().sendGcodeCommand("M5 P0").then((value) {
        API_Manager()
            .sendGcodeCommand("M3 P0 S${spindleValueController.text}")
            .then((value) {
          spindleValueController.clear();
        });
      });
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Flexible(
      flex: 20,
      child: Container(
        padding: global.MyMachineN02Config.HasACT == 1
            ? const EdgeInsets.all(15)
            : const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        height: double.infinity,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildActionButtonList(),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtonList() {
    List<Widget> buttons = [];

    if (global.MyMachineN02Config.HasACT == 1) {
      buttons.addAll([
        _buildActionButton(
          icon: Icons.air_rounded,
          label: 'Souffler',
          onPressed: _onAirButtonPressed,
          depthCondition:
              (global.machineObjectModel.result?.state?.gpOut?[1]!.pwm ?? 0) >
                  0,
        ),
        _buildActionButton(
          icon: Icons.unfold_more_rounded,
          label: 'Piston',
          onPressed: _onPistonButtonPressed,
          depthCondition:
              (global.machineObjectModel.result?.state?.gpOut?[2]!.pwm ?? 0) >
                  0,
        ),
      ]);
    }

    buttons.addAll([
      _buildActionButton(
        icon: Icons.thermostat_outlined,
        label: 'Vent. Broche',
        onPressed: _onSpindleFanButtonPressed,
        depthCondition:
            (global.machineObjectModel.result?.fans?[3]!.actualValue ?? 0) > 0,
      ),
      _buildActionButton(
        icon: Icons.rotate_left,
        label: '10% Broche',
        onPressed: _onSpindleStartButtonPressed,
        depthCondition:
            ((global.machineObjectModel.result?.spindles?[0].current) ?? 0.0) >
                0,
      ),
      _buildActionButton(
        icon: Icons.do_disturb_alt_outlined,
        label: 'Stop Broche',
        onPressed: _onSpindleStopButtonPressed,
        depthCondition:
            ((global.machineObjectModel.result?.spindles?[0].current) ?? 0.0) >
                0,
      ),
    ]);

    return buttons;
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool depthCondition,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: NeumorphicButton(
        margin: const EdgeInsets.all(5),
        style: NeumorphicStyle(
          depth: depthCondition ? -5 : 5,
          color: const Color(0xFFF0F0F3),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, color: Color(0xFF707585)),
            FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(label, style: TextStyle(color: Color(0xFF707585))),
            ),
          ],
        ),
      ),
    );
  }

  void _onAirButtonPressed() {
    if ((global.machineObjectModel.result?.sensors?.gpIn?[0]?.value ?? 0) ==
        1) {
      if ((global.machineObjectModel.result?.state?.gpOut?[1]!.pwm ?? 0) > 0) {
        API_Manager()
            .sendGcodeCommand("M42 P1 S0")
            .then((value) => setState(() {}));
      } else {
        API_Manager()
            .sendGcodeCommand("M42 P1 S1")
            .then((value) => setState(() {}));
      }
    }
  }

  void _onPistonButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: ((global.machineObjectModel.result?.state?.gpOut?[2]!.pwm ??
                      0) >
                  0)
              ? const Text(
                  "Attention !\nPrésenter un outil dans la broche avant de valider.")
              : const Text(
                  "Attention !\nRisque de chute. Êtes-vous sûr de vouloir libérer l'outil ?"),
          actions: <Widget>[
            ElevatedButton.icon(
              label:
                  const Text("Executer", style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.check_outlined, color: Colors.white),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if ((global.machineObjectModel.result?.sensors?.gpIn?[0]
                            ?.value ??
                        0) ==
                    1) {
                  if ((global.machineObjectModel.result?.state?.gpOut?[2]!
                              .pwm ??
                          0) >
                      0) {
                    API_Manager().sendGcodeCommand("M42 P2 S0").then((value) {
                      setState(() {});
                      Navigator.of(context).pop();
                    });
                  } else {
                    API_Manager().sendGcodeCommand("M42 P2 S1").then((value) {
                      setState(() {});
                      Navigator.of(context).pop();
                    });
                  }
                }
              },
            ),
            ElevatedButton.icon(
              label:
                  const Text("Annuler", style: TextStyle(color: Colors.white)),
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _onSpindleFanButtonPressed() {
    if ((global.machineObjectModel.result?.fans?[3]!.actualValue ?? 0) > 0) {
      API_Manager()
          .sendGcodeCommand("M106 P3 S0")
          .then((value) => setState(() {}));
    } else {
      API_Manager()
          .sendGcodeCommand("M106 P3 S255")
          .then((value) => setState(() {}));
    }
  }

  void _onSpindleStartButtonPressed() {
    if (((global.machineObjectModel.result?.spindles?[0].current) ?? 0.0) ==
        0) {
      API_Manager().sendGcodeCommand("M5 P0").then((value) {
        API_Manager()
            .sendGcodeCommand(
                "M3 P0 S${global.MyMachineN02Config.VitesseDefaut ?? 6000}")
            .then((value) {
          setState(() {});
        });
      });
    } else {
      API_Manager().sendGcodeCommand("M5 P0").then((value) {
        setState(() {});
      });
    }
  }

  void _onSpindleStopButtonPressed() {
    if (((global.machineObjectModel.result?.spindles?[0].current) ?? 0.0) > 0) {
      API_Manager().sendGcodeCommand("M5 P0").then((value) {
        setState(() {});
      });
    }
  }

  Widget _buildToolStatus() {
    return Flexible(
      flex: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Status Tool :',
            style: TextStyle(fontSize: 12.0),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: (global.machineObjectModel.result?.tools?.length ?? 3),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var value =
                    global.machineObjectModel.result?.tools?[index].state;

                Color color;
                if (value == null || value == "off") {
                  color = Colors.grey;
                } else if (value == "active") {
                  color = Colors.green;
                } else if (value == "standby") {
                  color = Colors.blue;
                } else {
                  color = Colors.grey;
                }

                return Container(
                  margin: const EdgeInsets.all(4.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.circle, color: color, size: 24.0),
                      Text(
                        '$index',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
