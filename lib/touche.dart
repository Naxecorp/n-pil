import 'dart:async';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart'hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class Touche extends StatefulWidget {
  const Touche(
      {super.key, this.child, required this.onPressed, this.isToggled = false});

  final Widget? child;
  final VoidCallback onPressed;
  final bool isToggled;

  @override
  State<Touche> createState() => _ToucheState(onPressed, isToggled);
}

class _ToucheState extends State<Touche> {
  _ToucheState(this.onPressed, this.isToggled);

  final VoidCallback? onPressed;
  final bool isToggled;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: onPressed,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(7),
            decoration: !isToggled ?BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xFFF0F0F3),
                    boxShadow: [
                        BoxShadow(
                            inset : false,
                            spreadRadius: 0,
                            blurRadius: 7,
                            color: Colors.black26,
                            offset: Offset(4, 4)),
                        BoxShadow(
                            inset : false,
                            spreadRadius: 0,
                            blurRadius: 13,
                            color: Colors.white,
                            offset: Offset(-4, -4)),
                        BoxShadow(
                          inset : false,
                          spreadRadius: 0,
                          blurRadius: 15,
                          color: Colors.white24,
                          offset: Offset(6, 6),
                        ),
                      ]):BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Color(0xFF20917F).withOpacity(0.7)),
                color: Color(0xFFF0F0F3),
                boxShadow: [
                  BoxShadow(
                      inset : true,
                      spreadRadius: 0,
                      blurRadius: 14,
                      color: Colors.white,
                      offset: Offset(-4, 0)),
                  BoxShadow(
                      inset : true,
                      spreadRadius: 0,
                      blurRadius: 6,
                      color: Color(0xFF42536B).withOpacity(0.22),
                      offset: Offset(0, 2)),
                  BoxShadow(
                    inset : false,
                    spreadRadius: 0,
                    blurRadius: 16,
                    color: Colors.white.withOpacity(0.25),
                    offset: Offset(-4, -4),
                  ),
                ]),
            child: widget.child));
    throw UnimplementedError();
  }
}
