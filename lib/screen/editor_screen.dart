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

class EditorPage extends StatelessWidget {
  EditorPage({this.filepath});

  final String? filepath;

  final List<FileEditor> files = [
    FileEditor(
      name: global.ContentofFileToEdit.substring(1, 10),
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
  void initState() {}
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
      appBar: AppBar(
        title: Text("Editeur de fichier"),
      ),
      body: CodeEditor(
        model: model, // the model created above, not required since 1.0.0
        edit: true, // can edit the files? by default true
        onSubmit: (String? language, String? value) {
          API_Manager().upLoadAFile(
              "0:/sys/" +
                  global.ListofSysFile!
                      .elementAt(global.selectedFileSysIndex)!
                      .name
                      .toString(),
              ContentofFileToEdit!.length.toString(),
              Uint8List.fromList(value!.codeUnits));
        },
        disableNavigationbar:
            false, // hide the navigation bar ? by default false
        textEditingController:
            myController, // Provide an optional, custom TextEditingController.
      ),
    );
  }
}
