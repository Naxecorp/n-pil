import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FloatingKeyboard {

  final BuildContext? context;

  bool isOut = false;

  OverlayEntry? entry;
  Offset offset = Offset(20, 40);

  FloatingKeyboard({this.context});


  void showoverlay() async{
    entry = OverlayEntry(builder: (context) =>
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: ((details) {
              offset += details.delta;
              entry!.markNeedsBuild();
            }),
            child: Container(
              // Keyboard is transparent
              color: Colors.white,
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(child: TextButton(onPressed: (){print("toto"); entry!.remove();},child: Text("Fermer",style: TextStyle(fontSize: 20),),)),
                  VirtualKeyboard(
                    // [0-9] + .
                      type: VirtualKeyboardType.Numeric,
                      // Callback for key press event
                      onKeyPress: (key) => print(key.text)),
                ],
              ),
            ),
          ),
        ));
    final overlay = Overlay.of(context!)!;
    overlay.insert(entry!);
  }

}