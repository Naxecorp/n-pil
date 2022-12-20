import 'dart:async';
import 'package:flutter/material.dart';
import 'touche.dart';
import 'my_jostick.dart';

class DeplacementMachine extends StatefulWidget {
  const DeplacementMachine({super.key, this.child});

  final Widget? child;

  @override
  State<DeplacementMachine> createState() => _DeplacementMachine();
}

class _DeplacementMachine extends State<DeplacementMachine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0F0F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: (){
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text('0.01'),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: (){
                          print('selected 0.1 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text('0.1'),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: (){
                          print('selected 1mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text('1'),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      //margin: EdgeInsets.symmetric(vertical: 30),
                      //height: 300,
                      //width: 300,
                      //color: Colors.green,
                      child: Joystick(
                        size: 70,
                        iconColor: Color(0xFF707585),
                        onUpPressed: () {
                          print('UP');
                        },
                        onDownPressed: () {
                          print('Down');
                        },
                        onLeftPressed: () {
                          print('left');
                        },
                        onRightPressed: () {
                          print('right');
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      //height: 300,
                      //width: 300,
                      //color: Colors.yellow,
                      child: Joystick2(
                        size: 70,
                        iconColor: Color(0xFF707585),
                        onDownPressed: () {
                          print('Z UP');
                        },
                        onUpPressed: () {
                          print('Z Down');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
    throw UnimplementedError();
  }
}
