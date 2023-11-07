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
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class SetPos extends StatefulWidget {
  @override
  State<SetPos> createState() => SetPosState();
}

class SetPosState extends State<SetPos> {
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
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Window(
                  title1: "Positions",
                  title2: " machine",
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text("X"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Y"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Z"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Center(
                                      child: NeumorphicButton(
                                        style: NeumorphicStyle(
                                          color: Color(0xFFF0F0F3),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Set",
                                          style: TextStyle(
                                            color: Color(0xFF707585),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Center(
                                    child: NeumorphicButton(
                                      style: NeumorphicStyle(
                                        color: Color(0xFFF0F0F3),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Go to",
                                        style: TextStyle(
                                          color: Color(0xFF707585),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Center(
                                    child: NeumorphicButton(
                                      style: NeumorphicStyle(
                                        color: Color(0xFFF0F0F3),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Set from actual",
                                        style: TextStyle(
                                          color: Color(0xFF707585),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Window(
                  title1: "Positions",
                  title2: " machine",
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("X"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Y"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Z"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Center(
                                      child: NeumorphicButton(
                                        style: NeumorphicStyle(
                                          color: Color(0xFFF0F0F3),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Set",
                                          style: TextStyle(
                                            color: Color(0xFF707585),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Center(
                                    child: NeumorphicButton(
                                      style: const NeumorphicStyle(
                                        color: Color(0xFFF0F0F3),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Go to",
                                        style: TextStyle(
                                          color: Color(0xFF707585),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Center(
                                    child: NeumorphicButton(
                                      style: NeumorphicStyle(
                                        color: Color(0xFFF0F0F3),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Set from actual",
                                        style: TextStyle(
                                          color: Color(0xFF707585),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Window(
                  title1: "Positions",
                  title2: " machine",
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("X"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Y"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("Z"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: "0",
                                      onChanged: (text) {
                                        0;
                                      },
                                      decoration: const InputDecoration(
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
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Center(
                                      child: NeumorphicButton(
                                        style: NeumorphicStyle(
                                          color: Color(0xFFF0F0F3),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Set",
                                          style: TextStyle(
                                            color: Color(0xFF707585),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Center(
                                    child: NeumorphicButton(
                                      style: const NeumorphicStyle(
                                        color: Color(0xFFF0F0F3),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Go to",
                                        style: TextStyle(
                                          color: Color(0xFF707585),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Center(
                                    child: NeumorphicButton(
                                      style: NeumorphicStyle(
                                        color: Color(0xFFF0F0F3),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Set from actual",
                                        style: TextStyle(
                                          color: Color(0xFF707585),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Window(
                  title1: "Positions",
                  title2: " machine",
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          //color: Colors.amber,
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("X"),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.05,
                                //color: Colors.greenAccent,
                                child: TextFormField(
                                  textAlign: TextAlign.end,
                                  initialValue: "0",
                                  onChanged: (text) {
                                    0;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      gapPadding: 5.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.orange,
                          height: 150,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.blue,
                          height: 150,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.red,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Window(
                  title1: "Positions",
                  title2: " machine",
                  child: Container(
                    height: 200,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.amber,
                            height: double.infinity,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.orange,
                            height: 150,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.blue,
                            height: 150,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            color: Colors.red,
                            height: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
