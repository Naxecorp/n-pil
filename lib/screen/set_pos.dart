import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/screen/screens.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:nweb/service/nwc-settings/position.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

TextEditingController ManualGcodeComand = TextEditingController();

// Widget pour une sauvegarde de position
class SetPosition extends StatefulWidget {
  final VoidCallback? onClickOnSet;

  final TextEditingController? posX;
  final TextEditingController? posY;
  final TextEditingController? posZ;
  SetPosition({super.key, this.onClickOnSet, this.posX, this.posY, this.posZ});

  @override
  State<SetPosition> createState() =>
      _SetPositionState(onClickOnSet, posX, posY, posZ);
}

class _SetPositionState extends State<SetPosition> {
  final VoidCallback? _onClickOnSet;

  // Création de controller pour Set from actual
  final TextEditingController? _posX;
  final TextEditingController? _posY;
  final TextEditingController? _posZ;

  _SetPositionState(this._onClickOnSet, this._posX, this._posY, this._posZ);

  // Création de controller pour Set from actual
  //final posX = TextEditingController(text: '0');
  //final posY = TextEditingController(text: '0');
  //final posZ = TextEditingController(text: '0');

  String textX = global.machineObjectModel.result?.move?.axes
          ?.elementAt(0)!
          .machinePosition
          ?.toStringAsFixed(2) ??
      "0";
  String textY = global.machineObjectModel.result?.move?.axes
          ?.elementAt(1)!
          .machinePosition
          ?.toStringAsFixed(2) ??
      "0";
  String textZ = global.machineObjectModel.result?.move?.axes
          ?.elementAt(2)!
          .machinePosition
          ?.toStringAsFixed(2) ??
      "0";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Window(
          title1: "Positions",
          title2: " machine",
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  //color: Colors.amber,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "X",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.05,
                        //color: Colors.greenAccent,
                        child: TextFormField(
                          controller: _posX,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gapPadding: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  //color: Colors.orange,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Y",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.05,
                        //color: Colors.greenAccent,
                        child: TextFormField(
                          controller: _posY,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gapPadding: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  //color: Colors.blue,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Z",
                          style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.05,
                        //color: Colors.greenAccent,
                        child: TextFormField(
                          controller: _posZ,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gapPadding: 5.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  //color: Colors.green,
                  width: double.infinity,
                  //color: Colors.red,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: NeumorphicButton(
                          onPressed: () {
                            return _onClickOnSet!();
                          },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Text(
                            "Set",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: NeumorphicButton(
                          onPressed: () {
                            API_Manager().sendGcodeCommand("G53 G0 Z189");
                            API_Manager()
                                .sendGcodeCommand("G53 G0 X${_posX?.text}");
                            API_Manager()
                                .sendGcodeCommand("G53 G0 Y${_posY?.text}");
                            API_Manager()
                                .sendGcodeCommand("G53 G0 Z${_posZ?.text}");
                          },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Text(
                            "Go to",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: NeumorphicButton(
                          onPressed: () {
                            _posX?.text = textX;
                            _posY?.text = textY;
                            _posZ?.text = textZ;
                            _posX?.selection =
                                TextSelection.collapsed(offset: textX.length);
                            _posY?.selection =
                                TextSelection.collapsed(offset: textY.length);
                            _posZ?.selection =
                                TextSelection.collapsed(offset: textZ.length);
                          },
                          style: const NeumorphicStyle(
                            color: Color(0xFFF0F0F3),
                          ),
                          child: const Text(
                            "Set from actual",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetPos extends StatefulWidget {
  @override
  State<SetPos> createState() => SetPosState();
}

class SetPosState extends State<SetPos> {
  final TextEditingController _controllers = TextEditingController();

  @override
  initState() {
    super.initState();
    onReceivedData();
    global.streamMachineObjectModel.listen((value) {
      setState(() {});
    });
  }

  void saveConfig() {
    global.MyMachineN02Config.Lastmodifition = DateTime.now().toString();
    API_Manager().upLoadAFile(
        "0:/sys/nwc-settings.json",
        global.MyMachineN02Config.toJson().length.toString(),
        Uint8List.fromList(
            machineN02ConfigToJson(global.MyMachineN02Config).codeUnits));
    print(machineN02ConfigToJson(global.MyMachineN02Config));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F3),
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
                    child: Image(image: AssetImage('assets/iconnaxe.png')))),
            Flexible(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      //margin: EdgeInsets.all(40),
                      child: TextField(
                        controller: ManualGcodeComand,
                        decoration: const InputDecoration(
                          hintText: "Gcode",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gapPadding: 5.0,
                          ),
                        ),
                        onSubmitted: (Commande) {
                          setState(() {
                            ManualGcodeComand.clear();
                            API_Manager()
                                .sendGcodeCommand(Commande)
                                .then((value) => API_Manager().sendrr_reply());
                          });
                          print(Commande);
                        },
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
      // body: Container(
      //   color: Colors.white,
      //   child: ListView.builder(
      //     itemCount: global.MyMachineN02Config.Positions?.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       List<TextEditingController> listPosX = [TextEditingController()];
      //       List<TextEditingController> listPosY = [TextEditingController()];
      //       List<TextEditingController> listPosZ = [TextEditingController()];
      //       return SetPosition(
      //         posX: listPosX[index = 0],
      //         posY: listPosY[index = 0],
      //         posZ: listPosZ[index = 0],
      //         onClickOnSet: () {
      //           global.MyMachineN02Config.Positions?[index] = Position(
      //             PosX: double.tryParse(listPosX[index].text),
      //             PosY: double.tryParse(listPosY[index].text),
      //             PosZ: double.tryParse(listPosZ[index].text),
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: global.MyMachineN02Config.Positions?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            // Utilisez un contrôleur par élément de la liste
            TextEditingController controllerPosX = TextEditingController();
            TextEditingController controllerPosY = TextEditingController();
            TextEditingController controllerPosZ = TextEditingController();

            // Remplissez les contrôleurs avec les valeurs actuelles si disponibles
            if (global.MyMachineN02Config.Positions != null &&
                index < global.MyMachineN02Config.Positions!.length) {
              controllerPosX.text = global
                      .MyMachineN02Config.Positions![index].PosX
                      ?.toString() ??
                  '';
              controllerPosY.text = global
                      .MyMachineN02Config.Positions![index].PosY
                      ?.toString() ??
                  '';
              controllerPosZ.text = global
                      .MyMachineN02Config.Positions![index].PosZ
                      ?.toString() ??
                  '';
            }

            return SetPosition(
              // Utilisez le contrôleur approprié pour chaque champ de position
              posX: controllerPosX,
              posY: controllerPosY,
              posZ: controllerPosZ,
              onClickOnSet: () {
                // Mettez à jour la position dans la liste avec les nouvelles valeurs
                global.MyMachineN02Config.Positions?[index] = Position(
                  PosX: double.tryParse(controllerPosX.text),
                  PosY: double.tryParse(controllerPosY.text),
                  PosZ: double.tryParse(controllerPosZ.text),
                );
                API_Manager().upLoadAFile(
                  "0:/sys/nwc-settings.json",
                  global.MyMachineN02Config.toJson().length.toString(),
                  Uint8List.fromList(
                      machineN02ConfigToJson(global.MyMachineN02Config)
                          .codeUnits),
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Position n°${index + 1} enregistrée'),
                  duration: const Duration(milliseconds: 600),
                ));
              },
            );
          },
        ),
      ),
    );
  }

  void onReceivedData() async {
    //_channel.sink.add('PING');
    //_channel.stream.listen((event) {print(event.toString());});
  }

  void _sendMessage() {
    if (_controllers.text.isNotEmpty) {
      //_channel.sink.add(_controllers.text);
    }
  }

  @override
  void dispose() {
    // _channel.sink.close();
    _controllers.dispose();
    super.dispose();
  }
}
