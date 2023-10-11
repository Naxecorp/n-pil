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
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class ParametreScreen extends StatefulWidget {
  @override
  State<ParametreScreen> createState() => ParametreScreenState();
}

class ParametreScreenState extends State<ParametreScreen> {
  final TextEditingController _controllers = TextEditingController();

  @override
  initState() {
    super.initState();
    onReceivedData();
  }

  void saveConfig() {
    global.MyMachineN02Config.Lastmodifition = DateTime.now().toString();
    API_Manager().upLoadAFile(
        "0:/sys/nwc-settings.json",
        global.MyMachineN02Config.toJson().length.toString(),
        Uint8List.fromList(
            machineN02ConfigToJson(global.MyMachineN02Config).codeUnits));
    print(machineN02ConfigToJson(global.MyMachineN02Config));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F3),
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
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Window(
                          title1: "Paramêtres",
                          title2: " généraux",
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 500,
                                    child: Text(
                                      "Temps d'utilisation global : ${Duration(minutes: global.MyMachineN02Config.GlobalMachineUsedTime!).inDays}:${Duration(minutes: global.MyMachineN02Config.GlobalMachineUsedTime!).inHours}:${Duration(minutes: global.MyMachineN02Config.GlobalMachineUsedTime!).inMinutes}",
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Window(
                          title1: "Paramêtres",
                          title2: " machine",
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      'Coordonées du palpeur outil X  :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02Config.Palpeur!.PosX
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!
                                            .PosX = double.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      'Coordonées du palpeur outil Y  :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02Config.Palpeur!.PosY
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!
                                            .PosY = double.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      'Hauteur du palpeur outil Z  :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02Config.Palpeur!.Height
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!
                                            .Height = double.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Window(
                          title1: "Paramêtres",
                          title2: " avancés",
                        ),
                      )),
                ],
              ),
            ),
            Flexible(
                flex: 1,
                child: NeumorphicButton(
                  onPressed: () {
                    saveConfig();
                  },
                  child: Text('Save Config'),
                ))
          ],
        ),
      ),
    );
  }

  void onReceivedData() async {
    //_channel.sink.add('PING');
    //_channel.stream.listen((event) {print(event.toString());});
  }

  void _sendMessage() {
    if (_controllers.text.isNotEmpty) {
      //_channel.sink.add(_controllers.text);
    }
  }

  @override
  void dispose() {
    // _channel.sink.close();
    _controllers.dispose();
    super.dispose();
  }
}
