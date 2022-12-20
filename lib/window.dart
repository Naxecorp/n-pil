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
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F3),
        border: Border.all(color: Color(0xFFF0F0F3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.title1,
                  style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.bold,fontSize: 18),
                ),
                Text(
                  widget.title2,
                  style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.w100,fontSize: 18),
                ),
              ],
            ),
          ),
          Expanded(
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
