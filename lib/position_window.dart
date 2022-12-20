import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PositionWindow extends StatefulWidget {
  const PositionWindow({super.key, this.title, this.child});

  final String? title;
  final Widget? child;

  @override
  State<PositionWindow> createState() => _PositionWindow();
}

class _PositionWindow extends State<PositionWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(padding: EdgeInsets.all(5),child: AutoSizeText('X :',style: TextStyle(color: Colors.black26,fontSize: 40,fontWeight: FontWeight.bold), maxLines: 1,
                presetFontSizes: [30, 15, 7, 5,1],)),
              Container(child: AutoSizeText('120.65',style: TextStyle(color: Colors.black,fontSize: 50), maxLines: 1,
                presetFontSizes:  [30, 15, 7, 5,1],)),
              Container(padding: EdgeInsets.all(5),child: AutoSizeText('mm',style: TextStyle(color: Colors.black26), maxLines: 1,
                presetFontSizes: [30, 15, 7, 5,1],)),
            ],
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
