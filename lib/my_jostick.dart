// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
  Joystick(
      {this.backgroundColor,
      this.iconColor,
      this.opacity,
      this.isDraggable,
      this.size,
      required this.onUpPressed,
      required this.onDownPressed,
      required this.onLeftPressed,
      required this.onRightPressed,});

  @override
  _JoystickState createState() => _JoystickState(onUpPressed, onDownPressed,onLeftPressed,onRightPressed);
}

class _JoystickState extends State<Joystick> {

  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  _JoystickState(this.onUpPressed,this.onDownPressed,this.onLeftPressed,this.onRightPressed);

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
            child: GestureDetector(
              onTap: () => onUpPressed(),
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                //alignment: Alignment.topCenter,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(Icons.arrow_drop_up,
                        size: widget.size, color: widget.iconColor)),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.circle,
                    color: Color(0xFFF0F0F3),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                          color: Colors.black26,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 13,
                          color: Colors.white,
                          offset: Offset(-4, -4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 15,
                          color: Colors.white24,
                          offset: Offset(6, 6)),
                    ]),
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
                  child: GestureDetector(
                    onTap: ()=> onLeftPressed(),
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      //alignment: Alignment.bottomCenter,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(Icons.arrow_left,
                              size: widget.size, color: widget.iconColor)),
                      decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                          shape: BoxShape.circle,
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 7,
                                color: Colors.black26,
                                offset: Offset(4, 4)),
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 13,
                                color: Colors.white,
                                offset: Offset(-4, -4)),
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 15,
                                color: Colors.white24,
                                offset: Offset(6, 6)),
                          ]),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: ()=>onRightPressed(),
                    child: Container(
                      margin: EdgeInsets.only(left: 30),
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(Icons.arrow_right,
                              size: widget.size, color: widget.iconColor)),
                      decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                          shape: BoxShape.circle,
                          color: Color(0xFFF0F0F3),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 7,
                                color: Colors.black26,
                                offset: Offset(4, 4)),
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 13,
                                color: Colors.white,
                                offset: Offset(-4, -4)),
                            BoxShadow(
                                spreadRadius: 0,
                                blurRadius: 15,
                                color: Colors.white24,
                                offset: Offset(6, 6)),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: ()=>onDownPressed(),
              child: Container(
                margin: EdgeInsets.only(top: 30),
                //alignment: Alignment.bottomCenter,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(Icons.arrow_drop_down,
                        size: widget.size, color: widget.iconColor)),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.circle,
                    color: Color(0xFFF0F0F3),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                          color: Colors.black26,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 13,
                          color: Colors.white,
                          offset: Offset(-4, -4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 15,
                          color: Colors.white24,
                          offset: Offset(6, 6)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  Joystick2(
      {this.backgroundColor,
      this.iconColor,
      this.opacity,
      this.isDraggable,
      this.size,
      required this.onUpPressed,
        required this.onDownPressed,
});

  @override
  _JoystickState2 createState() => _JoystickState2(onDownPressed,onUpPressed);
}

class _JoystickState2 extends State<Joystick2> {

  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;


  _JoystickState2(this.onUpPressed,this.onDownPressed);

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
            child: GestureDetector(
              onTap: onUpPressed,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                //alignment: Alignment.topCenter,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(Icons.arrow_upward,
                        size: widget.size, color: widget.iconColor)),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.circle,
                    color: Color(0xFFF0F0F3),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                          color: Colors.black26,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 13,
                          color: Colors.white,
                          offset: Offset(-4, -4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 15,
                          color: Colors.white24,
                          offset: Offset(6, 6)),
                    ]),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: onDownPressed,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                //alignment: Alignment.bottomCenter,
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(
                      Icons.arrow_downward,
                      size: widget.size,
                      color: widget.iconColor,
                    )),
                decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.circle,
                    color: Color(0xFFF0F0F3),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 7,
                          color: Colors.black26,
                          offset: Offset(4, 4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 13,
                          color: Colors.white,
                          offset: Offset(-4, -4)),
                      BoxShadow(
                          spreadRadius: 0,
                          blurRadius: 15,
                          color: Colors.white24,
                          offset: Offset(6, 6)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
