import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Touche extends StatefulWidget {
  const Touche({super.key, this.child, required this.onPressed});


  final Widget? child;
  final VoidCallback onPressed;

  @override
  State<Touche> createState() => _ToucheState(onPressed);
}

class _ToucheState extends State<Touche> {

  final VoidCallback onPressed;

  _ToucheState(this.onPressed);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(7),
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
        child: widget.child
      ),
    );
    throw UnimplementedError();
  }
}
