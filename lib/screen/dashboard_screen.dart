import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

void checkErrorDrive(BuildContext context) {
  Timer.periodic(const Duration(milliseconds: 600), (timer) {
    timer.cancel();
    if (global.isErrorDriver == true) {
      global.isErrorDriver = false;
      timer.cancel();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Vous devez réinitialiser les origines, machine et programme",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  global.isErrorDriver = false;
                  timer.cancel();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Fermer",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        },
      );
    }
  });
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardScreenState(this.notifyParent);

  final Function() notifyParent;

  @override
  void initState() {
    super.initState();
    global.streamMachineObjectModel.listen((value) {
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 2), () {
      global.checkCaissonOpen(context);
      print("check");
    });

    global.checkAndShowDialog(context);
    checkErrorDrive(context);
  }

  // Fonction qui regarde si les 3 axes sont homes et va au dernières coordonées machines
  Future<void> actualiserHomeMachine() async {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (global.objectModelMove.result?.axes?.elementAt(0).homed == true &&
          global.objectModelMove.result?.axes?.elementAt(1).homed == true &&
          global.objectModelMove.result?.axes?.elementAt(2).homed == true) {
        timer.cancel();
        String posXYZ = "";
        // Récupère les données du fichier "recovenyXYZ.g"
        await API_Manager().sendGcodeCommand('M98 P"recoveryXYZ.g"').then(
            (value) => API_Manager()
                .sendrr_reply()
                .then((response) => posXYZ = response.trim()));

        String posX;
        String posY;
        String posZ;

        posX = posXYZ.split('\n')[0];
        posY = posXYZ.split('\n')[1];
        posZ = posXYZ.split('\n')[2];

        await Future.delayed(const Duration(seconds: 3));
        // Récupère le resultat du GCode
        await API_Manager()
            .sendGcodeCommand("G53 G0 X${posX}")
            .then((value) => API_Manager().sendrr_reply());
        await Future.delayed(Duration(seconds: 3));
        // Récupère le resultat du GCode
        await API_Manager()
            .sendGcodeCommand("G53 G0 Y${posY}")
            .then((value) => API_Manager().sendrr_reply());
        await Future.delayed(Duration(seconds: 3));
        // Récupère le resultat du GCode
        await API_Manager()
            .sendGcodeCommand("G53 G0 Z${posZ}")
            .then((value) => API_Manager().sendrr_reply());

        Navigator.of(context).pop();
      }
    });
  }

  // Fonction de redemarrage lors de l'emergency stop
  void loadingPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Empêche la fermeture de la boîte de dialogue en cliquant en dehors d'elle
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Redémarrage en cours"),
          content: CircularProgressIndicator(
            color: Colors.blue,
          ), // Ajoute une animation de chargement (cercle tournant)
          actions: <Widget>[],
        );
      },
    );
    Timer(Duration(seconds: 12), () {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible:
            false, // Empêche la fermeture de la boîte de dialogue en cliquant en dehors d'elle
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text("Voulez-vous restaurer les anciennes positions machine ?"),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  await API_Manager().sendGcodeCommand('G28 Z\nG28 X\nG28 Y');
                  await Future.delayed(Duration(seconds: 1));
                  await actualiserHomeMachine();
                  Navigator.of(context).pop();
                  global.isRestarting = false;
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Empêche la fermeture de la boîte de dialogue en cliquant en dehors d'elle
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text("Récupération en cours..."),
                        content: CircularProgressIndicator(
                          color: Colors.blue,
                        ), // Ajoute une animation de chargement (cercle tournant)
                      );
                    },
                  );
                },
                child: Text(
                  "Oui",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  global.isRestarting = false;
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: Text(
                  "Non",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
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
                child: Container(
                    child: Image(image: AssetImage('assets/iconnaxe.png')))),
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
                            API_Manager()
                                .sendGcodeCommand(Commande)
                                .then((value) => API_Manager().sendrr_reply());
                          });
                          print(Commande);
                        },
                      ),
                    ),
                    Spacer(),
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: global.machineObjectModel.result?.state?.status
                                  ?.toString() ==
                              "halted"
                          ? () {
                              global.isRestarting = true;
                              API_Manager().pushDataToDb(
                                  global.MyMachineN02Config.Serie ?? "NUMSTD",
                                  "AR Urgence");
                              API_Manager().sendGcodeCommand("M999");
                              loadingPopup(context);
                            }
                          : null,
                      child: Text(
                        "Aquiter AU",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
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
                                                    child: Text("unkown mode"),
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
