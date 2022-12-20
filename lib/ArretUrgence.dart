import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ArretUrgence extends StatefulWidget {
  const ArretUrgence({super.key, this.title});

  final String? title;

  @override
  State<ArretUrgence> createState() => _ArretUrgenceState();
}

class _ArretUrgenceState extends State<ArretUrgence> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('Arret Urgence');
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
                'Arret urgence',
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
