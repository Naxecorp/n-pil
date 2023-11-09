import 'dart:async';
import 'dart:convert';
import 'dart:ui';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';
import '../dashBoardWidgets/coord_machine.dart';
import '../dashBoardWidgets/coord_outil.dart';
import '../dashBoardWidgets/vitesse_broche.dart';
import '../dashBoardWidgets/baby_stepZ.dart';
import '../dashBoardWidgets/job_info.dart';
import '../dashBoardWidgets/coef_vitesse.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../widgetUtils/ArretUrgence.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class OriginScreen extends StatefulWidget {
  OriginScreen({super.key, required this.notifyParent});

  final VoidCallback notifyParent;

  @override
  State<OriginScreen> createState() => OriginScreenState(notifyParent);
}

class OriginScreenState extends State<OriginScreen> {
  OriginScreenState(this.notifyParent);

  final Function() notifyParent;

  double ZSaved = 0;

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
                    Container(child: Image(image: AssetImage("assets/iconnaxe.png")))),
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
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  ],
                ))),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: Window(
                  title1: "Changement d'outil",
                  title2: " manuel",
                  child: Column(
                    children: [
                      Flexible(
                          flex: 3,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            //height: double.infinity,
                            width: double.infinity,
                            //color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: EdgeInsets.all(15),
                                    style: NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager()
                                          .sendGcodeCommand("G53 G1 Z189")
                                          .then((value) => API_Manager()
                                              .sendGcodeCommand(
                                                  "G53 G1 X${global.MyMachineN02Config.Palpeur!.PosX} Y${global.MyMachineN02Config.Palpeur!.PosY}"));
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.arrow_right,
                                            color: Color(0xFF707585),
                                          ),
                                          FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Vers palpeur',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: EdgeInsets.all(15),
                                    style: NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager()
                                          .sendGcodeCommand("M106 P3 S255")
                                          .then((value) => API_Manager()
                                              .sendGcodeCommand("G38.2 Z-200")
                                              .then((value) => API_Manager()
                                                  .sendGcodeCommand(
                                                      "M106 P3 S0")));
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.get_app,
                                            color: Color(0xFF707585),
                                          ),
                                          FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Palper outil actuel',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: EdgeInsets.all(15),
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      ZSaved = global.machineObjectModel.result!
                                          .move!.axes![2].userPosition!.toDouble();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('Hauteur Enregistrée'),
                                          duration:
                                              const Duration(milliseconds: 400),
                                        ),
                                      );
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.save_outlined,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Enregistrer hauteur',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            //color: Colors.orange,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: const EdgeInsets.all(15),
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager().sendGcodeCommand(
                                          "G53 G1 Z189 F2000");
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.arrow_drop_up,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "Changer d'outil",
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: const EdgeInsets.all(15),
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager()
                                          .sendGcodeCommand("M106 P3 S255")
                                          .then((value) => API_Manager()
                                              .sendGcodeCommand("G38.2 Z-200")
                                              .then((value) => API_Manager()
                                                  .sendGcodeCommand(
                                                      "M106 P3 S0")));
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.get_app,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Palper outil',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: const EdgeInsets.all(15),
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Z" +
                                              ZSaved.toStringAsFixed(2))
                                          .then((value) => API_Manager()
                                              .sendGcodeCommand("G54"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('Hauteur Enregistrée'),
                                          duration:
                                              const Duration(milliseconds: 400),
                                        ),
                                      );
                                      API_Manager().sendGcodeCommand(
                                          "G91\nG1 Z50 F3700\nG90\n");
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.height,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Restituer hauteur outil',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 3,
                          child: Container(
                            height: double.infinity,
                          )),
                    ],
                  ),
                )),
            const Flexible(
                flex: 1,
                child: Window(
                  title1: "Changement d'outil",
                  title2: " automatique",
                  child: Center(
                    child: Text("Bientôt disponible"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
