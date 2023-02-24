import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../globals_var.dart' as global;
import 'package:nweb/service/API_Manager.dart';
import '../widgetUtils/touche.dart';
import '../widgetUtils/my_jostick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';

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
                      SizedBox(
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
              margin: EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(
                        color: Color(0xFF707585), fontWeight: FontWeight.bold),
                  ),
                  Text(
                      global.machineObjectModel.result?.statee?.status
                              .toString() ??
                          "???",
                      style: TextStyle(color: Color(0xFF707585))),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
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
                          style: TextStyle(color: Color(0xFF707585))),
                      Text("°C", style: TextStyle(color: Color(0xFF707585)))
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
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
                                ?.elementAt(0)
                                .v12
                                ?.current
                                ?.toStringAsFixed(1) ??
                            "...",
                        style: TextStyle(color: Color(0xFF707585)),
                      ),
                      Text(" V", style: TextStyle(color: Color(0xFF707585))),
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(1),
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
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
                          style: TextStyle(color: Color(0xFF707585))),
                      Text(" V", style: TextStyle(color: Color(0xFF707585))),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF0F0F3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              //color: Colors.orange,
              padding: EdgeInsets.all(2),
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
                                margin: EdgeInsets.all(15),
                                style: NeumorphicStyle(
                                  color: Color(0xFFF0F0F3),
                                ),
                                onPressed: () {
                                  API_Manager()
                                      .sendGcodeCommand("G28 X")
                                      .then((value) => print(value));
                                },
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                margin: EdgeInsets.all(15),
                                style: NeumorphicStyle(
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
                                      Icon(
                                        Icons.home_filled,
                                        color: Color(0xFF707585),
                                      ),
                                      FittedBox(
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
                                margin: EdgeInsets.all(15),
                                style: NeumorphicStyle(
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
                                      Icon(
                                        Icons.home_filled,
                                        color: Color(0xFF707585),
                                      ),
                                      FittedBox(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              "0.01",
                              style: TextStyle(color: Color(0xFF707585)),
                            ),
                            style: NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 0.01,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              "0.1",
                              style: TextStyle(color: Color(0xFF707585)),
                            ),
                            style: NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 0.1,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text("1",
                                style: TextStyle(color: Color(0xFF707585))),
                            style: NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 1.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text("10",
                                style: TextStyle(color: Color(0xFF707585))),
                            style: NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 10.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: NeumorphicRadio(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text("50",
                                style: TextStyle(color: Color(0xFF707585))),
                            style: NeumorphicRadioStyle(
                                shape: NeumorphicShape.convex,
                                unselectedColor: Color(0xFFF0F0F3)),
                            value: 50.0,
                            groupValue: stepValue,
                            onChanged: (double? value) {
                              setState(() {
                                stepValue = value!;
                              });
                            },
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
              //color: Colors.blue,
              padding: EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      //margin: EdgeInsets.symmetric(vertical: 30),
                      //height: 300,
                      //width: 300,
                      //color: Colors.green,
                      child: Joystick(
                        size: 70,
                        iconColor: Color(0xFF707585),
                        onUpPressed: () {
                          API_Manager()
                              .sendGcodeCommand("M120\nG91\nG1 Y" +
                                  stepValue.toString() +
                                  " F6000\nM121\n")
                              .then((value) => print(value));
                        },
                        onDownPressed: () {
                          API_Manager()
                              .sendGcodeCommand("M120\nG91\nG1 Y-" +
                                  stepValue.toString() +
                                  " F6000\nM121\n")
                              .then((value) => print(value));
                        },
                        onLeftPressed: () {
                          API_Manager()
                              .sendGcodeCommand("M120\nG91\nG1 X-" +
                                  stepValue.toString() +
                                  " F6000\nM121\n")
                              .then((value) => print(value));
                        },
                        onRightPressed: () {
                          API_Manager()
                              .sendGcodeCommand("M120\nG91\nG1 X" +
                                  stepValue.toString() +
                                  " F6000\nM121\n")
                              .then((value) => print(value));
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
                        iconColor: Color(0xFF707585),
                        onUpPressed: () {
                          API_Manager()
                              .sendGcodeCommand(
                                  "M120\nG91\nG1 Z$stepValue F6000\nM121\n")
                              .then((value) => print(value));
                          API_Manager().sendrr_reply();
                        },
                        onDownPressed: () {
                          var Zstepdown;
                          if (stepValue > 50)
                            Zstepdown = 1;
                          else
                            Zstepdown = stepValue;
                          API_Manager()
                              .sendGcodeCommand(
                                  "M120\nG91\nG1 Z-$Zstepdown F6000\nM121\n")
                              .then((value) => print('tot' + value));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
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
      color: Color(0xFFF0F0F3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NeumorphicRadio(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "FFF",
                style: TextStyle(color: Color(0xFF707585)),
              ),
              style: NeumorphicRadioStyle(
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
            ),
            NeumorphicRadio(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "Laser",
                style: TextStyle(color: Color(0xFF707585)),
              ),
              style: NeumorphicRadioStyle(
                  shape: NeumorphicShape.convex,
                  unselectedColor: Color(0xFFF0F0F3)),
              value: global.MachineMode.laser,
              groupValue: global.machineMode,
              onChanged: (global.MachineMode? MMvalue) async {
                await API_Manager().sendGcodeCommand("M452");
                await API_Manager()
                    .getMachineMode()
                    .then((value) => global.machineMode = value);
                setState(() {});
              },
            ),
            NeumorphicRadio(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "CNC",
                style: TextStyle(color: Color(0xFF707585)),
              ),
              style: NeumorphicRadioStyle(
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
        color: Color(0xFFF0F0F3),
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
                  margin: EdgeInsets.all(1),
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
                                        : Color(0xFF707585),
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
                                style: TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(1),
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
                                        : Color(0xFF707585),
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
                                style: TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(1),
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
                                        : Color(0xFF707585),
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
                                style: TextStyle(
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
        color: Color(0xFFF0F0F3),
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
                  margin: EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
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
                                style: TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: ElevatedButton(
                              onPressed: global.machineObjectModel.result
                                          ?.statee?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 X0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              child: Text(
                                "Set 0",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF9A9A9A),
                                backgroundColor: Color(0xFFF0F0F3),
                                elevation: 10,
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
                  margin: EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
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
                                style: TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: ElevatedButton(
                              onPressed: global.machineObjectModel.result
                                          ?.statee?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Y0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              child: Text(
                                "Set 0",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF9A9A9A),
                                backgroundColor: Color(0xFFF0F0F3),
                                elevation: 10,
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
                  margin: EdgeInsets.all(5),
                  //color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
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
                                style: TextStyle(
                                    color: Color(0xFF707585), fontSize: 50),
                              ))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.orange,
                            child: ElevatedButton(
                              onPressed: global.machineObjectModel.result
                                          ?.statee?.status ==
                                      "processing"
                                  ? null
                                  : () {
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1 Z0");
                                      API_Manager()
                                          .sendGcodeCommand("G10 L20 P1");
                                    },
                              child: Text(
                                "Set 0",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF707585),
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0xFF9A9A9A),
                                backgroundColor: Color(0xFFF0F0F3),
                                elevation: 10,
                              ),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  width: double.infinity,
                  height: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        global.machineObjectModel.result?.statee?.status ==
                                "processing"
                            ? null
                            : () {
                                API_Manager()
                                    .sendGcodeCommand("G10 L20 P1 X0 Y0 Z0");
                                API_Manager().sendGcodeCommand("G10 L20 P1");
                              },
                    child: Text(
                      "Set 0 XYZ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF9A9A9A),
                      backgroundColor: Color(0xFFF0F0F3),
                      elevation: 10,
                    ),
                  ),
                )),
          ],
        )));
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


  @override
  Widget build(BuildContext context) {
    //global.machineObjectModel.result?.move?.axes?.elementAt(0)!.machinePosition?.toStringAsFixed(2) ?? "...",
    return Container(
        color: Color(0xFFF0F0F3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
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
                                style: TextStyle(
                                    fontSize: 2000, color: Color(0xFF707585)),
                              ),
                              Text(
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
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Neumorphic(
                          style: NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
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
                            style: NeumorphicStyle(color: Color(0xFFF0F0F3)),
                            onPressed: () {
                              setState(() {
                                API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                  API_Manager().sendGcodeCommand("M3 P0 S"+ SpindleValueController.text.toString()).then((value) {
                                    SpindleValueController.clear();
                                  });
                                });


                              });
                            },
                            child: Icon(
                              Icons.send,
                              color: Color(0xFF707585),
                            ),
                          ))
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
        color: Color(0xFFF0F0F3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(flex:1,child: Text('  Tête')),
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
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Text(
                                            global.machineObjectModel.result?.heat?.heaters?[1].current.toString() ??
                                                "???",
                                            style: TextStyle(
                                                fontSize: 20, color: Color(0xFF707585)),
                                          ),
                                          Text(
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
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              height: double.infinity,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Neumorphic(
                                      style: NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
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
                                        style: NeumorphicStyle(color: Color(0xFFF0F0F3)),
                                        onPressed: () {
                                          setState(() {
                                            API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                              API_Manager().sendGcodeCommand("M3 P0 S"+ TemperatureValueController.text.toString()).then((value) {
                                                TemperatureValueController.clear();
                                              });
                                            });


                                          });
                                        },
                                        child: Icon(
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
                  Flexible(flex: 1,child: Text('  Lit')),
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
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Text(
                                            global.machineObjectModel.result?.heat?.heaters?[0].current.toString() ??
                                                "???",
                                            style: TextStyle(
                                                fontSize: 20, color: Color(0xFF707585)),
                                          ),
                                          Text(
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
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(5),
                              height: double.infinity,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Neumorphic(
                                      style: NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
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
                                        style: NeumorphicStyle(color: Color(0xFFF0F0F3)),
                                        onPressed: () {
                                          setState(() {
                                            API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                              API_Manager().sendGcodeCommand("M3 P0 S"+ TemperatureValueController.text.toString()).then((value) {
                                                TemperatureValueController.clear();
                                              });
                                            });


                                          });
                                        },
                                        child: Icon(
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
    return Container(
        color: Color(0xFFF0F0F3),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
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
                                style: TextStyle(
                                    fontSize: 2000, color: Color(0xFF707585)),
                              ),
                              Text(
                                " %",
                                style: TextStyle(
                                    fontSize: 800, color: Color(0xFF707585)),
                              ),
                            ],
                          ))),
                )),
            Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Neumorphic(
                          style: NeumorphicStyle(color: Color(0xFFF0F0F3),depth: -5),
                          //color: Colors.green,
                          child: Container(
                              child: TextField(
                                controller: LaserValueController,
                                keyboardType: TextInputType.number,
                              )),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: NeumorphicButton(
                            style: NeumorphicStyle(color: Color(0xFFF0F0F3)),
                            onPressed: () {
                              setState(() {
                                API_Manager().sendGcodeCommand("M5 P0").then((value) {
                                  API_Manager().sendGcodeCommand("M3 P0 S"+ LaserValueController.text.toString()).then((value) {
                                    LaserValueController.clear();
                                  });
                                });


                              });
                            },
                            child: Icon(
                              Icons.send,
                              color: Color(0xFF707585),
                            ),
                          ))
                    ],
                  ),
                )),
          ],
        ));
    throw UnimplementedError();
  }
}
