// ignore_for_file: prefer_const_constructors
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Joystick extends StatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final double? opacity;
  final double? size;
  final bool? isDraggable;

  // callbacks
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onRightPressed;
  final VoidCallback onLeftPressed;

  //
  Joystick({
    this.backgroundColor,
    this.iconColor,
    this.opacity,
    this.isDraggable,
    this.size,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  @override
  _JoystickState createState() =>
      _JoystickState(onUpPressed, onDownPressed, onLeftPressed, onRightPressed);
}

class _JoystickState extends State<Joystick> {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  _JoystickState(this.onUpPressed, this.onDownPressed, this.onLeftPressed,
      this.onRightPressed);

  double _x = 0;
  double _y = 0;
  double _value = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_drop_up_rounded,
                      size: (widget.size)! / 2.5,
                      color: widget.iconColor,
                    ),
                    Text("Y+",style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: NeumorphicButton(
                    margin: EdgeInsets.all(10),
                    onPressed: onLeftPressed,
                    style: NeumorphicStyle(
                      color: Color(0xFFF0F0F3),
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    //padding: const EdgeInsets.all(12.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_left_rounded,
                            size: (widget.size)! / 2.5,
                            color: widget.iconColor,
                          ),
                          Text("X-",style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: NeumorphicButton(
                    margin: EdgeInsets.all(10),
                    onPressed: onRightPressed,
                    style: NeumorphicStyle(
                      color: Color(0xFFF0F0F3),
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.circle(),
                    ),
                    //padding: const EdgeInsets.all(12.0),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_right_rounded,
                            size: (widget.size)! / 2.5,
                            color: widget.iconColor,
                          ),
                          Text("X+",style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: (widget.size)! / 2.5,
                      color: widget.iconColor,
                    ),
                    Text("Y-",style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
