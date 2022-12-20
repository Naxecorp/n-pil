// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:math' as math;

class SpindleSpeed extends StatefulWidget {
  const SpindleSpeed({super.key});

  @override
  SpindleSpeedState createState() => SpindleSpeedState();
}

double rpmvalue = 6000;

class SpindleSpeedState extends State {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
    );
  }
}
