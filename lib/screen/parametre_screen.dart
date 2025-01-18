import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class ParametreScreen extends StatefulWidget {
  @override
  State<ParametreScreen> createState() => ParametreScreenState();
}

class ParametreScreenState extends State<ParametreScreen> {
  final TextEditingController _controllers = TextEditingController();
  Duration usedTime = new Duration();
  bool _hasHeatbed = global.MyMachineN02Config.HasHeatBed == 1;
  bool _hasFanOnEnclosure = global.MyMachineN02Config.HasFanOnEnclosure == 1;
  bool _hasLedOnEnclosure = global.MyMachineN02Config.HasLedOnEnclosure == 1;
  bool _hasACT = global.MyMachineN02Config.HasACT == 1;

  // Fonction pour noter la date
  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}d');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add('${hours}h');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add('${minutes}m');
    }
    tokens.add('${seconds}s');

    return tokens.join(':');
  }

  @override
  initState() {
    super.initState();
    onReceivedData();
    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      if(global.MyMachineN02Config.HasFanOnEnclosure==1)global.checkCaissonOpen(context);
    });
    global.streamMachineObjectModel.listen((value) {
      setState(() {});
    });
  }

  void saveConfig() async {
    global.MyMachineN02Config.Lastmodifition = DateTime.now().toString();
    await API_Manager().upLoadAFile(
        "0:/sys/nwc-settings.json",
        global.MyMachineN02Config.toJson().length.toString(),
        Uint8List.fromList(
            machineN02ConfigToJson(global.MyMachineN02Config).codeUnits));
    String content =
        '; coordToolShop\nset global.CoordToolShopX = ${global.MyMachineN02Config.MagasinOutil?[0].CoordX ?? 0}\nset global.CoordToolShopY = ${global.MyMachineN02Config.MagasinOutil?[0].CoordY ?? 0}\nset global.CoordToolShopZ = ${global.MyMachineN02Config.MagasinOutil?[0].CoordZ ?? 188.66}\nset global.EcartementToolShop = ${global.MyMachineN02Config.MagasinOutil?[0].Ecartement ?? 60}\necho "CoordToolShop is modified"';
    await API_Manager().upLoadAFile("0:/sys/coordToolShop.g",
        content.length.toString(), Uint8List.fromList(utf8.encode(content)));
    await API_Manager().sendGcodeCommand('M98 P"CoordToolShop.g"');
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

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
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Window(
                          title1: "Paramêtres",
                          title2: " généraux",
                          child: ListView(
                            children: [
                              Container(
                                width: 500,
                                child: Text(
                                  "Temps d'utilisation depuis Reset : ${formatDuration(Duration(seconds: (global.machineObjectModel.result?.state?.upTime?.toInt() ?? 0)))}",
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: 500,
                                child: Text(
                                  "Temps d'utilisation globale : ${formatDuration(Duration(minutes: (global.MyMachineN02Config.GlobalMachineUsedTime ?? 0)))}",
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: 500,
                                child: Text(
                                  "\nNuméro de série : ${global.MyMachineN02Config.Serie!}",
                                  style: TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Window(
                          title1: "Paramêtres",
                          title2: " machine",
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      'Vitesse min de la broche :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                              .MyMachineN02Config.VitesseDefaut
                                              .toString() ??
                                          "0",
                                      onChanged: (text) {
                                        global.MyMachineN02Config
                                                .VitesseDefaut =
                                            int.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: Text(
                                      " tr/min",
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      'Vitesse max de la broche :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                              .MyMachineN02Config.VitesseBroche
                                              .toString() ??
                                          "0",
                                      onChanged: (text) {
                                        global.MyMachineN02Config
                                                .VitesseBroche =
                                            int.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: Text(
                                      " tr/min",
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      'Coordonées du palpeur outil X :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02Config.Palpeur!.PosX
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!
                                            .PosX = double.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: Text(
                                      'Coordonées du palpeur outil Y :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02Config.Palpeur!.PosY
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!
                                            .PosY = double.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: Text(
                                      'Hauteur du palpeur outil Z :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02Config.Palpeur!.Height
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!
                                            .Height = double.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: Text(
                                      'Nombre de positions sauvegardées :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: TextFormField(
                                      enabled: false,
                                      textAlign: TextAlign.end,
                                      initialValue: global
                                          .MyMachineN02ConfigDeflaut
                                          .SetPosAffichage!
                                          .toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02ConfigDeflaut
                                                .SetPosAffichage =
                                            int.tryParse(text)!;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          gapPadding: 5.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: Text(
                                      'Plateau chauffant:',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                      value: _hasHeatbed,
                                      activeColor: Color(0xFF20917F),
                                      inactiveThumbColor:
                                          Color.fromARGB(255, 15, 19, 18),
                                      inactiveTrackColor:
                                          Color.fromARGB(255, 237, 237, 237),
                                      thumbIcon: thumbIcon,
                                      onChanged: ((value) {
                                        setState(() {
                                          _hasHeatbed = value;
                                          if (_hasHeatbed)
                                            global.MyMachineN02Config
                                                .HasHeatBed = 1;
                                          else
                                            global.MyMachineN02Config
                                                .HasHeatBed = 0;
                                        });
                                      }))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: Text(
                                      'Ventilateur Caisson',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                      value: _hasFanOnEnclosure,
                                      thumbIcon: thumbIcon,
                                      activeColor: Color(0xFF20917F),
                                      inactiveThumbColor:
                                          Color.fromARGB(255, 15, 19, 18),
                                      inactiveTrackColor:
                                          Color.fromARGB(255, 237, 237, 237),
                                      onChanged: ((value) {
                                        setState(() {
                                          _hasFanOnEnclosure = value;
                                          if (_hasFanOnEnclosure)
                                            global.MyMachineN02Config
                                                .HasFanOnEnclosure = 1;
                                          else
                                            global.MyMachineN02Config
                                                .HasFanOnEnclosure = 0;
                                        });
                                      }))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: Text(
                                      'Eclairage Caisson',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                      value: _hasLedOnEnclosure,
                                      thumbIcon: thumbIcon,
                                      activeColor: Color(0xFF20917F),
                                      inactiveThumbColor:
                                          Color.fromARGB(255, 15, 19, 18),
                                      inactiveTrackColor:
                                          Color.fromARGB(255, 237, 237, 237),
                                      onChanged: ((value) {
                                        setState(() {
                                          _hasLedOnEnclosure = value;
                                          if (_hasLedOnEnclosure)
                                            global.MyMachineN02Config
                                                .HasLedOnEnclosure = 1;
                                          else
                                            global.MyMachineN02Config
                                                .HasLedOnEnclosure = 0;
                                        });
                                      }))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: const EdgeInsets.only(right: 15.0),
                                    width: 200,
                                    child: const Text(
                                      'Changeur d\'outil automatique (ATC) ',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                      value: _hasACT,
                                      thumbIcon: thumbIcon,
                                      activeColor: Color(0xFF20917F),
                                      inactiveThumbColor:
                                          Color.fromARGB(255, 15, 19, 18),
                                      inactiveTrackColor:
                                          Color.fromARGB(255, 237, 237, 237),
                                      onChanged: ((value) {
                                        setState(() {
                                          _hasACT = value;
                                          if (_hasACT)
                                            global.MyMachineN02Config.HasACT =
                                                1;
                                          else
                                            global.MyMachineN02Config.HasACT =
                                                0;
                                        });
                                      }))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Window(
                        title1: "Paramêtres",
                        title2: " avancés",
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: const Text(
                                    'Coordonnées X du magasin :',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    enabled: global.AdminLogged == true
                                        ? true
                                        : false,
                                    initialValue: global.MyMachineN02Config
                                            .MagasinOutil![0].CoordX
                                            ?.toString() ??
                                        "0",
                                    onChanged: (text) {
                                      global.MyMachineN02Config.MagasinOutil?[0]
                                          .CoordX = double.tryParse(text)!;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        gapPadding: 5.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: const Text(
                                    'Coordonnées Y du magasin :',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    enabled: global.AdminLogged == true
                                        ? true
                                        : false,
                                    initialValue: global.MyMachineN02Config
                                            .MagasinOutil![0].CoordY
                                            ?.toString() ??
                                        "0",
                                    onChanged: (text) {
                                      global.MyMachineN02Config.MagasinOutil?[0]
                                          .CoordY = double.tryParse(text)!;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        gapPadding: 5.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: const Text(
                                    'Coordonnées Z du magasin :',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    enabled: global.AdminLogged == true
                                        ? true
                                        : false,
                                    initialValue: global.MyMachineN02Config
                                            .MagasinOutil![0].CoordZ
                                            ?.toString() ??
                                        "0",
                                    onChanged: (text) {
                                      global.MyMachineN02Config.MagasinOutil?[0]
                                          .CoordZ = double.tryParse(text)!;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        gapPadding: 5.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: const Text(
                                    'Espace entre chaque outil :',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: TextFormField(
                                    textAlign: TextAlign.end,
                                    enabled: global.AdminLogged == true
                                        ? true
                                        : false,
                                    initialValue: global.MyMachineN02Config
                                            .MagasinOutil![0].Ecartement
                                            ?.toString() ??
                                        "0",
                                    onChanged: (text) {
                                      global.MyMachineN02Config.MagasinOutil?[0]
                                          .Ecartement = double.tryParse(text)!;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        gapPadding: 5.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: const Text(
                                    " mm",
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: global.AdminLogged? ElevatedButton(onPressed: (){
                                setState(() {
                                  global.MyMachineN02Config.MagasinOutil?[0].CoordX = global.machineObjectModel.result?.move?.axes?[0].machinePosition?.toDouble()??0;
                                  global.MyMachineN02Config.MagasinOutil?[0].CoordY = global.machineObjectModel.result?.move?.axes?[1].machinePosition?.toDouble()??0;
                                  global.MyMachineN02Config.MagasinOutil?[0].CoordZ = global.machineObjectModel.result?.move?.axes?[2].machinePosition?.toDouble()??0;
                                });
                              },child: Text("Charger position actuelle")):Container(),
                            ), 
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 1,
                child: NeumorphicButton(
                  onPressed: () {
                    saveConfig();
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Config sauvée'),
                          duration: const Duration(milliseconds: 700),
                        ),
                      );
                    });
                  },
                  child: Text('Save Config'),
                ))
          ],
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
