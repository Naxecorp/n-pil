import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings.dart';
import 'menus/side_menu.dart';
import 'widgetUtils/ArretUrgence.dart';
import 'menus/family_menu.dart';
import 'familleviewer.dart';
import 'menus/bottomMenu.dart';
import 'OpeListView.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'widgetUtils/window.dart';
import 'dashBoardWidgets/dashboardWidgets.dart';
import 'globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';

bool viewListOfOperation = true;
String opeToShow = 'none';
String FamillyToShow = 'classique';
String bottomMenuToShow = 'Menu1';
int OpeSelected = 0;
TextEditingController ManualGcodeComand = TextEditingController();
BottomMenu myBottomMenu =  BottomMenu();

class GlobalAppBar extends StatefulWidget {
  @override
  State<GlobalAppBar> createState() => GlobalAppBarState();
}

class GlobalAppBarState extends State<GlobalAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Color(0xFF20917F)),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 300,
                        //margin: EdgeInsets.all(40),
                        child: TextField(
                          controller: ManualGcodeComand,
                          decoration: InputDecoration(
                            hintText: "Gcode",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                              gapPadding: 5.0,
                            ),),
                          onSubmitted: (Commande){
                            setState(() {
                              ManualGcodeComand.clear();
                              API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                            });
                            print(Commande);
                          },),
                      ),
                      Spacer(),
                      Text(
                        global.DefaultTitle,
                        style: TextStyle(color: Color(0xFF707585)),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}




class ConversationelScreen extends StatefulWidget {
  @override
  State<ConversationelScreen> createState() => ConversationelScreenState();
}

class ConversationelScreenState extends State<ConversationelScreen> {
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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
      body: AnimatedContainer(
        duration:  Duration(seconds: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            viewListOfOperation
                ? Flexible(
                    flex: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              //color: Colors.green,
                              child: FamilyMenu(
                                onAnyTap: () {
                                  setState(() {
                                    opeToShow = 'none';
                                  });
                                  print('tap');
                                },
                              ),
                            )),
                        Expanded(
                            flex: 10,
                            child: Container(
                              //color: Colors.yellow,
                              child: Column(
                                children: [
                                   Expanded(flex: 8, child: FamilleWiewer()),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )
                : Flexible(
                    flex: 20,
                    child: OpeListView(
                      onAnyTap: () {
                        setState(() {});
                      },
                    )),
            Flexible(
              flex: 5,
              child: Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 5,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: BottomMenu(
                              onAnyTap: () {
                                setState(() {
                                  print(bottomMenuToShow);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      child: ArretUrgence(
                        notifyParent: () {
                          setState(() {});
                        },
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




List<String> ProgramCurrent = <String>[];

TextEditingController controller = TextEditingController();

class ProgrammeScreen extends StatefulWidget {
  @override
  State<ProgrammeScreen> createState() => ProgrammeScreenState();
}

class ProgrammeScreenState extends State<ProgrammeScreen>
    with TickerProviderStateMixin {


  late AnimationController ProgressBarcontroller;
  bool isLoading = false;

  void downloadFile(String urlBase, String FileName) {
    html.AnchorElement anchorElement =
        html.AnchorElement(href: urlBase + FileName);
    anchorElement.download = 'test.gcode';
    anchorElement.click();
  }

  @override
  void initState() {
    ProgressBarcontroller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration:  Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    ProgressBarcontroller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    ProgressBarcontroller.dispose();
    super.dispose();
  }

  var selectedGcodeFileIndex = 0;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      isLoading = false;
      return;
    }
    //Uint8List? fileBytes = result.files.first.bytes;
    setState(() {
      isLoading = true;
    });
    API_Manager().upLoadAFile("0:/gcodes/" + result.files.first.name.toString(), result.files.first.bytes!.length.toString(), result.files.first.bytes!).then((notused) {
      API_Manager().getfileList().then((value) => global.ListofGcodeFile = value);
      setState(() {
        isLoading = false;
      });
    });
  }

  void StartProgPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Êtes vous sûr?"),
          content: Text("Programme sélectionné : ${(ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name.toString())}"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Non"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Set la position actuel a '0' puis démarre le programme"),
              onPressed: () async {
                  await API_Manager()
                      .sendGcodeCommand("G10 L20 P1 X0 Y0 Z0");
                  await API_Manager().sendGcodeCommand("G10 L20 P1");

                  await API_Manager().sendGcodeCommand('M32 "0:/gcodes/' +
                      ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name
                          .toString() + '"');
                  await API_Manager().sendGcodeCommand('M106 P3 S255');
                  progName =
                      ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name
                          .toString();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/jobStatus');
              }
            ),
            ElevatedButton(
              child: Text("Démarrer"),
              onPressed: () async {
                await API_Manager().sendGcodeCommand('M32 "0:/gcodes/' +
                    ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name
                        .toString() + '"');
                await API_Manager().sendGcodeCommand('M106 P3 S255');
                progName =
                    ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name
                        .toString();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/jobStatus');
              },
            ),
          ],
        );
      },
    );
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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
      body: Row(
        children: [
          Flexible(
              flex: 1,
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Container(
                  //color: Colors.redAccent.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding:  EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child:  Text('Charger depuis PC'),
                            onPressed: () {
                              isLoading = true;
                              _pickFile();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF2B879B)),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding:  EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child:  Text('Charger depuis Liste Conversationel'),
                            onPressed: null,
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 19,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          padding:  EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child:  Text('Télécharger Programme'),
                            onPressed: () {
                              downloadFile(
                                  "http://${global.MyMachineN02Config.IP}/rr_download?name=0:/gcodes/",
                                  ListofGcodeFile!
                                      .elementAt(selectedGcodeFileIndex)!
                                      .name
                                      .toString());
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          padding:  EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child:  Text('Supprimer Programme'),
                            onPressed: () {
                              print(ListofGcodeFile?.elementAt(
                                      selectedGcodeFileIndex)
                                  ?.name
                                  .toString());
                              API_Manager()
                                  .deleteAFile(ListofGcodeFile!
                                      .elementAt(selectedGcodeFileIndex)!
                                      .name
                                      .toString(),"gcodes")
                                  .then((_) {
                                API_Manager().getfileList().then((value) {
                                  global.ListofGcodeFile = value;
                                  setState(() {});
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF9B2B2B)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Flexible(
              flex: 3,
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Container(
                            height: double.infinity,
                            margin:  EdgeInsets.all(20),
                            child:  FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text("Liste des programmes: ")))),
                    Flexible(
                        flex: 1,
                        child: isLoading
                            ? Container(
                                height: double.infinity,
                                child:  LinearProgressIndicator())
                            : Container(
                                height: double.infinity,
                              )),
                    Flexible(
                      flex: 45,
                      child: Container(
                        child: ListView.builder(
                          itemCount: ListofGcodeFile?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                tileColor: Colors.white,
                                selectedColor: Colors.orange,
                                selectedTileColor: Colors.black26,
                                selected: index == selectedGcodeFileIndex,
                                onTap: () {
                                  setState(() {
                                    selectedGcodeFileIndex = index;
                                  });
                                  //return _onAnyTap!();
                                },
                                leading:  Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.blue,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ListofGcodeFile!
                                          .elementAt(index)!
                                          .name
                                          .toString(),
                                      style:  TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      (ListofGcodeFile!
                                              .elementAt(index)!
                                              .size
                                              .toString() +
                                          " Octets"),
                                      style:  TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Flexible(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex :4,
                      child: Container(
                        margin:  EdgeInsets.symmetric(vertical: 5),
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26, width: 1),
                            borderRadius:
                                 BorderRadius.all(Radius.circular(10))),
                        child:  Center(
                            child: Container()),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                          padding:  EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:  Color(0xFF2B879B)),
                                  onPressed: null,
                                  child:  SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        'Visualiser',
                                        textAlign: TextAlign.center,
                                      )))),
                               Spacer(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:  Color(0xFF2B9B80)),
                                  onPressed: global.machineObjectModel.result
                                              ?.state?.status ==
                                          "idle"
                                      ? () {
                                    StartProgPopup(context);
                                        }
                                      : null,
                                  child:  SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        'Démarrrer',
                                        textAlign: TextAlign.center,
                                      )))),
                            ],
                          ),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}






int offsetSelected = 54;

class DashboardScreen extends StatefulWidget {
   DashboardScreen({super.key, required this.notifyParent});

  final VoidCallback notifyParent;

  @override
  State<DashboardScreen> createState() => DashboardScreenState(notifyParent);
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardScreenState(this.notifyParent);

  final Function() notifyParent;

  @override
  void initState ()
  {
    global.streamMachineObjectModel.listen((value) {
      setState(() {

      });
    });
  }

  void loadingPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche la fermeture de la boîte de dialogue en cliquant en dehors d'elle
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Redémarrage en cours"),
          content: CircularProgressIndicator(), // Ajoute une animation de chargement (cercle tournant)
          actions: <Widget>[
          ],
        );
      },
    );
  Timer(Duration(seconds: 12), () {
  Navigator.of(context).pop(); // Ferme la boîte de dialogue
  });
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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                        Spacer(),
                        ElevatedButton(onPressed:global.machineObjectModel.result?.state?.status?.toString()=="halted"?(){
                          API_Manager().sendGcodeCommand("M999");
                          loadingPopup(context);
                        }:null
                            , child: Text("Aquiter AU"))
                      ],
                    ))),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Row(
                children: [
                  Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      child:  Window(
                                        title1: "Position ",
                                        title2: " machine",
                                        child: CoordoneesMachine(),
                                      ),
                                    )),
                                Flexible(
                                    flex: 2,
                                    child: Container(
                                      child:  Window(
                                        title1: "Position ",
                                        title2: " outil",
                                        child: CoordoneesOutil(),
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
                                  child: Window(
                                    title1: "Info ",
                                    title2: " System",
                                    child: InfoSystem(),
                                  ),
                                ),
                                 Flexible(
                                  flex: 1,
                                  child: Window(
                                    title1: "Mode",
                                    title2: " machine",
                                    child: ModeMachine(),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Window(
                                    title1: "Info. ",
                                    title2: " Outil",
                                    child: global.machineMode == MachineMode.cnc
                                        ?  SpindleSpeed()
                                        : global.machineMode == MachineMode.fff
                                            ?  PrintToolsTemperature()
                                            : global.machineMode ==
                                                    MachineMode.laser
                                                ?  LaserToolPower()
                                                : Container(
                                                    child:  Text(
                                                        "Pas d'outils détectés"),
                                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 3,
                      child: Window(
                        title1: "Déplacement ",
                        title2: " machine",
                        child: DeplacementMachine(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class ParametreScreen extends StatefulWidget {
  @override
  State<ParametreScreen> createState() => ParametreScreenState();
}

class ParametreScreenState extends State<ParametreScreen> {
  final TextEditingController _controllers = TextEditingController();

  @override
  initState() {
    super.initState();
    onReceivedData();
  }

  void saveConfig()
  {

  global.MyMachineN02Config.Lastmodifition = DateTime.now().toString();
    API_Manager()
        .upLoadAFile(
        "0:/sys/nwc-settings.json",
        global.MyMachineN02Config.toJson().length.toString(),
        Uint8List.fromList(machineN02ConfigToJson(global.MyMachineN02Config).codeUnits));
      print(machineN02ConfigToJson(global.MyMachineN02Config));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF0F0F3),
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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                      ],
                    ))),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Window(
                          title1: "Paramêtres",
                          title2: " généraux",
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 500,
                                    child:  Text(
                                      "Temps d'utilisation global : ${Duration(minutes: global.MyMachineN02Config.GlobalMachineUsedTime!).inDays}:${Duration(minutes: global.MyMachineN02Config.GlobalMachineUsedTime!).inHours}:${Duration(minutes: global.MyMachineN02Config.GlobalMachineUsedTime!).inMinutes}",
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
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
                          title2: " machine",
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child:  Text(
                                      'Coordonées du palpeur outil X  :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global.MyMachineN02Config.Palpeur!.PosX.toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!.PosX = double.tryParse(text)!;
                                      },
                                      decoration:  InputDecoration(
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
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child:  Text(
                                      'Coordonées du palpeur outil Y  :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global.MyMachineN02Config.Palpeur!.PosY.toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!.PosY = double.tryParse(text)!;
                                      },
                                      decoration:  InputDecoration(
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
                              Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child:  Text(
                                      'Hauteur du palpeur outil Z  :',
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                    child: TextFormField(
                                      textAlign: TextAlign.end,
                                      initialValue: global.MyMachineN02Config.Palpeur!.Height.toString(),
                                      onChanged: (text) {
                                        global.MyMachineN02Config.Palpeur!.Height = double.tryParse(text)!;
                                      },
                                      decoration:  InputDecoration(
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
                        ),
                      )),
                ],
              ),
            ),
            Flexible(flex:1,
                child: NeumorphicButton(
                  onPressed: (){
                    saveConfig();
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

  void actualiser(){

  }

  @override
  void initState() {
    super.initState();

    global.streamMachineObjectModel.listen((value) {setState(() {});});

    sliderValue = global.machineObjectModel.result?.spindles?[0].current ?? 24000;
    sliderValue = sliderValue / 24000;
    sliderValueSpeedFactor = global.objectModelMove.result?.speedFactor??2;
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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                      ],
                    ))),
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
                            margin:  EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              //color: Colors.white,
                                border:
                                Border.all(width: 1, color: Colors.black38),
                                borderRadius: BorderRadius.circular(10)),
                            child:  Center(
                              child: Text("Visualisation bientôt disponible"),
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            margin:  EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                //color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius: BorderRadius.circular(10)),
                            child:  Center(
                              child: Text("Visualisation bientôt disponible"),
                            ),
                          )),
                    ],
                  ),
                )),
            Flexible(
                flex: 6,
                child: Container(
                  //color: Colors.green,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 6,
                        child: Column(
                          children: [
                            Flexible(flex:1,
                                child: JobInfo()),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  //color: Colors.white,
                                  margin:  EdgeInsets.all(0),
                                  child: Window(
                                    title1: "Capteurs",
                                    title2: " machine",
                                    child: Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin:  EdgeInsets.all(1),
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
                                                      global
                                                              .machineObjectModel
                                                              .result
                                                              ?.state
                                                              ?.status
                                                              .toString() ??
                                                          "???",
                                                      style:  TextStyle(
                                                          color:
                                                              Color(0xFF707585))),
                                                ],
                                              ),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin:  EdgeInsets.all(1),
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
                                                          style:  TextStyle(
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
                                              margin:  EdgeInsets.all(1),
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
                                                        style:  TextStyle(
                                                            color: Color(
                                                                0xFF707585)),
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
                                              margin:  EdgeInsets.all(1),
                                              //color: Colors.green,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                   Text(
                                                    "Vin",
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
                                                                  .vIn
                                                                  ?.current
                                                                  ?.toStringAsFixed(
                                                                      1) ??
                                                              "...",
                                                          style:  TextStyle(
                                                              color: Color(
                                                                  0xFF707585))),
                                                       Text(" V",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF707585))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  //color: Colors.white,
                                  margin:  EdgeInsets.all(0),
                                  child:  Window(
                                    title1: "Coordonées",
                                    title2: " machine",
                                    child: CoordoneesMachine(),
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  //color: Colors.white,
                                  margin:  EdgeInsets.all(0),
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
                                            child: Center(child: Text("${global.machineObjectModel.result?.move?.currentMove?.requestedSpeed.toString() ?? "..."} mm/s")),
                                          )),
                                    ],
                                  ),
                                )),
                            Flexible(
                                flex: 2,
                                child: Container(
                                  height: double.infinity,
                                  //color: Colors.white,
                                  margin:  EdgeInsets.all(0),
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
                                          )),
                                      Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: VitesseBroche(),
                                          ))
                                    ],
                                  ),
                                )),

                          ],
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          child: Padding(
                            padding:  EdgeInsets.only(left: 50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding:  EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String tempStatus = global.machineObjectModel.result?.state?.status.toString()?? "";
                                        if (tempStatus == "paused") {
                                          await API_Manager().sendGcodeCommand("M3 P0 S$SpindleSpeedBeforePause");
                                          API_Manager().sendGcodeCommand("M24");
                                        } else {
                                          SpindleSpeedBeforePause = global.machineObjectModel.result?.spindles?[0]?.current;
                                          API_Manager().sendGcodeCommand("M5");
                                          API_Manager().sendGcodeCommand("M25");
                                        }
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:  Color(0xFF2B519B)),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              margin:  EdgeInsets.symmetric(
                                                  vertical: 10),
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: global.machineObjectModel.result?.state?.status.toString() == "paused"
                                                      ? Colors.orange
                                                      : Colors.grey,
                                                  borderRadius:  BorderRadius.all(
                                                      Radius.circular(20))),
                                            ),
                                          ),
                                           Flexible(
                                              flex: 20,
                                              child: Padding(
                                                padding:
                                                EdgeInsets.all(8.0),
                                                child: Text('Pause Cycle'),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding:  EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      onPressed:
                                      global.machineObjectModel.result?.state?.status.toString() == "paused" ? () {
                                        API_Manager().sendGcodeCommand("M0");
                                        API_Manager().sendGcodeCommand("M106 P3 S0");

                                      }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:  Color(0xFFCE711A)),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              margin:  EdgeInsets.symmetric(
                                                  vertical: 10),
                                              height: double.infinity,
                                              decoration:  BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20))),
                                            ),
                                          ),
                                           Flexible(
                                              flex: 20,
                                              child: Padding(
                                                padding:
                                                EdgeInsets.all(8.0),
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
                                    )),
                              ],
                            ),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}



class OriginScreen extends StatefulWidget {
   OriginScreen({super.key, required this.notifyParent});

  final VoidCallback notifyParent;

  @override
  State<OriginScreen> createState() => OriginScreenState(notifyParent);
}

class OriginScreenState extends State<OriginScreen> {
  OriginScreenState(this.notifyParent);

  final Function() notifyParent;
  
  double ZSaved = 0;

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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
      body: Container(
        margin:  EdgeInsets.all(10),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                child: Window(
                  title1: "Changement d'outil",
                  title2: " manuel",
                  child: Column(
                    children: [
                      Flexible(
                          flex: 3,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            //height: double.infinity,
                            width: double.infinity,
                            //color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin:  EdgeInsets.all(15),
                                    style:  NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager().sendGcodeCommand("G53 G1 Z189").then((value) => API_Manager().sendGcodeCommand("G53 G1 X${global.MyMachineN02Config.Palpeur!.PosX} Y${global.MyMachineN02Config.Palpeur!.PosY}"));
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                           Icon(
                                            Icons.arrow_right,
                                            color: Color(0xFF707585),
                                          ),
                                           FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Vers palpeur',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin:  EdgeInsets.all(15),
                                    style:  NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager().sendGcodeCommand("M106 P3 S255").then((value) => API_Manager().sendGcodeCommand("G38.2 Z-200").then((value) => API_Manager().sendGcodeCommand("M106 P3 S0")));
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                           Icon(
                                            Icons.get_app,
                                            color: Color(0xFF707585),
                                          ),
                                           FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Palper outil actuel',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin:  EdgeInsets.all(15),
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      ZSaved = global.machineObjectModel.result!.move!.axes![2].userPosition!;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                       content: const Text('Hauteur Enregistrée'),
                                       duration: const Duration(milliseconds: 400),
                                       ),
                                      );
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.save_outlined,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Enregistrer hauteur',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                          flex: 2,
                          child: Container(
                            //color: Colors.orange,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: NeumorphicButton(
                                    margin: const EdgeInsets.all(15),
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager().sendGcodeCommand("G53 G1 Z189 F2000");
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
                                                "Changer d'outil",
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
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager().sendGcodeCommand("M106 P3 S255").then((value) => API_Manager().sendGcodeCommand("G38.2 Z-200").then((value) => API_Manager().sendGcodeCommand("M106 P3 S0")));
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.get_app,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Palper outil',
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
                                    style: const NeumorphicStyle(
                                      color: Color(0xFFF0F0F3),
                                    ),
                                    onPressed: () {
                                      API_Manager().sendGcodeCommand("G10 L20 P1 Z"+ZSaved.toStringAsFixed(2)).then((value) => API_Manager().sendGcodeCommand("G54"));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Hauteur Enregistrée'),
                                          duration: const Duration(milliseconds: 400),
                                        ),
                                      );
                                      API_Manager().sendGcodeCommand("G91\nG1 Z50 F3700\nG90\n");


                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(
                                            Icons.height,
                                            color: Color(0xFF707585),
                                          ),
                                          const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                'Restituer hauteur outil',
                                                style: TextStyle(
                                                    color: Color(0xFF707585)),
                                              ))
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 3,
                          child: Container(
                            height: double.infinity,
                          )),
                    ],
                  ),
                )),
            const Flexible(
                flex: 1,
                child: Window(
                  title1: "Changement d'outil",
                  title2: " automatique",
                  child: Center(
                    child: Text("Bientôt disponible"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}





class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen>
    with TickerProviderStateMixin {
  late AnimationController ProgressBarcontroller;
  bool isLoading = false;

  void downloadFile(String urlBase, String FileName) {
    // html.AnchorElement anchorElement =
    // html.AnchorElement(href: urlBase + FileName);
    // anchorElement.download = 'test.gcode';
    // anchorElement.click();
  }

  final _formKey2 = const Key('__RIKEY1__');
  void AdminModeLogger ()
  {
    TextEditingController MDP = new TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text("Mot de passe"),
            content: Stack(
              //overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          controller: MDP,
                          onFieldSubmitted: (value){
                            if(MDP.text==global.pwd){
                              global.AdminLogged=true;
                              global.Title="ADMIN MODE | $version";
                              Navigator.pop(context, '/admin');
                            }

                          },),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Connecter"),
                          onPressed: () {
                            if(MDP.text==global.pwd){
                              global.AdminLogged=true;
                              global.Title="ADMIN MODE | $version";
                              Navigator.pop(context, '/admin');
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Dashboard"),
                          style:  ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey,foregroundColor: Colors.black),
                          onPressed: () {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }



  @override
  void initState() {
    if (!global.AdminLogged){
      Future.delayed(Duration(milliseconds: 500), (){
        AdminModeLogger();
      });
    }
    ProgressBarcontroller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration:  Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    ProgressBarcontroller.repeat(reverse: false);
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    ProgressBarcontroller.dispose();
    super.dispose();
  }

  var selectedFileIndex = 0;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      isLoading = false;
      return;
    }
    //Uint8List? fileBytes = result.files.first.bytes;
    setState(() {
      isLoading = true;
    });
    API_Manager()
        .upLoadAFile(
        "0:/sys/" + result.files.first.name.toString(),
        result.files.first.bytes!.length.toString(),
        result.files.first.bytes!)
        .then((notused) {
      API_Manager()
          .getfileListSys()
          .then((value) => global.ListofSysFile = value);
      setState(() {
        isLoading = false;
      });
    });
  }

  bool containsSpecialCharacters(String text) {
    final RegExp specialCharacters = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(text);
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
                child:
                Container(child: Image(image: AssetImage('iconnaxe.png')))),
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
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),),
                            onSubmitted: (Commande){
                              setState(() {
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then((value) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response)));
                              });
                              print(Commande);
                            },),
                        ),
                        Spacer(),
                        Text(
                          global.Title,
                          style: TextStyle(color: Color(0xFF707585)),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
      body: Row(
        children: [
          Flexible(
              flex: 10,
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Container(
                  //color: Colors.redAccent.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding:  EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child:  Text('Charger depuis PC'),
                            onPressed: () {
                              if(global.AdminLogged){
                                isLoading = true;
                                _pickFile();
                              }
                              else null;
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF2B879B)),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 19,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child: Text('Télécharger Programme'),
                            onPressed: () {
                              if (global.AdminLogged) {
                                String fileName = ListofSysFile!.elementAt(selectedFileIndex)!.name.toString();
                                if (!containsSpecialCharacters(fileName)) {
                                  downloadFile("http://${global.MyMachineN02Config.IP}/rr_download?name=0:/sys/", fileName);
                                } else {
                                  // Afficher une erreur ou prendre une action en cas de caractères spéciaux
                                  // par exemple, afficher une boîte de dialogue
                                  showDialog(
                                    context: context, // Remplacez 'context' par votre contexte réel
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Erreur'),
                                        content: Text('Le nom de fichier contient des caractères spéciaux.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          padding:  EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child:  Text('Supprimer Programme'),
                            onPressed: () {
                              setState(() {

                              });
                              if(global.AdminLogged)
                                {
                                  API_Manager().deleteAFile(ListofSysFile!.elementAt(selectedFileIndex)!.name.toString(),"sys").then((_) {
                                    API_Manager().getfileListSys().then((value) {
                                      global.ListofSysFile = value;
                                      setState(() {});
                                    });
                                  });
                                }
                              else null;
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF9B2B2B)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Flexible(
              flex: 40,
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Container(
                            height: double.infinity,
                            margin:  EdgeInsets.all(20),
                            child:  FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text("Liste des fichiers systems: ")))),
                    Flexible(
                        flex: 1,
                        child: isLoading
                            ? Container(
                            height: double.infinity,
                            child:  LinearProgressIndicator())
                            : Container(
                          height: double.infinity,
                        )),
                    Flexible(
                      flex: 45,
                      child: Container(
                        child: ListView.builder(
                          itemCount: ListofSysFile?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                tileColor: Colors.white,
                                selectedColor: Colors.orange,
                                selectedTileColor: Colors.black26,
                                selected: index == selectedFileIndex,
                                onTap: () {
                                  setState(() {
                                    selectedFileIndex = index;
                                    global.selectedFileSysIndex = index;
                                    print(index);
                                  });
                                  //return _onAnyTap!();
                                },
                                leading:  Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.blue,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ListofSysFile!
                                          .elementAt(index)!
                                          .name
                                          .toString(),
                                      style:  TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      (ListofSysFile!
                                          .elementAt(index)!
                                          .size
                                          .toString() +
                                          " Octets"),
                                      style:  TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Flexible(
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 80,
                    child: Container(
                      margin:  EdgeInsets.symmetric(vertical: 5),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26, width: 1),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                      child:  ListView.builder(
                        itemCount: ReplyList?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              tileColor: ReplyList.elementAt(index).contains("Error")?Colors.redAccent:ReplyList.elementAt(index).contains("Warning")?Colors.yellowAccent:Colors.white,
                              leading:  Icon(
                                Icons.arrow_right,
                                color: Colors.blue,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit : BoxFit.contain,
                                    child: Container(
                                      width: 400,
                                      child: Text(
                                        overflow: TextOverflow.visible,
                                        ReplyList!.elementAt(index)!,
                                        style:  TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: (){
                            if(global.AdminLogged){
                              setState(() {
                                global.ReplyList.clear();
                              });
                            }
                            else null;

                          },child: Text("clear"),),
                          ElevatedButton(onPressed: (){
                            if(global.AdminLogged)
                              {
                                setState(() {
                                  global.AdminLogged=false;
                                  global.Title=global.DefaultTitle;
                                  Navigator.pushNamed(context, '/admin');
                                });
                              }
                            else null;

                          },child: Text("Logout"),),
                          ElevatedButton(onPressed: () async {
                            if(global.AdminLogged){
                              await API_Manager().downLoadAFile('sys', ListofSysFile!.elementAt(selectedFileIndex)!.name.toString()).then((value) => global.ContentofFileToEdit=value);
                              Navigator.pushNamed(context, '/editor');
                            }
                          },
                            child: Text("Visualiser"),),
                          ElevatedButton(onPressed: () async {
                            if(global.AdminLogged){
                              await API_Manager().sendGcodeCommand('M98 P"config.g"').then((_) => API_Manager().sendrr_reply().then((response) => global.ReplyList.add(response!)));
                            }
                          },
                            child: Text("Run config.g"),),
                        ],
                      ))
                ],
              )),
          Flexible(
              flex: 5,
              child: Container()),
        ],
      ),
    );
  }
}


class EditorPage extends StatelessWidget {
   EditorPage({this.filepath});

  final String? filepath;


 final  List<FileEditor> files = [
    FileEditor(
      name: global.ContentofFileToEdit.substring(1,10),
      language: "g",
      code: global.ContentofFileToEdit, // [code] needs a string
    ),
    FileEditor(
      name: "Page2",
      language: "Gcode",
      code: "machine N02",
    ),
  ];

  @override
  void initState(){

  }
  @override
  Widget build(BuildContext context) {


    // The files displayed in the navigation bar of the editor.
    // You are not limited.
    // By default, [name] = "file.${language ?? 'txt'}", [language] = "text" and [code] = "",


    // The model used by the CodeEditor widget, you need it in order to control it.
    // But, since 1.0.0, the model is not required inside the CodeEditor Widget.
    EditorModel model = EditorModel(
      files: files, // the files created above
      // you can customize the editor as you want
      styleOptions: EditorModelStyleOptions(
        fontSize: 13,
      ),
    );

    // A custom TextEditingController.
    final myController = TextEditingController(text: 'hello!');
    return Scaffold(
      appBar: AppBar(title: Text("Editeur de fichier"),),
      body: SingleChildScrollView(
        child: CodeEditor(
          model: model, // the model created above, not required since 1.0.0
          edit: true, // can edit the files? by default true
          onSubmit: (String? language, String? value) {
            API_Manager().upLoadAFile("0:/sys/" + global.ListofSysFile!.elementAt(global.selectedFileSysIndex)!.name.toString(), ContentofFileToEdit!.length.toString(), Uint8List.fromList(value!.codeUnits));
          },
          disableNavigationbar: false, // hide the navigation bar ? by default false
          textEditingController: myController, // Provide an optional, custom TextEditingController.
        ),
      ),
    );
  }
}

