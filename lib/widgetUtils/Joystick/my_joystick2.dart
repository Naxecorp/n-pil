import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Joystick2 extends StatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final double? opacity;
  final double? size;
  final bool? isDraggable;

  // callbacks
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;

  //
  Joystick2({
    this.backgroundColor,
    this.iconColor,
    this.opacity,
    this.isDraggable,
    this.size,
    required this.onUpPressed,
    required this.onDownPressed,
  });

  @override
  _JoystickState2 createState() => _JoystickState2(onUpPressed, onDownPressed);
}

class _JoystickState2 extends State<Joystick2> {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;

  _JoystickState2(this.onUpPressed, this.onDownPressed);

  double _x = 0;
  double _y = 0;
  double _value = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: NeumorphicButton(
              margin: EdgeInsets.all(10),
              onPressed: onUpPressed,
              style: NeumorphicStyle(
                color: Color(0xFFF0F0F3),
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              //padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.arrow_upward,
                  size: (widget.size)! / 1.5,
                  color: widget.iconColor,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: NeumorphicButton(
              margin: EdgeInsets.all(10),
              onPressed: onDownPressed,
              style: NeumorphicStyle(
                color: Color(0xFFF0F0F3),
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              //padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.arrow_downward,
                  size: (widget.size)! / 1.5,
                  color: widget.iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
