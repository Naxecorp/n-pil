import 'dart:async';
import 'package:flutter/material.dart';

class Window extends StatefulWidget {
  const Window({super.key, required this.title1,required this.title2, this.child});

  final String title1;
  final String title2;
  final Widget? child;

  @override
  State<Window> createState() => _windowState();
}

class _windowState extends State<Window> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F3),
        border: Border.all(color: Color(0xFFF0F0F3)),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 1,maxHeight: 30),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 35,minHeight: 15,maxWidth: 1000),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 5.0),
                      child: Text(
                        widget.title1,
                        style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.bold,fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 35,minHeight: 15,),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                      widget.title2,
                      style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.w100,fontSize: 15),
                        textAlign: TextAlign.start,
                  ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(2),
              color: Color(0xFFF0F0F3),
              child: widget.child,
            ),
          )
        ],
      ),
    );
    throw UnimplementedError();
  }
}



/*

Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F3),
        border: Border.all(color: Color(0xFFF0F0F3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 20,minHeight: 15,maxWidth: 100),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.green,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title1,
                          style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.bold,),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 20,minHeight: 15),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.blue,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        child: Text(
                        widget.title2,
                        style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.w100,),
                          textAlign: TextAlign.start,
                  ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 10,
            child: Container(
              padding: EdgeInsets.all(2),
              color: Color(0xFFF0F0F3),
              child: widget.child,
            ),
          )
        ],
      ),
    );
    throw UnimplementedError();
  }
 */