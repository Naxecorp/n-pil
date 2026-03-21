import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nweb/screen/conversationel_screen.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:nweb/service/outils.dart';
import 'screen/admin_screen.dart';
import 'screen/dashboard_screen.dart';
import 'screen/editor_screen.dart';
import 'screen/job_screen.dart';
import 'screen/level_calibration_screen.dart';
import 'screen/origin_screen.dart';
import 'screen/parametre_screen.dart';
import 'screen/programme_screen.dart';
import 'screen/set_pos.dart';
import 'service/API/API_Manager.dart';
import 'globals_var.dart' as global;
import 'Loading_screen.dart';
import 'Error_screen.dart';

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

Future<String> setDateTimeAndShowAnswer() async {
  await API_Manager().sendGcodeCommand(
      "M905 P${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} S${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
  await API_Manager().sendGcodeCommand("M905");
  return API_Manager().sendrr_reply();
}
  

// Fonctions qui actualise le temps d'utilisation de la machine
Future<void> actualiserMachineUsedTime() async {
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

  runApp(const LoadingScreen(message: "Starting",));
  await Future.delayed(Duration(seconds: 1));

  String dateTime = await setDateTimeAndShowAnswer();
  if (dateTime.contains("Error"))runApp(const ErrorScreen(message: "Could not reach the machine.",));
  else {
runApp(LoadingScreen(message: dateTime,));
  await Future.delayed(Duration(seconds: 3));

  actualiserMachineObjectModel();
  actualiserMoveObjectModel();

  await API_Manager().getdataMachineObjectModel().then((machine) {
      global.machineObjectModel = machine;
      global.controllerMachineObjectModel.add(machine);
      if(global.machineObjectModel.result?.job?.filePosition?.toInt()!=null)global.cursorNotifier.value=global.machineObjectModel.result?.job?.filePosition?.toInt()??0;
    });

if (global.machineObjectModel.result?.state?.status=="processing"){

}
else {
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
  });

  runApp(const LoadingScreen(message: "NWCSetting is loaded",));

  await API_Manager().sendGcodeCommand("M453").then((_) {
    API_Manager()
        .getMachineMode()
        .then((value) => global.machineMode = value);
  });
 
  runApp(const LoadingScreen(message: "Machine mode is loaded",));


  // Actualiser la position du palpeur
    await API_Manager().sendGcodeCommand("set global.CoordPalpeurY = ${global.MyMachineN02Config.Palpeur?.PosY??"0"}").then((_) async {
      await API_Manager().sendGcodeCommand("set global.CoordPalpeurX = ${global.MyMachineN02Config.Palpeur?.PosX??"0"}");
  });

  runApp(const LoadingScreen(message: "Palpeur position is set",));

  await API_Manager()
      .getMachineMoveObjectModel()
      .then((move) => global.objectModelMove = move);

  runApp(const LoadingScreen(message: "Machine OBM is gettable",));
      
  await API_Manager()
      .getfileList()
      .then((value) => global.ListofGcodeFile = value);

  runApp(const LoadingScreen(message: "File List is get",));
      
  await API_Manager()
      .getfileListSys()
      .then((value) => global.ListofSysFile = value);
  
  runApp(const LoadingScreen(message: "File SYS List is get",));
  

  await API_Manager().sendGcodeCommand('M98 P"config.g"');
  runApp(const LoadingScreen(message: "config.g is sent",));

  if ((global.MyMachineN02Config.Serie ?? "NUMSTD") == "DEFAULT") {
  } else
    await API_Manager()
        .pushDataToDb(global.MyMachineN02Config.Serie ?? "NUMSTD", "Start");
  
  actualiserMachineUsedTime();

}
  


  

  Timer.periodic(const Duration(minutes: 10), (timer) async {
    await API_Manager()
        .pushDataToDb(global.MyMachineN02Config.Serie ?? "NUMSTD", global.machineObjectModel.result?.state?.status??"is alive");
  });

  runApp(const LoadingScreen(message: "ENJOY ! :)",));

  await Future.delayed(Duration(seconds: 1));
  
  runApp(const MyApp());
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: global.appNavigatorKey,
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
        '/levelCalibration': (context) => const LevelCalibrationScreen(),
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
