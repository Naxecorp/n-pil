import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/logging/action_logger.dart';
import 'package:flutter/foundation.dart';
import '../globals_var.dart' as global;
import '../widgetUtils/account_toolbar_button.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditorPage extends StatefulWidget {
  EditorPage({this.filepath});

  final String? filepath;

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late TextEditingController _editorController;

  @override
  void initState() {
    super.initState();
    // Charger le contenu du fichier dans le contrôleur
    //_editorController = TextEditingController(text: global.ContentofFileToEdit);
    _editorController = TextEditingController();
    _editorController.text = global.ContentofFileToEdit ?? "";
  }

  @override
  void dispose() {
    global.ContentofFileToEdit = '';
    _editorController.dispose();
    super.dispose();
  }

  // Fonction pour enregistrer le fichier modifié
  bool _isSaving = false;

  Future<void> saveFile() async {
    if (_isSaving) return;
    _isSaving = true;

    String editedText = _editorController.text;
    String result = "nok";

    // Affiche la pop-up "Veuillez patienter..."
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Enregistrement en cours"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Veuillez patienter..."),
          ],
        ),
      ),
    );

    try {
      if (pageToShow == 7) {
        result = await API_Manager().upLoadAFile(
          "0:/sys/${global.ListofSysFile!.isNotEmpty ? global.ListofSysFile!.elementAt(global.selectedFileSysIndex)?.name?.toString() ?? "aie.g" : "aie.g"}",
          editedText.length.toString(),
          Uint8List.fromList(editedText.codeUnits),
        );
        global.ListofSysFile = await API_Manager().getfileListSys();
      }

      if (pageToShow == 3) {
        result = await API_Manager().upLoadAFile(
          "0:/gcodes/${global.ListofGcodeFile!.isNotEmpty ? global.ListofGcodeFile!.elementAt(global.selectedGcodeFileIndex)?.name?.toString() ?? "ouille.g" : "ouille.g"}",
          editedText.length.toString(),
          Uint8List.fromList(editedText.codeUnits),
        );
        global.ListofGcodeFile = await API_Manager().getfileList();
      }
    } catch (e) {
      // Log pour le debug
      print("Erreur API: $e");
    } finally {
      if (mounted)
        Navigator.of(context, rootNavigator: true).pop(); // Ferme loading
    }

    if (mounted) {
      await showDialog(
        context: context,
        barrierDismissible: result != "ok",
        builder: (context) {
          return AlertDialog(
            title: Text(result == "ok" ? "Succès" : "Erreur"),
            content: Text(result == "ok"
                ? "Le fichier a été enregistré avec succès."
                : "Échec de l'enregistrement du fichier."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }

    _isSaving = false;

    if (result == "ok") {
      global.ContentofFileToEdit = _editorController.text;
      if (pageToShow == 7) {
        final String fileName = global.ListofSysFile!.isNotEmpty
            ? global.ListofSysFile!
                    .elementAt(global.selectedFileSysIndex)
                    ?.name
                    ?.toString() ??
                "unknown"
            : "unknown";
        await ActionLogger.log(
          category: 'sys_files',
          action: 'edit_sys_file',
          target: fileName,
          details: 'Edition et sauvegarde de fichier /sys',
          result: 'ok',
        );
      } else if (pageToShow == 3) {
        final String fileName = global.ListofGcodeFile!.isNotEmpty
            ? global.ListofGcodeFile!
                    .elementAt(global.selectedGcodeFileIndex)
                    ?.name
                    ?.toString() ??
                "unknown"
            : "unknown";
        await ActionLogger.log(
          category: 'programme_files',
          action: 'edit_gcode_file',
          target: fileName,
          details: 'Edition et sauvegarde de fichier gcode',
          result: 'ok',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Éditeur de fichier"),
        actions: [
          const AccountToolbarButton(),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveFile, // Sauvegarder le fichier
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _editorController,
          maxLines: null, // Permet l'édition sur plusieurs lignes
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Éditez votre fichier ici...",
          ),
        ),
      ),
    );
  }
}
