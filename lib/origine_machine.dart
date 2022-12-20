import 'dart:async';
import 'package:flutter/material.dart';
import 'touche.dart';
import 'my_jostick.dart';

class OrigineMachine extends StatefulWidget {
  const OrigineMachine({super.key, this.child});

  final Widget? child;

  @override
  State<OrigineMachine> createState() => _OrigineMachine();
}

class _OrigineMachine extends State<OrigineMachine> {
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
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                            Icon(Icons.home_filled,color: Color(0xFF21B9A1),),
                            FittedBox(fit: BoxFit.contain, child: Text('min tous'))
                          ]),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0x8021B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('min X'))
                              ]),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0x8021B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('min Y'))
                              ]),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0x8021B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('min Z'))
                              ]),
                        ),
                      )),
                ],
              ),
            ),
          ),
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
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0xFF21B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('max tous'))
                              ]),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0x8021B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('max X'))
                              ]),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0x8021B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('max Y'))
                              ]),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Touche(
                        onPressed: () {
                          print('selected 0.01 mm');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.home_filled,color: Color(0x8021B9A1),),
                                FittedBox(fit: BoxFit.contain, child: Text('max Z'))
                              ]),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
