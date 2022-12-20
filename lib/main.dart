@JS()
library app.js;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util';

import 'package:js/js.dart';
import 'package:nweb/operation.dart';
import 'side_menu.dart';

import 'dashboard.dart';
import 'conversationel.dart';
import 'programmeScreen.dart';
import 'parametreScreen.dart';
var user = js.JsObject.fromBrowserObject(js.context['bool_connect']);

@JS('connect')
external connect();

@JS('disconectEvent')
external disconectEvent();

@JS('readLoop')
external readLoop();

bool serialConnected = false;
int pageToShow = 2;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  String _counter = "";

  PageController page = PageController();

  double height = 0;
  double width = 0;

  StreamController<String> controller = StreamController<String>();

  @protected
  @mustCallSuper
  void initState() {
    serialConnected = false;
    controller.stream.listen((event) {
      _counter = event;
      print('Value from controleur : $event');
      setState(() {});
    });
  }

  void _sendAnything() {
    setState(() {
      js.context.callMethod('writeToStream', ['M92']);
    });
  }

  void _sendAnything2() {
    setState(() {
      js.context.callMethod('writeToStream', ['M155 S0']);
    });
  }

  Future<void> _connectToSerial() async {
    Future<String> threeFuture = promiseToFuture(connect());
    final three = await threeFuture;
    print(three);
    readLoopDart();
    if (three == 'connected') {
      actualiserProgress();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Connecté')));
      serialConnected = true;
      setState(() {});
    }
  }

  void _disconectEventDart() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('déconnecté')));
    serialConnected = false;
  }

  Future<void> actualiserProgress() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      var object = js.context.callMethod('getBoolConnect');
      print(object.toString() + 'object');
      if (object.toString() == 'false') _disconectEventDart();
      if (this.mounted) setState(() {});
    });
  }

  Future<void> readLoopDart() async {
    final Future<String> threeFuture = promiseToFuture(readLoop());
    final three = await threeFuture;
    //print('from flutter ' + three);
    controller.add(three);
    callreadLoopDart();
  }

  void callreadLoopDart() {
    //print('callreadLoopDart');
    readLoopDart();
  }

  void _disconect() {
    print('Try to disconect');
  }



  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      //drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFFF0F0F3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(flex: 2,child: Container(child: Image(image: AssetImage('iconnaxe.png')))),
            Flexible(flex:10,child: Container(child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Text(widget.title,style: TextStyle(color: Color(0xFF707585)),),
                SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: serialConnected ? Text('Connecté') : Text('Déonnecté'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        serialConnected ? Colors.greenAccent : Colors.redAccent),
                    onPressed: () {
                      if (!serialConnected)
                        _connectToSerial();
                      else
                        _disconect();
                    },
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
                child: SideMenu(onAnyTap: (){
                  setState(() {

                });},),
              ),
            ),
            Flexible(
              flex: 10,
              child: pageToShow == 1 ? Dashboard():pageToShow==2? Conversationel():pageToShow==3? ProgrammeScreen():pageToShow==4? ParametreScreen():Center(child: Text('Start Page')),
            ),
          ],
        ),
      ),
    );
  }
}


