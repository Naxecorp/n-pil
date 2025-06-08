import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:flutter/foundation.dart';
import '../globals_var.dart' as global;
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
    _editorController = TextEditingController(text: global.ContentofFileToEdit);
  }

  // Fonction pour enregistrer le fichier modifié
 Future<void> saveFile() async {
  String editedText = _editorController.text;
  String result = "nok"; // Par défaut

  // Affiche la pop-up "Veuillez patienter..."
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text("Enregistrement en cours"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Veuillez patienter..."),
          ],
        ),
      );
    },
  );

  try {
    if (pageToShow == 7) {
      result = await API_Manager().upLoadAFile(
        "0:/sys/${global.ListofSysFile!.isNotEmpty ? global.ListofSysFile!.elementAt(global.selectedFileSysIndex)?.name?.toString() ?? "aie.g" : "aie.g"}",
        editedText.length.toString(),
        Uint8List.fromList(editedText.codeUnits),
      );
      await API_Manager()
          .getfileListSys()
          .then((value) => global.ListofSysFile = value);
    }

    if (pageToShow == 3) {
      result = await API_Manager().upLoadAFile(
        "0:/gcodes/${global.ListofGcodeFile!.isNotEmpty ? global.ListofGcodeFile!.elementAt(global.selectedGcodeFileIndex)?.name?.toString() ?? "ouille.g" : "ouille.g"}",
        editedText.length.toString(),
        Uint8List.fromList(editedText.codeUnits),
      );
      await API_Manager()
          .getfileList()
          .then((value) => global.ListofGcodeFile = value);
    }
  } finally {
    // Ferme la pop-up "Veuillez patienter..."
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Affiche le résultat en fonction du retour de upLoadAFile
  if (mounted) {
    if (result == "ok") {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            if (mounted) Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text("Succès"),
            content: Text("Le fichier a été enregistré avec succès."),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Échec de l'enregistrement du fichier."),
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
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Éditeur de fichier"),
        actions: [
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
