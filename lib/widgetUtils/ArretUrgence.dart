import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nweb/service/API_Manager.dart';

class ArretUrgence extends StatefulWidget {
  const ArretUrgence({super.key, this.title, required this.notifyParent});

  final String? title;
  final Function() notifyParent;

  @override
  State<ArretUrgence> createState() => _ArretUrgenceState(notifyParent);
}

class _ArretUrgenceState extends State<ArretUrgence> {
  final Function() notifyParent;

  _ArretUrgenceState(this.notifyParent);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        await API_Manager().sendGcodeCommand("M112");
        Navigator.pushNamed(context, '/dashboard');
        return notifyParent();
      },
      child: Center(
        child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.yellowAccent, width: 3),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 5, blurRadius: 1, color: Colors.white),
                ],
                color: Colors.redAccent),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellowAccent, width: 3),
                  color: Colors.redAccent),
              child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                'Arret immédiat',
                style: TextStyle(color: Colors.white),
                maxLines: 2,
              ),
                  )),
            )),
      ),
    );
    throw UnimplementedError();
  }
}
