import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../dashBoardWidgets/coord_machine.dart';
import '../dashBoardWidgets/coord_outil.dart';
import '../dashBoardWidgets/deplacement_machine.dart';
import '../dashBoardWidgets/info_system.dart';
import '../dashBoardWidgets/laser_power.dart';
import '../dashBoardWidgets/mode_machine.dart';
import '../dashBoardWidgets/print_tool.dart';
import '../dashBoardWidgets/single_speed.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, required this.notifyParent});

  final VoidCallback notifyParent;

  @override
  State<DashboardScreen> createState() => DashboardScreenState(notifyParent);
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardScreenState(this.notifyParent);

  final Function() notifyParent;

  @override
  void initState() {
    global.streamMachineObjectModel.listen((value) {
      setState(() {});
    });
  }

  void loadingPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche la fermeture de la boîte de dialogue en cliquant en dehors d'elle
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Redémarrage en cours"),
          content:
              CircularProgressIndicator(), // Ajoute une animation de chargement (cercle tournant)
          actions: <Widget>[],
        );
      },
    );
    Timer(Duration(seconds: 12), () {
      Navigator.of(context).pop(); // Ferme la boîte de dialogue
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: Color(0xFFF0F0F3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child:
                    Container(child: Image(image: AssetImage('iconnaxe.png')))),
            Flexible(
                flex: 10,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      //margin: EdgeInsets.all(40),
                      child: TextField(
                        controller: ManualGcodeComand,
                        decoration: InputDecoration(
                          hintText: "Gcode",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gapPadding: 5.0,
                          ),
                        ),
                        onSubmitted: (Commande) {
                          setState(() {
                            ManualGcodeComand.clear();
                            API_Manager().sendGcodeCommand(Commande).then(
                                (value) => API_Manager().sendrr_reply().then(
                                    (response) =>
                                        global.ReplyList.add(response)));
                          });
                          print(Commande);
                        },
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF707585),
                      ),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(global.Title),
                          content: RichText(
                            text: const TextSpan(
                              text: 'Features :\n',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                              children: [
                                TextSpan(
                                  text: "to",
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Fermer'),
                              child: const Text('Fermer'),
                            ),
                          ],
                        ),
                      ),
                      child: Text(global.Title),
                    ),
                    Spacer(),
                    ElevatedButton(
                        onPressed: global
                                    .machineObjectModel.result?.state?.status
                                    ?.toString() ==
                                "halted"
                            ? () {
                                API_Manager().sendGcodeCommand("M999");
                                loadingPopup(context);
                              }
                            : null,
                        child: Text("Aquiter AU"))
                  ],
                ))),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Row(
                children: [
                  Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      child: Window(
                                        title1: "Position ",
                                        title2: " machine",
                                        child: CoordoneesMachine(),
                                      ),
                                    )),
                                Flexible(
                                    flex: 2,
                                    child: Container(
                                      child: Window(
                                        title1: "Position ",
                                        title2: " outil",
                                        child: CoordoneesOutil(),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Window(
                                    title1: "Info ",
                                    title2: " System",
                                    child: InfoSystem(),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Window(
                                    title1: "Mode",
                                    title2: " machine",
                                    child: ModeMachine(),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Window(
                                    title1: "Info. ",
                                    title2: " Outil",
                                    child: global.machineMode == MachineMode.cnc
                                        ? SpindleSpeed()
                                        : global.machineMode == MachineMode.fff
                                            ? PrintToolsTemperature()
                                            : global.machineMode ==
                                                    MachineMode.laser
                                                ? LaserToolPower()
                                                : Container(
                                                    child: Text(
                                                        "Pas d'outils détectés"),
                                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 3,
                      child: Window(
                        title1: "Déplacement ",
                        title2: " machine",
                        child: DeplacementMachine(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
