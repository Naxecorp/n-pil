// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math' as math;

class SpindleSpeed extends StatefulWidget {
  const SpindleSpeed({super.key});

  @override
  SpindleSpeedState createState() => SpindleSpeedState();
}

double rpmvalue = 12000;
bool _spindleOn = false;

class SpindleSpeedState extends State {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 3,
          child: Center(
            child: Container(
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                  startAngle: 180,
                  endAngle: 360,
                  minimum: 0,
                  maximum: 12000,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: rpmvalue,
                      gradient: SweepGradient(
                          startAngle: 0,
                          endAngle: rpmvalue * math.pi * 2,
                          colors: [
                            Color.fromARGB(255, 104, 151, 161),
                            Color.fromARGB(255, 32, 145, 127),
                          ]),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 104, 151, 161),
                          Color.fromARGB(255, 32, 145, 127),
                        ]),
                        value: rpmvalue)
                  ],
                )
              ]),
            ),
          ),
        ),
        Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      //color: Colors.blue,
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child:
                              Center(child: Text('$rpmvalue  Trs',style: TextStyle(color: Color(0xFF707585)),))),
                    )),
                Flexible(
                    flex: 1,
                    child: Container(
                      //color: Colors.orange,
                      child: CupertinoSwitch(
                        value: _spindleOn,
                        onChanged: (bool value) {
                          setState(() {
                            _spindleOn = value;
                          });
                        },
                      ),
                    )),
              ],
            ))
      ],
    );
  }
}
