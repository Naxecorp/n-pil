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
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class GlobalAppBar extends StatefulWidget {
  @override
  State<GlobalAppBar> createState() => GlobalAppBarState();
}

class GlobalAppBarState extends State<GlobalAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
