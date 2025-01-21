import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nweb/OpeListView.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../menus/side_menu.dart';
import '../widgetUtils/gcodeViewer.dart';
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

  // void downloadFile(String urlBase, String FileName) {
  //   html.AnchorElement anchorElement =
  //       html.AnchorElement(href: urlBase + FileName);
  //   anchorElement.download = 'test.gcode';
  //   anchorElement.click();
  // }

  String LoadedFileContentString = "";

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

  String extractDuration(String consoleResponse) {
    // Expression régulière pour trouver le modèle "0h12min"
    final regex = RegExp(r'(\d+)h (\d+)m');
    final match = regex.firstMatch(consoleResponse);

    if (match != null) {
      // Si un match est trouvé, extrayez les heures et les minutes
      final hours = match.group(1);
      final minutes = match.group(2);
      return '$hours heures et $minutes minutes';
    } else {
      // Si aucun match n'est trouvé, retournez une chaîne vide ou un message approprié
      return 'Durée non trouvée';
    }
  }

  String extractErrorMessage(String consoleResponse) {
    // Chercher l'index de "Error:" dans la chaîne
    final errorIndex = consoleResponse.indexOf("Error:");

    if (errorIndex != -1) {
      // Extraire tout ce qui suit "Error:"
      return consoleResponse.substring(errorIndex);
    } else {
      // Si "Error:" n'est pas trouvé, retourner une chaîne vide ou un message approprié
      return 'Aucune erreur trouvée';
    }
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
    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (global.MyMachineN02Config.HasFanOnEnclosure == 1)
        global.checkCaissonOpen(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    ProgressBarcontroller.dispose();
    super.dispose();
  }

  String filename = "";

  bool containsSpecialCharacters(String text) {
    final RegExp specialCharacters =
        RegExp(r'[!@#\$%^&*,?":{}|<>éèàÉÈÊËÀÁÂÄÇçÙÚÛÜüûùîïÌÏÍÒÖÓÔŸÝ]');
    return specialCharacters.hasMatch(text);
  }


Map<String, dynamic>? findFirstNonAnsiCharacter(Uint8List fileBytes) {
  try {
    // Décoder les bytes en UTF-8 pour obtenir les lignes
    String content = utf8.decode(fileBytes, allowMalformed: true);
    List<String> lines = content.split('\n');

    // Parcourir chaque ligne pour trouver un caractère non ANSI
    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      String line = lines[lineIndex];
      for (int charIndex = 0; charIndex < line.length; charIndex++) {
        int codeUnit = line.codeUnitAt(charIndex);
        if (codeUnit > 127) {
          return {
            'line': lineIndex + 1, // Numéro de ligne (1-indexé)
            'char': charIndex + 1, // Position du caractère dans la ligne (1-indexé)
            'character': line[charIndex], // Le caractère non conforme
            'codeUnit': codeUnit, // Code Unicode du caractère
          };
        }
      }
    }
    return null; // Aucun caractère non conforme trouvé
  } catch (e) {
    return null; // Retourner null en cas d'erreur
  }
}

void _pickFile() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(withData: true);

  if (result == null) {
    isLoading = false;
    return;
  }

  setState(() {
    isLoading = true;
  });

  filename = result.files.first.name.toString();
  Uint8List? fileBytes = result.files.first.bytes;

  // Recherche du premier caractère non ANSI
  Map<String, dynamic>? invalidChar = fileBytes == null
      ? null
      : findFirstNonAnsiCharacter(fileBytes);

  if (invalidChar != null) {
    isLoading = false;

    // Préparer une description lisible du caractère problématique
    String characterDescription =
        "Code Unicode : U+${invalidChar['codeUnit'].toRadixString(16).toUpperCase()}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Caractères non compatibles'),
          content: Text(
              'Le fichier contient un caractère non compatible avec l\'encodage ANSI (ISO-8859-1).\n\n'
              'Position : Ligne ${invalidChar['line']}, caractère ${invalidChar['char']}\n'
              '$characterDescription'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  // Décoder le fichier en ANSI (latin1)
  String fileContent = latin1.decode(fileBytes!, allowInvalid: false);

  // Continuez avec la logique existante
  if (!containsSpecialCharacters(filename)) {
    API_Manager()
        .upLoadAFile("0:/gcodes/" + result.files.first.name.toString(),
            result.files.first.size.toString(), result.files.first.bytes!)
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
          title: const Text('Erreur'),
          content: const Text(
              'Le nom de fichier contient des caractères spéciaux.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
          title: Center(child: const Text("Êtes vous sûr ?")),
          content: Container(
            height: 200,
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Avez vous : "),
                Text("1 - Défini les origines machines"),
                Text("2 - Visualisé le programe"),
                Text("3 - Effectué une simulation"),
                Text("4 - Vérifié que la broche démarre"),
                Text("5 - Sélectionné le bon outil (fraise)\n"),
                Center(
                    child: Text(
                        "Programme sélectionné : ${(ListofGcodeFile!.elementAt(global.selectedGcodeFileIndex)!.name.toString())}")),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Non"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Démarrer"),
              onPressed: () async {
                global.secondsElapsedSinceBeginning = 0;
                global.globalTimeValue = "00:00:00";
                global.isJobStartedByUser = true;
                await API_Manager().sendGcodeCommand('M32 "0:/gcodes/' +
                    ListofGcodeFile!
                        .elementAt(global.selectedGcodeFileIndex)!
                        .name
                        .toString() +
                    '"');
                await API_Manager().sendGcodeCommand('M106 P3 S255');
                progName = ListofGcodeFile!
                    .elementAt(global.selectedGcodeFileIndex)!
                    .name
                    .toString();
                await API_Manager().dlFileToTempDir(
                    "gcodes",
                    ListofGcodeFile!
                        .elementAt(global.selectedGcodeFileIndex)!
                        .name
                        .toString());
                await API_Manager()
                    .pushDataToDb(global.MyMachineN02Config.Serie ?? "NUMSTD",
                        "Start prog ${progName}")
                    .timeout(Duration(seconds: 5));
                Navigator.of(context).pop();
                pageToShow = 4;
                Navigator.pushNamed(context, '/jobStatus');
              },
            ),
          ],
        );
      },
    );
  }

  List<String> convertStringToList(String inputString) {
    List<String> lines = inputString.split('\n');
    return lines;
  }

  late Timer SimulationTimer;

  int calculatePercentage(int part, int total) {
  if (total == 0) {
    throw ArgumentError("Le total ne peut pas être égal à zéro.");
  }
  return ((part / total) * 100.0).toInt(); // Conversion implicite en double
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
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: ManualGcodeComand,
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),
                            ),
                            onSubmitted: (Commande) {
                              setState(() {
                                global.commandHistory.add(Commande);
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then(
                                    (value) => API_Manager().sendrr_reply());
                              });
                            },
                          ),
                          PopupMenuButton<String>(
                            tooltip: "Historique",
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                ManualGcodeComand.text = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return global.commandHistory
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  ],
                ),
              ),
            ),
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton.icon(
                          label: const Text(
                            "Charger depuis PC",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2B879B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            isLoading = true;
                            _pickFile();
                          },
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton.icon(
                          label: const Text(
                            "Télécharger programme",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () async {
                            String FileContent = await API_Manager()
                                .downLoadAFile(
                                    "gcodes",
                                    ListofGcodeFile!
                                        .elementAt(
                                            global.selectedGcodeFileIndex)!
                                        .name
                                        .toString());
                            await SaveFileContent(FileContent);
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton.icon(
                          label: const Text(
                            "Supprimer programme",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9B2B2B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () {
                            API_Manager()
                                .deleteAFile(
                                    ListofGcodeFile!
                                        .elementAt(
                                            global.selectedGcodeFileIndex)!
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                          child: Text("Liste des programmes : "),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: isLoading
                            ? Container(
                                height: double.infinity,
                                child: const LinearProgressIndicator(
                                  color: Colors.blue,
                                ))
                            : Container(
                                height: double.infinity,
                              )),
                    Flexible(
                      flex: 45,
                      child: Container(
                        child: ListView.builder(
                          itemCount: ListofGcodeFile?.length,
                          itemBuilder: (BuildContext context, int index) {
                            ListofGcodeFile?.sort(
                                (a, b) => a!.name!.compareTo(b!.name!));
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                tileColor: Colors.white,
                                selectedColor: Colors.orange,
                                selectedTileColor: Colors.black26,
                                selected:
                                    index == global.selectedGcodeFileIndex,
                                onTap: () {
                                  setState(() {
                                    global.selectedGcodeFileIndex = index;
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
                        color: Color.fromARGB(255, 219, 219, 219),
                        border: Border.all(color: Colors.black26, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(child: GcodeViewer()),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            label: const Text(
                              "Visualiser",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              if (ListofGcodeFile!
                                      .elementAt(global.selectedGcodeFileIndex)!
                                      .size! <
                                  3000000) {
                                LoadedFileContentString = await API_Manager()
                                    .downLoadAFile(
                                        "gcodes",
                                        ListofGcodeFile!
                                            .elementAt(
                                                global.selectedGcodeFileIndex)!
                                            .name
                                            .toString());
                                List<String> _LoadedFileContent =
                                    convertStringToList(
                                        LoadedFileContentString);
                                global.controllerContentGcodeToDisplay
                                    .add(_LoadedFileContent);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Fichier trop volumineux pour être visualisé'),
                                  duration: Duration(milliseconds: 3000),
                                ));
                              }
                            },
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            label: const Text(
                              "Editer",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              if (ListofGcodeFile!
                                      .elementAt(global.selectedGcodeFileIndex)!
                                      .size! <
                                  100000) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text("Chargement en cours..."),
                                      );
                                    });
                                await API_Manager()
                                    .downLoadAFile(
                                        'gcodes',
                                        ListofGcodeFile!
                                            .elementAt(
                                                global.selectedGcodeFileIndex)!
                                            .name
                                            .toString())
                                    .then((value) =>
                                        global.ContentofFileToEdit = value);
                                Navigator.of(context).pop();
                                Navigator.pushNamed(context, '/editor');
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Fichier trop volumineux pour être édité'),
                                  duration: Duration(milliseconds: 3000),
                                ));
                              }
                            },
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            label: const Text(
                              "Simulation",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.computer,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 36, 174, 73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: global.machineObjectModel.result?.state
                                        ?.status ==
                                    "idle"
                                ? () async {
                                    var _savedPosX = global.machineObjectModel
                                        .result!.move!.axes![0].machinePosition;
                                    var _savedPosY = global.machineObjectModel
                                        .result!.move!.axes![1].machinePosition;
                                    var _savedPosZ = global.machineObjectModel
                                        .result!.move!.axes![2].machinePosition;

                                    Timer SimulationTimer = Timer.periodic(
                                        Duration(milliseconds: 500), (timer) {
                                      API_Manager()
                                          .sendrr_reply()
                                          .then((value) {
                                        if (value.contains("will print in")) {
                                          timer.cancel();
                                          Navigator.of(context).pop();
                                          API_Manager().sendGcodeCommand(
                                              "G92 X$_savedPosX Y$_savedPosY Z$_savedPosZ");
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                          fontSize: 28,
                                                          color: Color.fromARGB(
                                                              255,
                                                              14,
                                                              125,
                                                              31)),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "Simulation sucess"),
                                                      ],
                                                    ),
                                                  ),
                                                  content: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color.fromARGB(
                                                              255, 10, 28, 13)),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "Durée du programme: ${extractDuration(value)}"),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else if (value.contains("Error")) {
                                          timer.cancel();
                                          Navigator.of(context).pop();
                                          API_Manager().sendGcodeCommand(
                                              "G92 X$_savedPosX Y$_savedPosY Z$_savedPosZ");
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                          fontSize: 28,
                                                          color: Color.fromARGB(
                                                              255, 176, 8, 8)),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "Simulation erreur"),
                                                      ],
                                                    ),
                                                  ),
                                                  content: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color.fromARGB(
                                                              255, 63, 9, 9)),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                extractErrorMessage(
                                                                    value)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      });
                                    });

                                    API_Manager()
                                        .sendGcodeCommand(
                                            'M37 F0 P"${ListofGcodeFile!.elementAt(global.selectedGcodeFileIndex)!.name.toString()}"')
                                        .then((value2) {
                                      num? filePositionFlitred = 0;
                                       Timer?
                                              simulationTimer; // Timer déclaré comme nullable
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          int elapsedSeconds =
                                              0; // Compteur pour le temps écoulé
                                         

                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              // Démarrer le timer si ce n'est pas déjà fait
                                              simulationTimer ??=
                                                  Timer.periodic(
                                                      Duration(seconds: 1),
                                                      (timer) {
                                                if (Navigator.of(context)
                                                    .canPop()) {
                                                  setState(() {
                                                    global.machineObjectModel.result?.job?.filePosition !=null ? filePositionFlitred = global.machineObjectModel.result?.job?.filePosition : filePositionFlitred = filePositionFlitred;
                                                  });
                                                } else {
                                                  timer.cancel();
                                                }
                                              });

                                              return AlertDialog(
                                                title:
                                                    Text("Simulation en cours"),
                                                content: RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "Merci de patienter.\nCela peut prendre plusieurs minutes.\n\n",
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "Progression  : ${calculatePercentage(filePositionFlitred?.toInt()??1, global.ListofGcodeFile?[global.selectedGcodeFileIndex]?.size??1)} %\n\n",
                                                            //"Progression  : ${calculatePercentage(600, 1200)}",
                                                            
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "La simulation ne vérifie pas les longueurs d'outils en cas de changement d'outil automatique.",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Sortir"),
                                                    onPressed: () async {
                                                      // Arrêter le timer
                                                      simulationTimer?.cancel();

                                                      // Envoyer les commandes API
                                                      await API_Manager()
                                                          .sendGcodeCommand(
                                                              "M25");
                                                      await API_Manager()
                                                          .sendGcodeCommand(
                                                              "M0");
                                                      await API_Manager()
                                                          .sendGcodeCommand(
                                                              "M37 S0");
                                                      await API_Manager()
                                                          .sendGcodeCommand(
                                                              "G92 X$_savedPosX Y$_savedPosY Z$_savedPosZ");

                                                      // Fermer la boîte de dialogue
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ).then((_) {
                                        simulationTimer?.cancel();
                                      });
                                    });
                                  }
                                : null,
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            label: const Text(
                              "Démarrer",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.start_rounded,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: global.machineObjectModel.result?.state
                                        ?.status ==
                                    "idle"
                                ? () {
                                    StartProgPopup(context);
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
