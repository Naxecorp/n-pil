import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../widgetUtils/window.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:code_editor/code_editor.dart';
import '../dashBoardWidgets/coord_machine.dart';
import '../dashBoardWidgets/coord_outil.dart';
import '../dashBoardWidgets/vitesse_broche.dart';
import '../dashBoardWidgets/baby_stepZ.dart';
import '../dashBoardWidgets/job_info.dart';
import '../dashBoardWidgets/coef_vitesse.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/window.dart';
import '../widgetUtils/ArretUrgence.dart';

TextEditingController ManualGcodeComand = TextEditingController();

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
  Future<String> SaveFileContent(String Content) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'program.g',
    );

    if (outputFile == null) {
      // User canceled the picker
      return "canceled";
    }

    final file = File(outputFile);
    var sink = file.openWrite();
    sink.write(Content);
    // _companies.forEach((_company) {
    //   sink.write('${_company.name};${_company.contactMail}\n');
    // });
    sink.close();
    return "Done";
  }

  final _formKey2 = const Key('__RIKEY1__');
  void AdminModeLogger() {
    TextEditingController MDP = new TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
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
                          onFieldSubmitted: (value) {
                            if (MDP.text == global.pwd) {
                              global.AdminLogged = true;
                              global.Title = "ADMIN MODE | $version";
                              Navigator.pop(context, '/admin');
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Dashboard"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.black),
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
        });
  }

  @override
  void initState() {
    API_Manager()
        .getfileListSys()
        .then((value) => global.ListofSysFile = value);
    if (!global.AdminLogged) {
      Future.delayed(Duration(milliseconds: 500), () {
        AdminModeLogger();
      });
    }
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
    super.initState();
  }

  @override
  void dispose() {
    ProgressBarcontroller.dispose();
    super.dispose();
  }

  var selectedFileIndex = 0;

  void _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

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
                ))),
          ],
        ),
      ),
      body: Row(
        children: [
          Flexible(
              flex: 10,
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
                            child: Text(
                              'Charger depuis PC',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (global.AdminLogged) {
                                isLoading = true;
                                _pickFile();
                              } else
                                null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
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
                            child: Text(
                              'Diagnostique X',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (global.AdminLogged) {
                                API_Manager()
                                    .sendGcodeCommand('M98 P"diagX.g"');
                              } else
                                null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
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
                            child: Text(
                              'Diagnostique Y',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              if (global.AdminLogged) {
                                API_Manager()
                                    .sendGcodeCommand('M98 P"diagY.g"');
                              } else
                                null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
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
                            child: Text(
                              'Télécharger Programme',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (global.AdminLogged) {
                                String FileContent =
                                    await API_Manager().downLoadAFile(
                                  "sys",
                                  ListofSysFile!
                                      .elementAt(selectedFileIndex)!
                                      .name
                                      .toString(),
                                );
                                await SaveFileContent(FileContent);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            child: Text(
                              'Supprimer Programme',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {});
                              if (global.AdminLogged) {
                                API_Manager()
                                    .deleteAFile(
                                        ListofSysFile!
                                            .elementAt(selectedFileIndex)!
                                            .name
                                            .toString(),
                                        "sys")
                                    .then((_) {
                                  API_Manager().getfileListSys().then((value) {
                                    global.ListofSysFile = value;
                                    setState(() {});
                                  });
                                });
                              } else
                                null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9B2B2B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
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
                                child: Text("Liste des fichiers systems: ")))),
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
                                leading: Icon(
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
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      (ListofSysFile!
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
              flex: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 80,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black26, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ListView.builder(
                        itemCount: global.ReplyListFiFo.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              tileColor: global.ReplyListFiFo.items
                                      .elementAt(index)
                                      .contains("Error")
                                  ? Colors.redAccent
                                  : global.ReplyListFiFo.items
                                          .elementAt(index)
                                          .contains("Warning")
                                      ? Colors.yellowAccent
                                      : Colors.white,
                              leading: Icon(
                                Icons.arrow_right,
                                color: Colors.blue,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Container(
                                      width: 400,
                                      child: Text(
                                        overflow: TextOverflow.visible,
                                        global.ReplyListFiFo.items
                                            .elementAt(index),
                                        style: TextStyle(color: Colors.black),
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
                      flex: 7,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (global.AdminLogged) {
                                setState(() {
                                  global.ReplyListFiFo.items.clear();
                                });
                              } else
                                null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "clear",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (global.AdminLogged) {
                                setState(() {
                                  global.AdminLogged = false;
                                  global.Title = global.DefaultTitle;
                                  Navigator.pushNamed(context, '/admin');
                                });
                              } else
                                null;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (global.AdminLogged) {
                                await API_Manager()
                                    .downLoadAFile(
                                        'sys',
                                        ListofSysFile!
                                            .elementAt(selectedFileIndex)!
                                            .name
                                            .toString())
                                    .then((value) =>
                                        global.ContentofFileToEdit = value);
                                Navigator.pushNamed(context, '/editor');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Visualiser",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (global.AdminLogged) {
                                await API_Manager()
                                    .sendGcodeCommand('M98 P"config.g"')
                                    .then((_) {
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    API_Manager().sendrr_reply();
                                  });
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Run config.g",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (global.AdminLogged) {
                                API_Manager().upLoadAFile(
                                    "0:/sys/nwc-settings.json",
                                    global.MyMachineN02ConfigDeflaut.toJson()
                                        .length
                                        .toString(),
                                    Uint8List.fromList(machineN02ConfigToJson(
                                            global.MyMachineN02ConfigDeflaut)
                                        .codeUnits));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Load Default Config",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            // Boutton qui execute les fichiers macro GCode
                            onPressed: () async {
                              if (global.AdminLogged) {
                                await API_Manager().sendGcodeCommand(
                                    "M905 P${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} S${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");
                                API_Manager()
                                    .sendGcodeCommand(
                                        'M98 P"${global.ListofSysFile?.elementAt(global.selectedFileSysIndex)?.name}"')
                                    .then((value) =>
                                        API_Manager().sendrr_reply());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text(
                              "Execute macro",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )),
                  Flexible(
                      flex: 2,
                      child: SizedBox(
                        height: 10,
                      ))
                ],
              )),
          Flexible(flex: 5, child: Container()),
        ],
      ),
    );
  }
}
