import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util';

TextEditingController _controller = TextEditingController();

class ParametreScreen extends StatefulWidget {
  @override
  State<ParametreScreen> createState() => ParametreScreenState();
}

class ParametreScreenState extends State<ParametreScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //color: Colors.redAccent.withOpacity(0.5),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(
              'Paramêtres bientôt disponibles'
            ),
          ),
        ),
      ),
    );
  }
}
