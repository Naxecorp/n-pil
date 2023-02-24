@JS()
library app.js;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util';
import 'package:js/js.dart';

import 'menus/side_menu.dart';
import 'service/API_Manager.dart';
import 'globals_var.dart' as global;
import 'screens.dart';

var user = js.JsObject.fromBrowserObject(js.context['bool_connect']);

@JS('connect')
external connect();

@JS('disconectEvent')
external disconectEvent();

@JS('readLoop')
external readLoop();

bool serialConnected = false;
int pageToShow = 1;

final TextEditingController controllerForTerminal = TextEditingController();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naxe N02',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'RobotoMono'
      ),
      home: const MyHomePage(title: 'Machine atelier 1'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  PageController page = PageController();

  double height = 0;
  double width = 0;

  StreamController<String> controller = StreamController<String>();

  Future<void> actualiserMachineObjectModel() async {
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      API_Manager().getdataMachineObjectModel().then((machine) {
        global.machineObjectModel = machine;
        if (mounted)setState(() {});
        if(global.myEthernet_connection.isConnected==false)timer.cancel();
      });
    });
  }

  Future<void> actualiserMoveObjectModel() async {
    Timer.periodic(const Duration(seconds: 5,milliseconds: 3), (timer) {
      API_Manager().getMachineMoveObjectModel().then((move) => global.objectModelMove = move);
        if (mounted)setState(() {});
        if(global.myEthernet_connection.isConnected==false)timer.cancel();
    });
  }

  Future<void> actualiserMoveObjectModelOneSec() async {
    Future.delayed(const Duration(seconds: 1,milliseconds: 30), () {
      API_Manager().getMachineMoveObjectModel().then((move) => global.objectModelMove = move);
      if (mounted)setState(() {});
      //if(global.myEthernet_connection.isConnected==false)timer.cancel();
    });
  }

  void initState() {
    API_Manager().CORSInit();
    actualiserMachineObjectModel();
    actualiserMoveObjectModel();
    API_Manager().getfileList().then((value) => global.ListofGcodeFile=value);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFFF0F0F3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child:
                    Container(child: Image(image: AssetImage('iconnaxe.png')))),
            Flexible(
                flex: 10,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      widget.title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: global.myEthernet_connection.isConnected==true ? Text('Connecté',style: TextStyle(color: Colors.white),)
                            : Text('Déconnecté'),
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.green,
                            backgroundColor: global.myEthernet_connection.isConnected==true ? Colors.greenAccent : Colors.redAccent),
                        onPressed: global.myEthernet_connection.isConnected==false ? () {
                          actualiserMachineObjectModel();
                          actualiserMoveObjectModel();
                          /*
                          if (!serialConnected)
                            _connectToSerial();
                          else
                            _disconect();*/}:null,
                      ),
                    ),

                  ],
                ))),
          ],
        ),
      ),
      body: Container(
        //color: Color(0xFFF0F0F3),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10),
                child: SideMenu(
                  onAnyTap: () {
                    setState(() {
                      print("hahaha");
                    });
                  },
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: pageToShow == 1
                  ? DashboardScreen(
                      notifyParent: () {
                        setState(() {});
                        print(offsetSelected);
                      },
                    )
                  : pageToShow == 2
                      ? ConversationelScreen()
                      : pageToShow == 3
                          ? ProgrammeScreen()
                          : pageToShow == 4
                              ? ParametreScreen()
                              : pageToShow == 5
                                  ? ParametreScreen()
                                  : Center(child: Text('Start Page')),
            ),
          ],
        ),
      ),
    );
  }
}
