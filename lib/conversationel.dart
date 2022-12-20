import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util';

import 'package:js/js.dart';
import 'window.dart';
import 'ArretUrgence.dart';

import 'family_menu.dart';
import 'ope_menu.dart';
import 'opeviewer.dart';
import 'operation.dart';
import 'familleviewer.dart';
import 'bottomMenu.dart';
import 'OpeListView.dart';

bool viewListOfOperation = true;
String opeToShow = 'none';
String FamillyToShow = 'classique';
String bottomMenuToShow = 'Menu1';
int OpeSelected = 0;


BottomMenu myBottomMenu = BottomMenu();

class Conversationel extends StatefulWidget {
  @override
  State<Conversationel> createState() => ConversationelState();
}

class ConversationelState extends State<Conversationel> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          viewListOfOperation
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
                          padding: const EdgeInsets.all(8.0),
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
                Flexible(flex: 2, child: ArretUrgence())
              ],
            ),
          )
        ],
      ),
    );
  }
}
