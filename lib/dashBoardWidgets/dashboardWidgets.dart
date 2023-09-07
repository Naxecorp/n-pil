import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../globals_var.dart' as global;
import 'package:nweb/service/API_Manager.dart';
import '../globals_var.dart';
import '../widgetUtils/touche.dart';
import '../widgetUtils/my_jostick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:fluttertoast/fluttertoast.dart';


class EndCourses extends StatefulWidget {
  const EndCourses({super.key});

  @override
  EndCoursesState createState() => EndCoursesState();
}

class EndCoursesState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //color: Colors.orange,
        child: Center(
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: global.machineObjectModel.result?.sensors
                                    ?.endstops?[0].triggered
                                    .toString() ==
                                'true'
                            ? Colors.orange
                            : Colors.green,
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              color: global.machineObjectModel.result?.sensors
                                          ?.endstops?[1].triggered
                                          .toString() ==
                                      'true'
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              color: global.machineObjectModel.result?.sensors
                                          ?.endstops?[2].triggered
                                          .toString() ==
                                      'true'
                                  ? Colors.orange
                                  : Colors.green,
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: global.machineObjectModel.result?.sensors
                                    ?.endstops?[2].triggered
                                    .toString() ==
                                'true'
                            ? Colors.orange
                            : Colors.green,
                      )
                    ],
                  )),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        color: global.machineObjectModel.result?.sensors
                                    ?.endstops?[2].triggered
                                    .toString() ==
                                'true'
                            ? Colors.orange
                            : Colors.green,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: global.machineObjectModel.result?.sensors
                                    ?.endstops?[2].triggered
                                    .toString() ==
                                'true'
                            ? Colors.orange
                            : Colors.green,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class InfoSystem extends StatefulWidget {
  const InfoSystem({super.key});

  @override
  InfoSystemState createState() => InfoSystemState();
}

class InfoSystemState extends State<InfoSystem> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Status",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Text(
                      global.machineObjectModel.result?.state?.status.toString() ??
                          "???",
                      style: const TextStyle(color: Color(0xFF707585))),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "MCU Température",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          global.machineObjectModel.result?.boards
                                  ?.elementAt(0)
                                  .mcuTemp
                                  ?.current
                                  ?.toStringAsFixed(1) ??
                              "...",
                          style: const TextStyle(color: Color(0xFF707585))),
                      const Text("°C", style: TextStyle(color: Color(0xFF707585)))
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "V12",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        global.machineObjectModel.result?.boards
                                ?.elementAt(0).v12
                                ?.current
                                ?.toStringAsFixed(1) ??
                            "...",
                        style: const TextStyle(color: Color(0xFF707585)),
                      ),
                      const Text(" V", style: TextStyle(color: Color(0xFF707585))),
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Vin",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          global.machineObjectModel.result?.boards?[0].vIn
                                  ?.current
                                  ?.toStringAsFixed(1) ??
                              "...",
                          style: const TextStyle(color: Color(0xFF707585))),
                      const Text(" V", style: TextStyle(color: Color(0xFF707585))),
                    ],
                  ),
                ],
              ),
            )),
      ],
    ));
  }
}

double stepValue = 0.1;



class DeplacementMachine extends StatefulWidget {
  const DeplacementMachine({super.key, this.child});

  final Widget? child;

  @override
  State<DeplacementMachine> createState() => _DeplacementMachine();
}

class _DeplacementMachine extends State<DeplacementMachine> {

  bool MovesWithoutEndstop = false;


  @override
  Widget build(BuildContext context) {

    return Container(
      color: const Color(0xFFF0F0F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 1,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: NeumorphicButton(
                                margin: const EdgeInsets.all(15),
                                style: const NeumorphicStyle(
                                  color: Color(0xFFF0F0F3),
                                ),
                                onPressed: ()async {
                                  await API_Manager()
                                      .sendGcodeCommand("G28 X")
                                      .then((value) => print(value));

                                },
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Icon(
                                        Icons.home_filled,
                                        color: Color(0xFF707585),
                                      ),
                                      FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            'Axe X',
                                            style: TextStyle(
                                                color: Color(0xFF707585)),
                                          ))
                                    ]),
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: NeumorphicButton(
                                margin: const EdgeInsets.all(15),
                                style: const NeumorphicStyle(
                                  color: Color(0xFFF0F0F3),
                                ),
                                onPressed: () {
                                  API_Manager()
                                      .sendGcodeCommand("G28 Y")
                                      .then((value) => print(value));
                                },
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        Icons.home_filled,
                                        color: Color(0xFF707585),
                                      ),
                                      const FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            'Axe Y',
                                            style: TextStyle(
                                                color: Color(0xFF707585)),
                                          ))
                                    ]),
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: NeumorphicButton(
                                margin: const EdgeInsets.all(15),
                                style: const NeumorphicStyle(
                                  color: Color(0xFFF0F0F3),
                                ),
                                onPressed: () {
                                  API_Manager()
                                      .sendGcodeCommand("G28 Z")
                                      .then((value) => print(value));
                                },
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        Icons.home_filled,
                                        color: Color(0xFF707585),
                                      ),
                                      const FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            'Axe Z',
                                            style: TextStyle(
                                                color: Color(0xFF707585)),
                                          ))
                                    ]),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 0.01,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text(
                              "0.01",
                              style: TextStyle(color: Color(0xFF707585)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 0.1,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text(
                              "0.1",
                              style: TextStyle(color: Color(0xFF707585)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 1.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text("1",
                                style: TextStyle(color: Color(0xFF707585))),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 10.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text("10",
                                style: TextStyle(color: Color(0xFF707585))),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            style: const NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 50.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                            child: const Text("50",
                                style: TextStyle(color: Color(0xFF707585))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(

              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      //color: Colors.green,
                      child: Joystick(
                        size: 70,
                        iconColor: const Color(0xFF707585),
                        onUpPressed: ()async {
                          if (MovesWithoutEndstop) await API_Manager().sendGcodeCommand("M120\nG91\nG1 Y$stepValue H2 F${global.SpeedValue}\nM121\n").then((value) => print(value));
                            else await API_Manager().sendGcodeCommand("M120\nG91\nG1 Y$stepValue F${global.SpeedValue}\nM121\n");
                          API_Manager().sendrr_reply();
                        },
                        onDownPressed: () async{
                          if (MovesWithoutEndstop)await API_Manager().sendGcodeCommand("M120\nG91\nG1 H2 Y-$stepValue F${global.SpeedValue}\nM121\n");
                            else await API_Manager().sendGcodeCommand("M120\nG91\nG1 Y-$stepValue F${global.SpeedValue}\nM121\n");
                          API_Manager().sendrr_reply();
                        },
                        onLeftPressed: () async{
                          if (MovesWithoutEndstop)await API_Manager().sendGcodeCommand("M120\nG91\nG1 H2 X-$stepValue F${global.SpeedValue}\nM121\n");
                            else await API_Manager().sendGcodeCommand("M120\nG91\nG1 X-$stepValue F${global.SpeedValue}\nM121\n");
                          API_Manager().sendrr_reply();
                        },
                        onRightPressed: () async{
                          if (MovesWithoutEndstop) await API_Manager().sendGcodeCommand("M120\nG91\nG1 X$stepValue H2 F${global.SpeedValue}\nM121\n");
                            else await API_Manager().sendGcodeCommand("M120\nG91\nG1 X$stepValue F${global.SpeedValue}\nM121\n");
                          API_Manager().sendrr_reply();
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      //height: 300,
                      //width: 300,
                      //color: Colors.yellow,
                      child: Joystick2(
                        size: 70,
                        iconColor: const Color(0xFF707585),
                        onUpPressed: () async {
                          if (MovesWithoutEndstop) await API_Manager().sendGcodeCommand("M120\nG91\nG1 H2 Z$stepValue F${global.SpeedValue}\nM121\n");
                            else await API_Manager().sendGcodeCommand("M120\nG91\nG1 Z$stepValue F${global.SpeedValue}\nM121\n");
                          API_Manager().sendrr_reply();
                        },
                        onDownPressed: ()async {
                          var Zstepdown;
                          if (stepValue > 10)
                            Zstepdown = 10;
                          else
                            Zstepdown = stepValue;
                          if (MovesWithoutEndstop)await API_Manager().sendGcodeCommand("M120\nG91\nG1 H2 Z-$Zstepdown F${global.SpeedValue}\nM121\n");
                            else await API_Manager().sendGcodeCommand("M120\nG91\nG1 Z-$Zstepdown F${global.SpeedValue}\nM121\n");
                          API_Manager().sendrr_reply();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    global.AdminLogged == true ? Container(child: NeumorphicButton(
                      margin: const EdgeInsets.all(15),
                      style: NeumorphicStyle(
                        depth: MovesWithoutEndstop == true ?-5:5,//SpindleFanIsOn?-10:10,
                        color: const Color(0xFFF0F0F3),
                      ),
                      onPressed: () {
                        setState(() {
                          MovesWithoutEndstop = !MovesWithoutEndstop;
                        });
                      },
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.not_interested,
                              color: Color(0xFF707585),
                            ),
                            const FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  'Fin de Courses',
                                  style: TextStyle(
                                      color: Color(0xFF707585)),
                                ))
                          ]),
                    ),):Container(),
                    global.AdminLogged == true ? Container(child: NeumorphicButton(
                      margin: const EdgeInsets.all(15),
                      style: NeumorphicStyle(
                        color: const Color(0xFFF0F0F3),
                      ),
                      onPressed: () {
                        setState(() {
                          API_Manager().sendGcodeCommand("M120\nG91\nG1 Y500 F${global.SpeedValue}\nM121\n");
                        });
                      },
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.arrow_drop_up,
                              color: Color(0xFF707585),
                            ),
                            const FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  'Y max',
                                  style: TextStyle(
                                      color: Color(0xFF707585)),
                                ))
                          ]),
                    ),):Container(),
                    global.AdminLogged == true ? Container(child: NeumorphicButton(
                      margin: const EdgeInsets.all(15),
                      style: NeumorphicStyle(
                        color: const Color(0xFFF0F0F3),
                      ),
                      onPressed: () {
                        setState(() {
                          API_Manager().sendGcodeCommand("M120\nG91\nG1 Y-500 F${global.SpeedValue}\nM121\n");
                        });
                      },
                      child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF707585),
                            ),
                            const FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  'Y Zero',
                                  style: TextStyle(
                                      color: Color(0xFF707585)),
                                ))
                          ]),
                    ),):Container(),
                    global.AdminLogged == true ? Container(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Accel: ${global.Accel}"),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(5),
                          style: NeumorphicStyle(
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            setState(() {
                              global.Accel = global.Accel+10;
                              API_Manager().sendGcodeCommand("M201 Y${global.Accel} \n");
                            });
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Acceleration',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(5),
                          style: NeumorphicStyle(
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            setState(() {
                              if(global.Accel>10)global.Accel = global.Accel-10;
                              API_Manager().sendGcodeCommand("M201 Y${global.Accel} \n");
                            });
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.remove,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Acceleration',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ],
                    ),):Container(),
                    global.AdminLogged == true ? Container(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Speed: ${global.SpeedValue}"),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(5),
                          style: NeumorphicStyle(
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            setState(() {
                              global.SpeedValue = global.SpeedValue+100;
                              API_Manager().sendGcodeCommand("M203 Y${global.SpeedValue} \n");
                            });
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Vit. max',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(5),
                          style: NeumorphicStyle(
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            setState(() {
                              if(global.SpeedValue>100)global.SpeedValue = global.SpeedValue-100;
                              API_Manager().sendGcodeCommand("M203 Y${global.SpeedValue} \n");
                            });
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.remove,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Vit. max',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ],
                    ),):Container(),
                    global.AdminLogged == true ? Container(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Jerk: " + global.Jerk.toStringAsFixed(1)),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(5),
                          style: NeumorphicStyle(
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            setState(() {

                              if(global.Jerk>=50)global.Jerk = global.Jerk+50;
                              else global.Jerk = global.Jerk+1;

                              API_Manager().sendGcodeCommand("M566 X"+global.Jerk.toStringAsFixed(1)+" Y"+global.Jerk.toStringAsFixed(1)+"\n");
                            });
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Vit. max',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                        NeumorphicButton(
                          margin: const EdgeInsets.all(5),
                          style: NeumorphicStyle(
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            setState(() {
                              if(global.Jerk<=50){
                                if(global.Jerk>1)global.Jerk = global.Jerk-1;
                              }
                              else global.Jerk = global.Jerk-50;

                              API_Manager().sendGcodeCommand("M566 X"+global.Jerk.toStringAsFixed(1)+" Y"+global.Jerk.toStringAsFixed(1)+"\n");
                            });
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.remove,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Vit. max',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ],
                    ),):Container(),
                    const Spacer(),
                    Container(width: 200,child: ArretUrgence(notifyParent: (){},),),
                  ],
                ),
              ))
        ],
      ),
    );
    throw UnimplementedError();
  }
}




class ModeMachine extends StatefulWidget {
  const ModeMachine({super.key, this.child});

  final Widget? child;

  @override
  State<ModeMachine> createState() => ModeMachineState();
}

class ModeMachineState extends State<ModeMachine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F0F3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicRadio(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              style: const NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.fff,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand("M451");
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
              },
              child: const Text(
                "FFF",
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
            NeumorphicRadio(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              style: const NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.laser,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand('M452 C"out5-" F100');
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
              },
              child: const Text(
                "Laser",
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
            NeumorphicRadio(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              style: const NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.cnc,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand("M453");
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
              },
              child: const Text(
                "CNC",
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}




class CoordoneesMachine extends StatefulWidget {
  const CoordoneesMachine({super.key, this.child, this.notifyParent});

  final Widget? child;
  final Function()? notifyParent;

  @override
  State<CoordoneesMachine> createState() => _CoordoneesMachine(notifyParent);
}

class _CoordoneesMachine extends State<CoordoneesMachine> {
  final VoidCallback? _notifyParent;

  _CoordoneesMachine(this._notifyParent);

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Container(
            //margin: EdgeInsets.all(10),
            //color: Colors.green,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(1),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          flex: 2,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "X",
                                style: TextStyle(
                                    color: global.objectModelMove.result?.axes
                                                ?.elementAt(0)
                                                .homed ==
                                            false
                                        ? Colors.redAccent
                                        : const Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 4,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(0)!
                                        .machinePosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(1),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          flex: 2,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Y",
                                style: TextStyle(
                                    color: global.objectModelMove.result?.axes
                                                ?.elementAt(1)
                                                .homed ==
                                            false
                                        ? Colors.red
                                        : const Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 4,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(1)!
                                        .machinePosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(1),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                          flex: 2,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Z",
                                style: TextStyle(
                                    color: global.objectModelMove.result?.axes
                                                ?.elementAt(2)
                                                .homed ==
                                            false
                                        ? Colors.red
                                        : const Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 4,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(2)!
                                        .machinePosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
          ],
        )));
    throw UnimplementedError();
  }
}




class CoordoneesOutil extends StatefulWidget {
  const CoordoneesOutil({super.key, this.child, this.notifyParent});

  final Widget? child;
  final Function()? notifyParent;

  @override
  State<CoordoneesOutil> createState() => CoordoneesOutilState(notifyParent);
}

class CoordoneesOutilState extends State<CoordoneesOutil> {
  final VoidCallback? _notifyParent;

  CoordoneesOutilState(this._notifyParent);

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Container(
            //margin: EdgeInsets.all(10),
            //color: Colors.green,
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "X",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(0)!
                                        .userPosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result
                                          ?.state?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 X0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "Set 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result
                                  ?.state?.status ==
                                  "processing"
                                  ? null
                                  : () {
                                API_Manager()
                                    .sendGcodeCommand("G0 X0");
                              },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "GO TO 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Y",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(1)!
                                        .userPosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result
                                          ?.state?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Y0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "Set 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result
                                  ?.state?.status ==
                                  "processing"
                                  ? null
                                  : () {
                                API_Manager()
                                    .sendGcodeCommand("G0 Y0");
                              },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "GO TO 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Z",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                        ?.elementAt(2)!
                                        .userPosition
                                        ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result
                                          ?.state?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Z0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "Set 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: NeumorphicButton(
                              onPressed: global.machineObjectModel.result
                                  ?.state?.status ==
                                  "processing"
                                  ? null
                                  : () {
                                API_Manager()
                                    .sendGcodeCommand("G0 Z0");
                              },
                              style: const NeumorphicStyle(
                                color: Color(0xFFF0F0F3),
                              ),
                              child: const Center(
                                child: Text(
                                  "GO TO 0",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF707585),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Flexible(
                      flex :1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeumorphicButton(
                          onPressed:
                              global.machineObjectModel.result?.state?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 X0 Y0 Z0");
                                      API_Manager().sendGcodeCommand("G10 L20 P1");
                                    },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Center(
                            child: Text(
                              "Set 0 XYZ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF707585),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex :1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NeumorphicButton(
                          onPressed:
                          global.machineObjectModel.result?.state?.status ==
                              "processing"
                              ? null
                              : () {
                            API_Manager()
                                .sendGcodeCommand("G53 G0 Z189");
                            API_Manager().sendGcodeCommand("G0 X0 Y0");
                            API_Manager().sendGcodeCommand("G0 Z0");
                          },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Center(
                            child: Text(
                              "GO TO 0 XYZ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF707585),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

          ],
        )));
    throw UnimplementedError();
  }
}



class CoordoneesOutilSansBouton extends StatefulWidget {
  const CoordoneesOutilSansBouton({super.key, this.child, this.notifyParent});

  final Widget? child;
  final Function()? notifyParent;

  @override
  State<CoordoneesOutilSansBouton> createState() => CoordoneesOutilSansBoutonState(notifyParent);
}

class CoordoneesOutilSansBoutonState extends State<CoordoneesOutilSansBouton> {
  final VoidCallback? _notifyParent;

  CoordoneesOutilSansBoutonState(this._notifyParent);

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "X",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                    ?.elementAt(0)!
                                    .userPosition
                                    ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Y",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                    ?.elementAt(1)!
                                    .userPosition
                                    ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                          flex: 1,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Z",
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ))),
                      Flexible(
                          flex: 3,
                          child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                global.machineObjectModel.result?.move?.axes
                                    ?.elementAt(2)!
                                    .userPosition
                                    ?.toStringAsFixed(2) ??
                                    "...",
                                style: const TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),

                    ],
                  ),
                )),

          ],
        ));
    throw UnimplementedError();
  }
}



class SpindleSpeed extends StatefulWidget {
  const SpindleSpeed({super.key, this.child});

  final Widget? child;

  @override
  State<SpindleSpeed> createState() => SpindleSpeedState();
}

class SpindleSpeedState extends State<SpindleSpeed> {

  TextEditingController SpindleValueController = TextEditingController();
  bool SpindleFanIsOn = false;
  bool SpindleIsOn = false;

  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Column(
                            children: [
                              Text(
                                global.machineObjectModel.result?.spindles?[0]
                                        .current
                                        .toString() ??
                                    "???",
                                style: const TextStyle(
                                    fontSize: 2000, color: Color(0xFF707585)),
                              ),
                              const Text(
                               " Trs/min",
                                style: TextStyle(
                                    fontSize: 800, color: Color(0xFF707585)),
                              ),
                            ],
                          ))),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Neumorphic(
                          style: const NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
                          //color: Colors.green,
                          child: Container(
                              child: TextField(
                                controller: SpindleValueController,
                            keyboardType: TextInputType.number,
                          )),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: NeumorphicButton(
                            style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                            onPressed: () {
                              setState(() {
                                API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                  API_Manager().sendGcodeCommand("M3 P0 S${SpindleValueController.text}").then((value) {
                                    SpindleValueController.clear();
                                  });
                                });


                              });
                            },
                            child: const Icon(
                              Icons.send,
                              color: Color(0xFF707585),
                            ),
                          ))
                    ],
                  ),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(15),
                          style: NeumorphicStyle(
                            depth: global.machineObjectModel.result!.fans![3]!.actualValue!>0?-5:5,//SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            if(global.machineObjectModel.result!.fans![3]!.actualValue!>0)API_Manager().sendGcodeCommand("M106 P3 S0").then((value) {setState(() {

                            });});
                            else API_Manager().sendGcodeCommand("M106 P3 S255").then((value) {
                              setState(() {

                              });});
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.thermostat_outlined,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Vent. Broche',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(15),
                          style: NeumorphicStyle(
                            depth: global.machineObjectModel.result!.spindles![0]!.current!>0?-5:5,//SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            if(global.machineObjectModel.result!.spindles![0]!.current==0)API_Manager().sendGcodeCommand("M5 P0").then((value) {
                              API_Manager().sendGcodeCommand("M3 P0 S6000");
                              setState(() {

                              });});
                            else API_Manager().sendGcodeCommand("M5 P0").then((value) {
                              setState(() {

                              });});
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.rotate_left,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      '10% Broche',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1,
                        child: NeumorphicButton(
                          margin: const EdgeInsets.all(15),
                          style: NeumorphicStyle(
                            depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                            color: const Color(0xFFF0F0F3),
                          ),
                          onPressed: () {
                            if(global.machineObjectModel.result!.spindles![0]!.current!>0)API_Manager().sendGcodeCommand("M5 P0").then((value) {
                              setState(() {

                              });});
                          },
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(
                                  Icons.do_disturb_alt_outlined,
                                  color: Color(0xFF707585),
                                ),
                                const FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      'Stop Broche',
                                      style: TextStyle(
                                          color: Color(0xFF707585)),
                                    ))
                              ]),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
    throw UnimplementedError();
  }
}



class PrintToolsTemperature extends StatefulWidget {
  const PrintToolsTemperature({super.key, this.child});

  final Widget? child;

  @override
  State<PrintToolsTemperature> createState() => PrintToolsTemperatureState();
}

class PrintToolsTemperatureState extends State<PrintToolsTemperature> {

  TextEditingController TemperatureValueController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: const Color(0xFFF0F0F3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(flex:1,child: Text('  Tête')),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Text(
                                            global.machineObjectModel.result?.heat?.heaters?[1].current.toString() ??
                                                "???",
                                            style: const TextStyle(
                                                fontSize: 20, color: Color(0xFF707585)),
                                          ),
                                          const Text(
                                            " °C",
                                            style: TextStyle(
                                                fontSize: 20, color: Color(0xFF707585)),
                                          ),
                                        ],
                                      ))),
                            )),
                        Flexible(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              height: double.infinity,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Neumorphic(
                                      style: const NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
                                      //color: Colors.green,
                                      child: Container(
                                          child: TextField(
                                            controller: TemperatureValueController,
                                            keyboardType: TextInputType.number,
                                          )),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: NeumorphicButton(
                                        style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                                        onPressed: () {
                                          setState(() {
                                            API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                              API_Manager().sendGcodeCommand("M3 P0 S${TemperatureValueController.text}").then((value) {
                                                TemperatureValueController.clear();
                                              });
                                            });


                                          });
                                        },
                                        child: const Icon(
                                          Icons.send,
                                          color: Color(0xFF707585),
                                        ),
                                      ))
                                ],
                              ),
                            )),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(flex: 1,child: Text('  Lit')),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Text(
                                            global.machineObjectModel.result?.heat?.heaters?[0].current.toString() ??
                                                "???",
                                            style: const TextStyle(
                                                fontSize: 20, color: Color(0xFF707585)),
                                          ),
                                          const Text(
                                            " °C",
                                            style: TextStyle(
                                                fontSize: 20, color: Color(0xFF707585)),
                                          ),
                                        ],
                                      ))),
                            )),
                        Flexible(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              height: double.infinity,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Neumorphic(
                                      style: const NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
                                      //color: Colors.green,
                                      child: Container(
                                          child: TextField(
                                            controller: TemperatureValueController,
                                            keyboardType: TextInputType.number,
                                          )),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: NeumorphicButton(
                                        style: const NeumorphicStyle(color: Color(0xFFF0F0F3)),
                                        onPressed: () {
                                          setState(() {
                                            API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                              API_Manager().sendGcodeCommand("M3 P0 S${TemperatureValueController.text}").then((value) {
                                                TemperatureValueController.clear();
                                              });
                                            });


                                          });
                                        },
                                        child: const Icon(
                                          Icons.send,
                                          color: Color(0xFF707585),
                                        ),
                                      ))
                                ],
                              ),
                            )),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
    throw UnimplementedError();
  }
}




class LaserToolPower extends StatefulWidget {
  const LaserToolPower({super.key, this.child});

  final Widget? child;

  @override
  State<LaserToolPower> createState() => LaserToolPowerState();
}

class LaserToolPowerState extends State<LaserToolPower> {

  TextEditingController LaserValueController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Center(
      child: Container(
          color: const Color(0xFFF0F0F3),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    margin: const EdgeInsets.all(20),
                    style: NeumorphicStyle(
                      //depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                      color: const Color(0xFFF0F0F3),
                    ),
                    onPressed: ()async {
                      await API_Manager().sendGcodeCommand('M452 C"nil"');
                      await API_Manager().sendGcodeCommand('M950 P1 C"out5-"');
                      await API_Manager().sendGcodeCommand('M42 P1 S0.01');
                    },
                    child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            color: Color(0xFF707585),
                          ),
                          const FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                'On',
                                style: TextStyle(
                                    color: Color(0xFF707585)),
                              ))
                        ]),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: NeumorphicButton(
                    margin: const EdgeInsets.all(20),
                    style: NeumorphicStyle(
                      //depth: global.machineObjectModel.result!.spindles![0]!.current!>0?5:-5,//SpindleFanIsOn?-10:10,
                      color: const Color(0xFFF0F0F3),
                    ),
                    onPressed: ()async {
                      await API_Manager().sendGcodeCommand('M42 P1 S0');
                      await API_Manager().sendGcodeCommand('M950 P1 C"nil"');
                      await API_Manager().sendGcodeCommand('M452 C"out5-" S1');
                    },
                    child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.lightbulb_outlined,
                            color: Color(0xFF707585),
                          ),
                          Text(
                            'Off',
                            style: TextStyle(
                                color: Color(0xFF707585)),
                          )
                        ]),
                  ),
                ),
              ),
            ],
          )),
    );
    throw UnimplementedError();
  }
}



class CoefVitesse extends StatefulWidget{
  @override
  State<CoefVitesse> createState() => CoefVitesseState();
}

class CoefVitesseState extends State<CoefVitesse>{


  double sliderValueSpeedFactor = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderValueSpeedFactor = global.objectModelMove.result?.speedFactor??2;
    sliderValueSpeedFactor = sliderValueSpeedFactor/2;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 1,maxHeight: 30),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 35,minHeight: 15,maxWidth: 1000),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0,top: 5.0),
                      child: Text(
                        "Coeficient",
                        style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.bold,fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 35,minHeight: 15,),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(
                        "  vitesse",
                        style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.w100,fontSize: 15),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    global.objectModelMove.result?.speedFactor?.toStringAsFixed(1) ??
                        "???",
                    style: const TextStyle(
                        fontSize: 15, color: Color(0xFF707585)),
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: (){setState(() {
                        sliderValueSpeedFactor = ((sliderValueSpeedFactor*200-10)/200);
                        API_Manager().sendGcodeCommand("M220 S${sliderValueSpeedFactor*200}").then((value) {
                          setState(() {

                          });
                        });
                      });}, child: const Text("-",style: TextStyle(fontSize:20,color: Colors.black26 ),)),
                      Slider(activeColor: const Color(0xFF20917F),
                          inactiveColor: const Color(0xFF20917F).withOpacity(0.2),
                          onChangeEnd:(double value){
                            API_Manager().sendGcodeCommand("M220 S${sliderValueSpeedFactor*200}").then((value) {
                              setState(() {

                              });
                            });
                          },value: sliderValueSpeedFactor, onChanged: (double value){
                            setState(() {
                              sliderValueSpeedFactor=value;
                            });}),
                      TextButton(onPressed: (){setState(() {
                        sliderValueSpeedFactor = ((sliderValueSpeedFactor*200+10)/200);
                        API_Manager().sendGcodeCommand("M220 S${sliderValueSpeedFactor*200}").then((value) {
                          setState(() {

                          });
                        });
                      });}, child: const Text("+",style: TextStyle(fontSize: 20,color: Colors.black26),)),
                    ],)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}



class VitesseBroche extends StatefulWidget{
  @override
  State<VitesseBroche> createState() => VitesseBrocheState();
}

class VitesseBrocheState extends State<VitesseBroche>{

  double sliderValue= 0;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sliderValue = global.machineObjectModel.result?.spindles?[0].current??0.1;
    sliderValue=sliderValue/24000;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 1,maxHeight: 30),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 35,minHeight: 15,maxWidth: 1000),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0,top: 5.0),
                        child: Text(
                          "Vitesse",
                          style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.bold,fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 35,minHeight: 15,),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          " broche",
                          style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.w100,fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        global.machineObjectModel.result?.spindles?[0]
                            .current
                            .toString() ??
                            "???",
                        style: const TextStyle(
                            fontSize: 35, color: Color(0xFF707585)),
                      ),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(onPressed: (){setState(() {
                            if((sliderValue*24000)>=250)sliderValue = ((sliderValue*24000-250)/24000);
                            API_Manager().sendGcodeCommand("M5 P0").then((value) {
                              API_Manager().sendGcodeCommand("M3 P0 S${sliderValue*24000}").then((value) {
                                setState(() {

                                });
                              });
                            });
                          });}, child: const Text("-",style: TextStyle(fontSize:60,color: Colors.black26 ),)),
                          Slider(
                              activeColor: const Color(0xFF20917F),
                              inactiveColor: const Color(0xFF20917F).withOpacity(0.2),
                              onChangeEnd:(double value){
                                API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                  API_Manager().sendGcodeCommand("M3 P0 S${sliderValue*24000}").then((value) {
                                    setState(() {

                                    });
                                  });
                                });
                              },value: sliderValue, onChanged: (double value){
                            setState(() {
                              sliderValue=value;
                            });}),
                          TextButton(onPressed: (){setState(() {
                            if((sliderValue*24000)<24000)sliderValue = ((sliderValue*24000+250)/24000);
                            API_Manager().sendGcodeCommand("M5 P0").then((value) {
                              API_Manager().sendGcodeCommand("M3 P0 S${sliderValue*24000}").then((value) {
                                setState(() {

                                });
                              });
                            });
                          });}, child: const Text("+",style: TextStyle(fontSize: 50,color: Colors.black26),)),
                        ],)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}



class BabyStepZ extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 1,maxHeight: 30),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 35,minHeight: 15,maxWidth: 1000),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0,top: 5.0),
                        child: Text(
                          "Compensation",
                          style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.bold,fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 35,minHeight: 15,),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          " Z",
                          style: TextStyle(color: Color(0xFF707585),fontWeight: FontWeight.w100,fontSize: 15),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      API_Manager().sendGcodeCommand("M290 S+0.1");
                    },style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: const Color(0xFF20917F)), child: Container(width: 50,child: const Text("+ 0.1",textAlign: TextAlign.center,))),
                    const Padding(padding: EdgeInsets.only(top: 3)),
                    ElevatedButton(onPressed: (){
                      API_Manager().sendGcodeCommand("M290 S-0.1");
                    },style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: const Color(0xFF20917F)), child: Container(width: 50,child: const Text("- 0.1",textAlign: TextAlign.center,))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


class JobInfo extends StatefulWidget {
  @override
  State<JobInfo> createState() => JobInfoState();
}

class JobInfoState extends State<JobInfo> {
  int secondsElapsedSinceBeginning = 0; // Temps écoulé depuis le début en secondes
  late Timer timer;
  double pourcentageComplet = 0.0; // Pourcentage complet de la tâche
  String globalTimeValue = "00:00:00"; // Variable pour stocker le temps global
  bool isJobPaused = false; // Vous devez définir cette variable en fonction de votre logique
  bool isPercentage = false; //dit si le programme a été a 100%


  void showCompletionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tâche terminée"),
          content: Text("Le programme est terminé. Durée du programme : $globalTimeValue"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Recommencer Programme"),
              onPressed: () {
                Navigator.of(context).pop();
                API_Manager().sendGcodeCommand('M32 "0:/gcodes/' + progName + '"');
                Navigator.pushNamed(context, '/jobStatus');
              },
            ),
            ElevatedButton(
              child: Text("Dégager tête"),
              onPressed: () {
                Navigator.of(context).pop();
                API_Manager().sendGcodeCommand("G53 G0 Z189").then((value) => API_Manager().sendGcodeCommand("G53 G0 X0 Y550"));
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
          ],
        );
      },
    );
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    actualiserJobObjectModel();
  }

  bool isPopupDisplayed = false;

  Future<void> actualiserJobObjectModel() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isJobPaused) {
        setState(() {
          secondsElapsedSinceBeginning++;
          // Calculez le temps et stockez-le dans la variable globale ici
          int hours = secondsElapsedSinceBeginning ~/ 3600;
          int minutes = (secondsElapsedSinceBeginning % 3600) ~/ 60;
          int seconds = secondsElapsedSinceBeginning % 60;
          globalTimeValue =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        });
      }

      API_Manager().getMachineJobObjectModel().then((job) {
        global.objectModelJob = job;
        // Mettez à jour le pourcentage complet de la tâche ici
        pourcentageComplet =
            (global.objectModelJob.result?.filePosition ?? 0) / (global.objectModelJob.result?.file?.size?.toInt() ?? 1) * 100;

        // Vérifiez si le pourcentage atteint 100% et affichez le popup
        if (global.machineObjectModel.result?.state?.status == "idle" && !isPopupDisplayed && isPercentage == true) {
          isPopupDisplayed = true; // Marquez le popup comme déjà affiché
          showCompletionPopup(context);
        }
        if(pourcentageComplet == 100){
          isPercentage = true;
        }
      });
      if (global.myEthernet_connection.isConnected == false) timer.cancel();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int hours = secondsElapsedSinceBeginning ~/ 3600;
    int minutes = (secondsElapsedSinceBeginning % 3600) ~/ 60;
    int seconds = secondsElapsedSinceBeginning % 60;

    int tempsTotalEnSecondes = (secondsElapsedSinceBeginning / (pourcentageComplet / 100)).toInt();
    int tempsRestantEnSecondes = tempsTotalEnSecondes - secondsElapsedSinceBeginning;



    return Card(
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 1, maxHeight: 30),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 35,
                        minHeight: 15,
                        maxWidth: 1000,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 5.0),
                        child: Text(
                          "Job",
                          style: TextStyle(
                            color: Color(0xFF707585),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 35,
                        minHeight: 15,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          " en cours",
                          style: TextStyle(
                            color: Color(0xFF707585),
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Depuis début",
                            style: const TextStyle(color: Color(0xFF494949)),
                          ),
                          Text(
                            globalTimeValue,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Color(0xFF707585),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Durée restante estimée",
                            style: TextStyle(color: Color(0xFF494949)),
                          ),
                          Text(
                            "${formatDuration(tempsRestantEnSecondes)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                                color: Color(0xFF707585)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Pourcentage",
                            style: const TextStyle(color: Color(0xFF494949)),
                          ),
                          Text(
                            "${pourcentageComplet.round().toString()}%", // a tester avec pourcentageComplet
                            style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                                color: Color(0xFF707585)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
