import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../../globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';
import '../../globals_var.dart';
import '../../widgetUtils/touche.dart';
import '../widgetUtils/Joystick/my_joystick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                          ),
                        ),
                      ),
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
                          ),
                        ),
                      ),
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
                          ),
                        ),
                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}

class CoordoneesOutilSansBouton extends StatefulWidget {
  const CoordoneesOutilSansBouton({super.key, this.child, this.notifyParent});

  final Widget? child;
  final Function()? notifyParent;

  @override
  State<CoordoneesOutilSansBouton> createState() =>
      CoordoneesOutilSansBoutonState(notifyParent);
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
