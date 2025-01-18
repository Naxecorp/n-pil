import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nweb/screen/conversationel_screen.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:nweb/service/outils.dart';
import 'screen/admin_screen.dart';
import 'screen/dashboard_screen.dart';
import 'screen/editor_screen.dart';
import 'screen/job_screen.dart';
import 'screen/origin_screen.dart';
import 'screen/parametre_screen.dart';
import 'screen/programme_screen.dart';
import 'screen/set_pos.dart';
import 'service/API/API_Manager.dart';
import 'globals_var.dart' as global;
import 'package:http/http.dart' as http;
import 'screen/screens.dart';

int pageToShow = 1;

final TextEditingController controllerForTerminal = TextEditingController();

// Fonction qui actualise l'ObjectModel
Future<void> actualiserMachineObjectModel() async {
  Timer.periodic(Duration(milliseconds: 600), (timer) {
    API_Manager().getdataMachineObjectModel().then((machine) {
      global.machineObjectModel = machine;
      global.controllerMachineObjectModel.add(machine);
      if(global.machineObjectModel.result?.job?.filePosition?.toInt()!=null)global.cursorNotifier.value=global.machineObjectModel.result?.job?.filePosition?.toInt()??0;
    });
  });
}

// Fonctions qui actualise le temps d'utilisation de la machine
Future<void> actualiserMachineUsedTime() async {
  await API_Manager().sendGcodeCommand(
      "M905 P${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} S${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
  Timer.periodic(Duration(minutes: 2), (timer) async {
    await API_Manager().downLoadNwcSettings();
    await API_Manager().downLoadToolSettings();
    global.MyMachineN02Config.GlobalMachineUsedTime =
        global.MyMachineN02Config.GlobalMachineUsedTime! + 2;
    await API_Manager().upLoadAFile(
        "0:/sys/nwc-settings.json",
        global.MyMachineN02Config.toJson().length.toString(),
        Uint8List.fromList(
            machineN02ConfigToJson(global.MyMachineN02Config).codeUnits));
    await API_Manager().upLoadAFile(
        "0:/sys/outil-settings.json",
        global.magasinOutil.toJson().length.toString(),
        Uint8List.fromList(outilToJson(global.magasinOutil).codeUnits));
  });
}

Future<void> actualiserMoveObjectModel() async {
  Timer.periodic(const Duration(seconds: 3, milliseconds: 3), (timer) {
    API_Manager()
        .getMachineMoveObjectModel()
        .then((move) => global.objectModelMove = move);
  });
}

void main() async {
  await API_Manager().downLoadNwcSettings().then((value)  {
    if (value.hasAnyNull()){
      var prov = value.Serie;
      global.MyMachineN02Config = global.MyMachineN02ConfigDeflaut;
      global.MyMachineN02Config.Serie = prov;
      global.DefaultConfigWasLoaded = true;

      API_Manager().upLoadAFile(
        "0:/sys/nwc-settings.json",
        global.MyMachineN02Config.toJson().length.toString(),
        Uint8List.fromList(
            machineN02ConfigToJson(global.MyMachineN02Config).codeUnits));
    }
    else
      global.MyMachineN02Config = value;
  }).timeout(Duration(seconds: 5));

  await API_Manager().sendGcodeCommand("M453").then((_) {
    API_Manager()
        .getMachineMode()
        .then((value) => global.machineMode = value)
        .timeout(Duration(seconds: 5));
  });

  await API_Manager()
      .getMachineMoveObjectModel()
      .then((move) => global.objectModelMove = move)
      .timeout(Duration(seconds: 5));

  await API_Manager()
      .getfileList()
      .then((value) => global.ListofGcodeFile = value)
      .timeout(Duration(seconds: 5));

  await API_Manager()
      .getfileListSys()
      .then((value) => global.ListofSysFile = value)
      .timeout(Duration(seconds: 5));

  if ((global.MyMachineN02Config.Serie ?? "NUMSTD") == "DEFAULT") {
  } else
    await API_Manager()
        .pushDataToDb(global.MyMachineN02Config.Serie ?? "NUMSTD", "Start")
        .timeout(Duration(seconds: 5));

  actualiserMachineObjectModel();
  actualiserMoveObjectModel();
  actualiserMachineUsedTime();

  Timer.periodic(const Duration(minutes: 10), (timer) async {
    await API_Manager()
        .pushDataToDb(global.MyMachineN02Config.Serie ?? "NUMSTD", "isAlive")
        .timeout(Duration(seconds: 5));
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => DashboardScreen(
              notifyParent: () {},
            ),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/dashboard': (context) => DashboardScreen(notifyParent: () {}),
        '/conversationel': (context) => ConversationelScreen(),
        '/programmes': (context) => ProgrammeScreen(),
        '/jobStatus': (context) => JobScreen(),
        '/origin': (context) => OriginScreen(notifyParent: () {}),
        '/parameters': (context) => ParametreScreen(),
        '/admin': (context) => AdminScreen(),
        '/editor': (context) => EditorPage(),
        '/setpos': (context) => SetPos(),
      },
      title: 'Naxe N02',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      //home: const MyHomePage(title: 'Version 1.0.2'),
      debugShowCheckedModeBanner: false,
    );
  }
}
