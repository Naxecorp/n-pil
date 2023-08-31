import 'dart:async';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart'hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API_Manager.dart';

class Touche extends StatefulWidget {
  const Touche(
      {super.key, this.child, required this.onAnyPressed,  this.isToggled, this.onChanged});

  final Widget? child;
  final VoidCallback onAnyPressed;
  final bool? isToggled;
  final ValueChanged<bool>? onChanged;

  @override
  State<Touche> createState() => _ToucheState(onAnyPressed, isToggled,onChanged);
}

class _ToucheState extends State<Touche> {

  _ToucheState(this._onAnyPressed, this.isToggled, this._onChanged);

  final VoidCallback _onAnyPressed;
  final bool? isToggled;
  final ValueChanged<bool>? _onChanged;




  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: (){
            return _onAnyPressed!();
        },
        child: Container(
            width: double.infinity,
            height: double.infinity,
            //padding: EdgeInsets.all(3),
            decoration: !isToggled!?BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
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
                      ]):
            BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                //border: Border.all(color: Color(0xFF20917F).withOpacity(0.7)),
                color: Color(0xFFF0F0F3),
                boxShadow: [
                  BoxShadow(
                      inset : true,
                      spreadRadius: 0,
                      blurRadius: 14,
                      color: Colors.white,
                      offset: Offset(0, -5)),
                  BoxShadow(
                      inset : true,
                      spreadRadius: 0,
                      blurRadius: 6,
                      color: Color(0xFF42536B).withOpacity(0.30),
                      offset: Offset(0, 2)),
                  BoxShadow(
                    inset : false,
                    spreadRadius: 0,
                    blurRadius: 16,
                    color: Colors.white.withOpacity(0.25),
                    offset: Offset(-4, -4),
                  ),
                  BoxShadow(
                    inset : false,
                    spreadRadius: 0,
                    blurRadius: 8,
                    color: Color(0xFF42536B).withOpacity(0.09),
                    offset: Offset(4, 4),
                  ),
                ]),
            child: widget.child));
    throw UnimplementedError();
  }
}
