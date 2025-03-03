import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';

class Touche extends StatefulWidget {
  const Touche({
    super.key,
    this.child,
    required this.onAnyPressed,
    this.isToggled,
    this.onChanged,
  });

  final Widget? child;
  final VoidCallback onAnyPressed;
  final bool? isToggled;
  final ValueChanged<bool>? onChanged;

  @override
  State<Touche> createState() =>
      _ToucheState(onAnyPressed, isToggled, onChanged);
}

class _ToucheState extends State<Touche> {
  _ToucheState(this._onAnyPressed, this.isToggled, this._onChanged);

  final VoidCallback _onAnyPressed;
  final bool? isToggled;
  final ValueChanged<bool>? _onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        _onAnyPressed();
      },
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          depth: isToggled! ? -6 : 6,
          intensity: 0.8,
          surfaceIntensity: 0.5,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(3)),
          color: Color(0xFFF0F0F3),
          shadowLightColor: Colors.white,
          shadowDarkColor: Colors.black26,
        ),
        child: widget.child,
      ),
    );
  }
}
