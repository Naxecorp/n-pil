import 'dart:async';
import 'package:flutter/material.dart';

class FonctionWindow extends StatefulWidget {
  const FonctionWindow({super.key, this.title, this.child});

  final String? title;
  final Widget? child;

  @override
  State<FonctionWindow> createState() => _FonctionWindow();
}

class _FonctionWindow extends State<FonctionWindow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                            BoxShadow(
                                spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                          ]
                      ),
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Lumiere ON'),
                        ),
                      ),
                    )
                ),
                Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFFF0F0F3),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0, blurRadius: 7, color: Colors.black26,offset: Offset(4,4)),
                          BoxShadow(
                              spreadRadius: 0, blurRadius: 13, color: Colors.white,offset: Offset(-4,-4)),
                          BoxShadow(
                              spreadRadius: 0, blurRadius: 15, color: Colors.white24,offset: Offset(6,6)),

                        ]
                      ),
                     child: InkWell(
                       splashColor: Colors.blue,
                       onTap: () {
                         debugPrint('Card tapped.');
                       },
                       child: Padding(
                         padding: const EdgeInsets.all(10),
                         child: Text('Lumiere ON'),
                       ),
                     ),
                    )
                ),
              ],
            ),
          ),

         
        ],
      ),
    );
    throw UnimplementedError();
  }
}
