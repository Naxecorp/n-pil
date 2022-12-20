import 'dart:async';
import 'package:flutter/material.dart';
import 'touche.dart';
import 'my_jostick.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CoordoneesMachine extends StatefulWidget {
  const CoordoneesMachine({super.key, this.child});

  final Widget? child;

  @override
  State<CoordoneesMachine> createState() => _CoordoneesMachine();
}

class _CoordoneesMachine extends State<CoordoneesMachine> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFF0F0F3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(10),
                  //color: Colors.green,
                  child: Column(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 10),
                            //color: Colors.redAccent,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'X ',
                                        style: TextStyle(
                                            color: Color(0xFF969696),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 300),
                                      ),
                                    )),
                                Flexible(
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      '42.87',
                                      style: TextStyle(
                                          color: Color(0xFF575757),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 300),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      ' mm',
                                      style: TextStyle(
                                          color: Color(0xFF969696),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 300),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 10),
                            //color: Colors.redAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'Y ',
                                        style: TextStyle(
                                            color: Color(0xFF969696),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 300),
                                      ),
                                    )),
                                Flexible(
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      '42.87',
                                      style: TextStyle(
                                          color: Color(0xFF575757),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 300),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      ' mm',
                                      style: TextStyle(
                                          color: Color(0xFF969696),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 300),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 10),
                            //color: Colors.redAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'Z ',
                                        style: TextStyle(
                                            color: Color(0xFF969696),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 300),
                                      ),
                                    )),
                                Flexible(
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      '165.87',
                                      style: TextStyle(
                                          color: Color(0xFF575757),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 300),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Flexible(
                                  flex: 8,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      ' mm',
                                      style: TextStyle(
                                          color: Color(0xFF969696),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 300),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(10),
                  //color: Colors.pink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Touche(
                              onPressed: () {
                                print('ok');
                              },
                              child: Center(child: Text('G54',style: TextStyle(color: Color(0xFF969696),fontWeight: FontWeight.bold),)),
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Touche(
                              onPressed: () {
                                print('ok');
                              },
                              child: Center(child: Text('G55',style: TextStyle(color: Color(0xFF969696),fontWeight: FontWeight.bold),)),
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Touche(
                              onPressed: () {
                                print('ok');
                              },
                              child: Center(child: Text('G56',style: TextStyle(color: Color(0xFF969696),fontWeight: FontWeight.bold),)),
                            ),
                          )),
                    ],
                  ),
                ))
          ],
        ));
    throw UnimplementedError();
  }
}
