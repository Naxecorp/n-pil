import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/ArretUrgence.dart';
import '../menus/family_menu.dart';
import '../familleviewer.dart';
import '../menus/bottomMenu/bottomMenu.dart';
import '../OpeListView.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

String opeToShow = 'none';
String FamillyToShow = 'classique';
int OpeSelected = 0;
TextEditingController ManualGcodeComand = TextEditingController();
BottomMenu myBottomMenu = BottomMenu();

List<String> ProgramCurrent = <String>[];

TextEditingController controller = TextEditingController();

int offsetSelected = 54;

// PAGE SET POSITION
/*
class SetPos extends StatefulWidget {
  @override
  _SetPosState createState() => _SetPosState();
}

class _SetPosState extends State<SetPos> {
  double? xa = 0.0;
  double? ya = 0.0;
  double? za = 150.0;

  double? xb = 0.0;
  double? yb = 0.0;
  double? zb = 150.0;

  double? xc = 0.0;
  double? yc = 0.0;
  double? zc = 150.0;

  @override
  void initState() {
    //setCustomPos();
  }

  void setCustomPosa() {
    xa = global.machineObjectModel.result?.move?.axes?[0]
        .userPosition ?? 0;
    ya = global.machineObjectModel.result?.move?.axes?[1]
        .userPosition ?? 0;
    za = global.machineObjectModel.result!.move?.axes?[2]
        .userPosition ?? 0;
  }

  Future<void> goCustomPosa() async {
    await API_Manager().sendGcodeCommand("G0 Z20");
    await API_Manager().sendGcodeCommand("G0 X$xa Y$ya");
    await API_Manager().sendGcodeCommand("G0 Z$za");
  }

  void setCustomPosb() {
    xb = global.machineObjectModel.result?.move?.axes?[0]
        .userPosition ?? 0;
    yb = global.machineObjectModel.result?.move?.axes?[1]
        .userPosition ?? 0;
    zb = global.machineObjectModel.result!.move?.axes?[2]
        .userPosition ?? 0;
  }

  Future<void> goCustomPosb() async {
    await API_Manager().sendGcodeCommand("G0 Z20");
    await API_Manager().sendGcodeCommand("G0 X$xb Y$yb");
    await API_Manager().sendGcodeCommand("G0 Z$zb");
  }

  void setCustomPosc() {
    xc = global.machineObjectModel.result?.move?.axes?[0]
        .userPosition ?? 0;
    yc = global.machineObjectModel.result?.move?.axes?[1]
        .userPosition ?? 0;
    zc = global.machineObjectModel.result!.move?.axes?[2]
        .userPosition ?? 0;
  }

  Future<void> goCustomPosc() async {
    await API_Manager().sendGcodeCommand("G0 Z20");
    await API_Manager().sendGcodeCommand("G0 X$xc Y$yc");
    await API_Manager().sendGcodeCommand("G0 Z$zc");
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
              child: Container(child: Image(image: AssetImage('iconnaxe.png'))),
            ),
            Flexible(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
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
                            API_Manager().sendGcodeCommand(Commande).then((
                                value) {
                              API_Manager().sendrr_reply().then((response) {
                                global.ReplyList.add(response);
                              });
                            });
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
                ),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Valeurs personnalisées :"),
                Text("X: ${xa ?? 0}"),
                Text("Y: ${ya ?? 0}"),
                Text("Z: ${za ?? 150}"),
                ElevatedButton(
                  onPressed: () {
                    setCustomPosa();
                  },
                  child: Text("Set la position actuelle"),
                ),
                ElevatedButton(
                  onPressed: () {
                    goCustomPosa();
                  },
                  child: Text("Aller à la position personnalisée"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Valeurs personnalisées :"),
                Text("X: ${xb ?? 0}"),
                Text("Y: ${yb ?? 0}"),
                Text("Z: ${zb ?? 150}"),
                ElevatedButton(
                  onPressed: () {
                    setCustomPosb();
                  },
                  child: Text("Set la position actuelle"),
                ),
                ElevatedButton(
                  onPressed: () {
                    goCustomPosb();
                  },
                  child: Text("Aller à la position personnalisée"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Valeurs personnalisées :"),
                Text("X: ${xc ?? 0}"),
                Text("Y: ${yc ?? 0}"),
                Text("Z: ${zc ?? 150}"),
                ElevatedButton(
                  onPressed: () {
                    setCustomPosc();
                  },
                  child: Text("Set la position actuelle"),
                ),
                ElevatedButton(
                  onPressed: () {
                    goCustomPosc();
                  },
                  child: Text("Aller à la position personnalisée"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
