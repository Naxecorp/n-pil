
import 'dart:ui';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API_Manager.dart';
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

bool viewListOfOperation = true;
String opeToShow = 'none';
String FamillyToShow = 'classique';
String bottomMenuToShow = 'Menu1';
int OpeSelected = 0;

BottomMenu myBottomMenu = BottomMenu();

class ConversationelScreen extends StatefulWidget {
  @override
  State<ConversationelScreen> createState() => ConversationelScreenState();
}

class ConversationelScreenState extends State<ConversationelScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 10),
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
                          padding: const EdgeInsets.all(8.0),
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

  void downloadFile(String urlBase,String FileName) {
    html.AnchorElement anchorElement =  html.AnchorElement(href: urlBase+FileName);
    anchorElement.download = 'test.gcode';
    anchorElement.click();
  }

  @override
  void initState() {
    ProgressBarcontroller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
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
    API_Manager()
        .upLoadAFile(
            "0:/gcodes/" + result.files.first.name.toString(),
            result.files.first.bytes!.length.toString(),
            result.files.first.bytes!)
        .then((notused) {
      API_Manager()
          .getfileList()
          .then((value) => global.ListofGcodeFile = value);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Charger depuis PC'),
                          onPressed: () {
                            isLoading = true;
                            _pickFile();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Charger depuis Liste Conversationel'),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B)),
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
                            downloadFile("http://192.168.1.73/rr_download?name=0:/gcodes/",ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name.toString());
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
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Text('Supprimer Programme'),
                          onPressed: () {
                            print(ListofGcodeFile?.elementAt(
                                    selectedGcodeFileIndex)
                                ?.name
                                .toString());
                            API_Manager()
                                .deleteAFile(ListofGcodeFile!
                                    .elementAt(selectedGcodeFileIndex)!
                                    .name
                                    .toString())
                                .then((toto) {
                              API_Manager().getfileList().then((value) {
                                global.ListofGcodeFile = value;
                                setState(() {});
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9B2B2B)),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 8,
                              child: Container(
                                  height: double.infinity,
                                  margin: EdgeInsets.all(20),
                                  child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text("Liste des programmes: ")))),
                          Flexible(
                              flex: 1,
                              child: isLoading
                                  ? Container(
                                      height: double.infinity,
                                      child: const LinearProgressIndicator())
                                  : Container(
                                      height: double.infinity,
                                    )),
                          Flexible(
                            flex: 40,
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
                                          print(index);
                                        });
                                        //return _onAnyTap!();
                                      },
                                      leading: Icon(
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            (ListofGcodeFile!
                                                    .elementAt(index)!
                                                    .size
                                                    .toString() +
                                                " Octets"),
                                            style:
                                                TextStyle(color: Colors.black),
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
                      )),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: Colors.black)),
                      child: TextField(
                        decoration: InputDecoration(border: InputBorder.none),
                        maxLines: 900000,
                        minLines: 100,
                        controller: controller,
                        //focusNode: FocusNode(),
                        //cursorColor: Colors.blue, backgroundCursorColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Window(
                        title1: "Position ",
                        title2: "machine",
                        child: CoordoneesMachine(),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Window(
                        title1: "Position ",
                        title2: "outil",
                        child: CoordoneesOutil(),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(),
                  )
                ],
              ),
            )),
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //color: Colors.redAccent.withOpacity(0.5),
                child: Column(
                  children: [
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Démarrer Cycle'),
                                  )),
                            ],
                          ),
                          onPressed: global.machineObjectModel.result?.statee
                                      ?.status ==
                                  "idle"
                              ? () {
                                  API_Manager().sendGcodeCommand(
                                      'M32 "0:/gcodes/' +
                                          ListofGcodeFile!
                                              .elementAt(
                                                  selectedGcodeFileIndex)!
                                              .name
                                              .toString() +
                                          '"');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B9B80)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: global.machineObjectModel.result
                                                  ?.statee?.status ==
                                              "paused"
                                          ? Colors.yellow
                                          : Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              Flexible(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Pause Cycle'),
                                  )),
                            ],
                          ),
                          onPressed: () {
                            if (global.machineObjectModel.result?.statee
                                    ?.status ==
                                "paused") {
                              API_Manager().sendGcodeCommand("M24");
                            } else {
                              API_Manager().sendGcodeCommand("M25");
                            }
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B519B)),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Stop Cycle'),
                                  )),
                            ],
                          ),
                          onPressed: global.machineObjectModel.result?.statee
                                      ?.status ==
                                  "paused"
                              ? () {
                                  API_Manager().sendGcodeCommand("M0");
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFCE711A)),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 13,
                        child: Container(
                          height: double.infinity,
                        ))
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

int offsetSelected = 54;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.notifyParent});

  final VoidCallback notifyParent;

  @override
  State<DashboardScreen> createState() => DashboardScreenState(notifyParent);
}

class DashboardScreenState extends State<DashboardScreen> {
  DashboardScreenState(this.notifyParent);

  final Function() notifyParent;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                                    child: Window(
                                      title1: "Position ",
                                      title2: " machine",
                                      child: CoordoneesMachine(),
                                    ),
                                  )),
                              Flexible(
                                  flex: 2,
                                  child: Container(
                                    child: Window(
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
                                  child: global.machineMode==MachineMode.cnc?SpindleSpeed():global.machineMode==MachineMode.fff?PrintToolsTemperature():global.machineMode==MachineMode.laser?LaserToolPower():Container(child: Text("Pas d'outils détectés"),),
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
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                    flex: 9,
                    child: Container(
                      child: Window(
                        title1: "",
                        title2: "",
                      ),
                    )),
                Flexible(
                  flex: 2,
                  child: Container(
                    child: ArretUrgence(
                      notifyParent: () {
                        setState(() {
                          print('Arret Urgence');
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F3),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(flex:1,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Window(title1: "Paramêtres",title2: " généraux",),
            )),
            Flexible(flex:1,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Window(title1: "Paramêtres",title2: " machine",),
            )),
            Flexible(flex:1,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Window(title1: "Paramêtres",title2: " avancés",),
            )),

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

class ConsoleScreen extends StatefulWidget {
  @override
  State<ConsoleScreen> createState() => ConsoleScreenState();
}

class ConsoleScreenState extends State<ConsoleScreen> {
  final TextEditingController _controllers = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F3),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(flex:1,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Window(title1: "Paramêtres",title2: " généraux",),
            )),
            Flexible(flex:1,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Window(title1: "Paramêtres",title2: " machine",),
            )),
            Flexible(flex:1,child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Window(title1: "Paramêtres",title2: " avancés",),
            )),

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
