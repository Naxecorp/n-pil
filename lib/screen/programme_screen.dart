import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:html' as html;

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
      duration: Duration(seconds: 5),
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
  String filename = "";

  bool containsSpecialCharacters(String text) {
    final RegExp specialCharacters =
        RegExp(r'[!@#\$%^&*,?":{}|<>éèàÉÈÊËÀÁÂÄÇçÙÚÛÜüûùîïÌÏÍÒÖÓÔŸÝ]');
    return specialCharacters.hasMatch(text);
  }

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

    filename = result.files.first.name.toString();
    if (!containsSpecialCharacters(filename)) {
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
    } else {
      isLoading = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Erreur'),
            content:
                Text('Le nom de fichier contient des caractères spéciaux.'),
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

  void StartProgPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Êtes vous sûr?"),
          content: Text(
              "Programme sélectionné : ${(ListofGcodeFile!.elementAt(selectedGcodeFileIndex)!.name.toString())}"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Non"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
                child: Text(
                    "Set la position actuel a '0' puis démarre le programme"),
                onPressed: () async {
                  await API_Manager().sendGcodeCommand("G10 L20 P1 X0 Y0 Z0");
                  await API_Manager().sendGcodeCommand("G10 L20 P1");

                  await API_Manager().sendGcodeCommand('M32 "0:/gcodes/' +
                      ListofGcodeFile!
                          .elementAt(selectedGcodeFileIndex)!
                          .name
                          .toString() +
                      '"');
                  await API_Manager().sendGcodeCommand('M106 P3 S255');
                  progName = ListofGcodeFile!
                      .elementAt(selectedGcodeFileIndex)!
                      .name
                      .toString();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/jobStatus');
                }),
            ElevatedButton(
              child: Text("Démarrer"),
              onPressed: () async {
                await API_Manager().sendGcodeCommand('M32 "0:/gcodes/' +
                    ListofGcodeFile!
                        .elementAt(selectedGcodeFileIndex)!
                        .name
                        .toString() +
                    '"');
                await API_Manager().sendGcodeCommand('M106 P3 S255');
                progName = ListofGcodeFile!
                    .elementAt(selectedGcodeFileIndex)!
                    .name
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gapPadding: 5.0,
                          ),
                        ),
                        onSubmitted: (Commande) {
                          setState(() {
                            ManualGcodeComand.clear();
                            API_Manager().sendGcodeCommand(Commande).then(
                                (value) => API_Manager().sendrr_reply().then(
                                    (response) =>
                                        global.ReplyList.add(response)));
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
                ))),
          ],
        ),
      ),
      body: Row(
        children: [
          Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8.0),
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
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child: Text('Télécharger Programme'),
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
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child: Text('Supprimer Programme'),
                            onPressed: () {
                              print(ListofGcodeFile?.elementAt(
                                      selectedGcodeFileIndex)
                                  ?.name
                                  .toString());
                              API_Manager()
                                  .deleteAFile(
                                      ListofGcodeFile!
                                          .elementAt(selectedGcodeFileIndex)!
                                          .name
                                          .toString(),
                                      "gcodes")
                                  .then((_) {
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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 5,
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
                                child: LinearProgressIndicator())
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
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      (ListofGcodeFile!
                                              .elementAt(index)!
                                              .size
                                              .toString() +
                                          " Octets"),
                                      style: TextStyle(color: Colors.black),
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
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(child: Container()),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2B879B)),
                                  onPressed: null,
                                  child: SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        'Visualiser',
                                        textAlign: TextAlign.center,
                                      )))),
                              Spacer(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2B9B80)),
                                  onPressed: global.machineObjectModel.result
                                              ?.state?.status ==
                                          "idle"
                                      ? () {
                                          StartProgPopup(context);
                                        }
                                      : null,
                                  child: SizedBox(
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
