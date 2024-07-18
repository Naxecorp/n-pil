import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/dashBoardWidgets/laser_power.dart';
import 'package:nweb/dashBoardWidgets/print_tool.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/autoScrollTextFile.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';
import '../dashBoardWidgets/coord_machine.dart';
import '../dashBoardWidgets/coord_outil.dart';
import '../dashBoardWidgets/vitesse_broche.dart';
import '../dashBoardWidgets/baby_stepZ.dart';
import '../dashBoardWidgets/job_info.dart';
import '../dashBoardWidgets/coef_vitesse.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../widgetUtils/ArretUrgence.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class JobScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JobScreenState();
  }
}

class JobScreenState extends State<JobScreen> {
  double sliderValue = 0;
  double sliderValueSpeedFactor = 0;
  double? SpindleSpeedBeforePause = 0;

  void actualiser() {}

  @override
  void initState() {
    super.initState();
    global.streamMachineObjectModel.listen((value) {
      setState(() {});
    });
    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      global.checkCaissonOpen(context);
    });

    sliderValue =
        global.machineObjectModel.result?.spindles?[0].current?.toDouble() ??
            24000;
    sliderValue = sliderValue / 24000;
    sliderValueSpeedFactor =
        global.objectModelMove.result?.speedFactor?.toDouble() ?? 2;
    sliderValueSpeedFactor = sliderValueSpeedFactor / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: Color(0xFFF0F0F3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                    child: Image(image: AssetImage("assets/iconnaxe.png")))),
            Flexible(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: ManualGcodeComand,
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),
                            ),
                            onSubmitted: (Commande) {
                              setState(() {
                                global.commandHistory.add(Commande);
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then(
                                    (value) => API_Manager().sendrr_reply());
                              });
                              print(Commande);
                            },
                          ),
                          PopupMenuButton<String>(
                            tooltip: "Historique",
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                ManualGcodeComand.text = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return global.commandHistory
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 4,
                child: Container(
                  child: Column(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                //color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text("Visualisation bientôt disponible"),
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                //color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text("Visualisation bientôt disponible"),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
              flex: 6,
              child: Container(
                // color: Colors.green,
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Column(
                        children: [
                          Flexible(flex: 80, child: JobInfo()),
                          Flexible(
                            flex: 50,
                            child: Container(
                              //color: Colors.green,
                              height: double.infinity,
                              //color: Colors.white,
                              margin: EdgeInsets.all(0),
                              child: Window(
                                title1: "Capteurs",
                                title2: " machine",
                                child: Container(
                                    //color: Colors.green,
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(1),
                                          //color: Colors.green,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Status",
                                                style: TextStyle(
                                                    color: Color(0xFF707585),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  global.machineObjectModel
                                                          .result?.state?.status
                                                          .toString() ??
                                                      "???",
                                                  style: TextStyle(
                                                      color: global
                                                                  .machineObjectModel
                                                                  .result
                                                                  ?.state
                                                                  ?.status
                                                                  .toString() ==
                                                              "pausing"
                                                          ? Colors.yellowAccent
                                                          : Color(0xFF707585))),
                                            ],
                                          ),
                                        )),
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(1),
                                          //color: Colors.green,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "MCU Température",
                                                style: TextStyle(
                                                    color: Color(0xFF707585),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      global.machineObjectModel
                                                              .result?.boards
                                                              ?.elementAt(0)
                                                              .mcuTemp
                                                              ?.current
                                                              ?.toStringAsFixed(
                                                                  1) ??
                                                          "...",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF707585))),
                                                  Text("°C",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF707585)))
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "V12",
                                                style: TextStyle(
                                                    color: Color(0xFF707585),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    global.machineObjectModel
                                                            .result?.boards
                                                            ?.elementAt(0)
                                                            .v12
                                                            ?.current
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        "...",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF707585)),
                                                  ),
                                                  Text(" V",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF707585))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Vin",
                                              style: TextStyle(
                                                  color: Color(0xFF707585),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                    global.machineObjectModel
                                                            .result?.boards
                                                            ?.elementAt(0)
                                                            .vIn
                                                            ?.current
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        "...",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF707585))),
                                                Text(" V",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF707585))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        //color: Colors.green,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Driver(s)",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF707585),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          (global
                                                                          .machineObjectModel
                                                                          .result
                                                                          ?.sensors
                                                                          ?.gpIn?[
                                                                      9] ==
                                                                  null)
                                                              ? Icons
                                                                  .power_off_outlined
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[9]?.value ??
                                                                          0) ==
                                                                      0
                                                                  ? Icons
                                                                      .power_rounded
                                                                  : Icons
                                                                      .power_rounded,
                                                          color: (global
                                                                          .machineObjectModel
                                                                          .result
                                                                          ?.sensors
                                                                          ?.gpIn?[
                                                                      9] ==
                                                                  null)
                                                              ? Colors.grey
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[9]
                                                                              ?.value ??
                                                                          0) ==
                                                                      0
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Column(
                                                  children: [
                                                    const Text(
                                                      "Caisson",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF707585),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          (global.machineObjectModel.result?.sensors?.gpIn
                                                                              ?.length ??
                                                                          0) <
                                                                      11 ||
                                                                  global.machineObjectModel.result?.sensors
                                                                              ?.gpIn?[
                                                                          10] ==
                                                                      null
                                                              ? Icons
                                                                  .key_off_outlined
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[10]?.value ??
                                                                          1) ==
                                                                      1
                                                                  ? Icons.lock
                                                                  : Icons
                                                                      .lock_open_rounded,
                                                          color: (global.machineObjectModel.result?.sensors?.gpIn
                                                                              ?.length ??
                                                                          0) <
                                                                      11 ||
                                                                  global.machineObjectModel.result?.sensors
                                                                              ?.gpIn?[
                                                                          10] ==
                                                                      null
                                                              ? Colors.grey
                                                              : (global.machineObjectModel.result?.sensors?.gpIn?[10]
                                                                              ?.value ??
                                                                          1) ==
                                                                      1
                                                                  ? Colors.green
                                                                  : Colors.orange,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 70,
                              child: Container(
                                height: double.infinity,
                                //color: Colors.white,
                                margin: EdgeInsets.all(0),
                                child: Window(
                                  title1: "Coordonées",
                                  title2: " machine",
                                  child: CoordoneesMachine(),
                                ),
                              )),
                          Flexible(
                              flex: 70,
                              child: Container(
                                height: double.infinity,
                                //color: Colors.white,
                                margin: EdgeInsets.all(0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                        flex: 4,
                                        child: Window(
                                          title1: "Coordonées",
                                          title2: " outil",
                                          child: CoordoneesOutilSansBouton(),
                                        )),
                                    Flexible(
                                        flex: 2,
                                        child: Window(
                                          title1: "Vitesse",
                                          title2: " demandée",
                                          child: Center(
                                              child: Text(
                                                  "${global.machineObjectModel.result?.move?.currentMove?.requestedSpeed.toString() ?? "..."} mm/s")),
                                        )),
                                  ],
                                ),
                              )),
                          Flexible(
                            flex: 260,
                            child: Container(
                              height: double.infinity,
                              //color: Colors.white,
                              margin: EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      //color: Colors.pink,
                                      child: Column(
                                        children: [
                                          Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: CoefVitesse(),
                                              )),
                                          Flexible(
                                              flex: 1,
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: BabyStepZ(),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: (global.machineMode ==
                                              global.MachineMode.cnc)
                                          ? VitesseBroche()
                                          : (global.machineMode ==
                                                  global.MachineMode.fff)
                                              ? PrintToolsTemperature()
                                              : LaserToolPower(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    String tempStatus = global
                                            .machineObjectModel
                                            .result
                                            ?.state
                                            ?.status
                                            .toString() ??
                                        "";
                                    if (tempStatus == "paused") {
                                      API_Manager().sendGcodeCommand("M24");
                                      global.isJobPausedByUser = false;
                                    } else {
                                      API_Manager()
                                          .sendGcodeCommand("M25")
                                          .then((value) => API_Manager()
                                              .sendrr_reply()
                                              .then((value) => global
                                                  .isJobPausedByUser = true));
                                    }
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2B519B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: global.machineObjectModel
                                                          .result?.state?.status
                                                          .toString() ==
                                                      "paused"
                                                  ? Colors.orange
                                                  : global
                                                              .machineObjectModel
                                                              .result
                                                              ?.state
                                                              ?.status
                                                              .toString() ==
                                                          "pausing"
                                                      ? Colors.yellowAccent
                                                      : Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Pause Cycle',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: ElevatedButton(
                                  onPressed: global.machineObjectModel.result
                                              ?.state?.status
                                              .toString() ==
                                          "paused"
                                      ? () {
                                          API_Manager().sendGcodeCommand("M0");
                                          API_Manager()
                                              .sendGcodeCommand("M106 P3 S0");
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFCE711A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Stop Cycle'),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                )),
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                child: ArretUrgence(
                                  notifyParent: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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
