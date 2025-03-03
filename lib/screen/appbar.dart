import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:nweb/service/API/API_Manager.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: ManualGcodeComand,
                          decoration: InputDecoration(
                            hintText: "Gcode",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gapPadding: 5.0,
                            ),
                          ),
                          onSubmitted: (Commande) {
                            setState(() {
                              global.commandHistory.add(Commande);
                              ManualGcodeComand.clear();
                              API_Manager().sendGcodeCommand(Commande).then(
                                  (value) => API_Manager().sendrr_reply());
                            });
                          },
                        ),
                        PopupMenuButton<String>(
                          tooltip: "Historique",
                          icon: Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            setState(() {
                              ManualGcodeComand.text = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return global.commandHistory
                                .map<PopupMenuItem<String>>((String value) {
                              return PopupMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList();
                          },
                        ),
                      ],
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
    );
  }
}
