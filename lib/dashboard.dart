import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util';

import 'package:js/js.dart';
import 'window.dart';
import 'ArretUrgence.dart';
import 'my_jostick.dart';
import 'fonctions_window.dart';
import 'position_window.dart';
import 'side_menu.dart';
import 'deplacement_machine.dart';
import 'origine_machine.dart';
import 'coordonees_machine.dart';
import 'end_courses.dart';
import 'spindle_speed.dart';



class Dashboard extends StatefulWidget {

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 4,
            child: Row(
              children: [
                Flexible(flex: 2, child: Column(
                  children: [
                    Flexible(flex:1, child: Container(child: Window(title1: "Coordonées ",title2: "machine",child:CoordoneesMachine() ,),)),
                    Flexible(flex:1, child: Container(child: Window(title1: "Origine ",title2: "machine",child: OrigineMachine(),),)),
                  ],
                )),
                Flexible(flex: 1, child: Column(
                  children: [
                    Flexible(flex:1, child: Container(child: Window(title1: "Capteurs ",title2: "Fdc",child: EndCourses(),),)),
                    Flexible(flex:1, child: Container(child: Window(title1: "Vitesse ",title2: "broche",child: SpindleSpeed()),)),
                  ],
                )),
                Flexible(flex: 3, child: Window(title1: "Déplacement ",title2: "machine",child:DeplacementMachine() ,)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(flex: 9, child: Container(child: Window(title1: "",title2: "",),)),
                Flexible(flex: 2, child: Container(child: ArretUrgence(),),),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
