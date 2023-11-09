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
import '../OpeListView.dart';
import '../familleviewer.dart';
import '../menus/bottomMenu/bottomMenu.dart';
import '../menus/family_menu.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/ArretUrgence.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

String opeToShow = 'none';
String FamillyToShow = 'classique';
TextEditingController ManualGcodeComand = TextEditingController();

class ConversationelScreen extends StatefulWidget {
  @override
  State<ConversationelScreen> createState() => ConversationelScreenState();
}

class ConversationelScreenState extends State<ConversationelScreen> {
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
                child: Image(
                  image: AssetImage("assets/iconnaxe.png"),
                ),
              ),
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
                ),
              ),
            ),
          ],
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            global.viewListOfOperation
                ? Flexible(
                    flex: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              //color: Colors.green,
                              child: FamilyMenu(
                                onAnyTap: () {
                                  setState(() {
                                    opeToShow = 'none';
                                  });
                                  print('tap');
                                },
                              ),
                            )),
                        Expanded(
                            flex: 10,
                            child: Container(
                              //color: Colors.yellow,
                              child: Column(
                                children: [
                                  Expanded(flex: 8, child: FamilleWiewer()),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                : Flexible(
                    flex: 20,
                    child: OpeListView(
                      onAnyTap: () {
                        setState(() {});
                      },
                    )),
            Flexible(
              flex: 5,
              child: Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: BottomMenu(
                              onAnyTap: () {
                                setState(() {
                                  print(bottomMenuToShow);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      child: ArretUrgence(
                        notifyParent: () {
                          setState(() {});
                        },
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
