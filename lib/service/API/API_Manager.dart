import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nweb/service/outils.dart';
import 'package:path_provider/path_provider.dart';
import '../ObjectModelManager.dart';
import '../ObjectModelMoveManager.dart';
import '../ObjectModelJobManager.dart';
import 'package:nweb/globals_var.dart' as global;
import '../system/SystemsFiles.dart';
import '../gCode/ListGcodeProgram.dart';
import '../gCode/gCodeProgram.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../nwc-settings/nwc-settings.dart';
import '../system/SystemsFilesElement.dart';

class API_Manager {
  static const _token = '9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825';
  static const _lastSyncKey = 'last_sync_timestamp';

  Future<MachineObjectModel> getdataMachineObjectModel() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?flags=d99fn');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));

      if (response.statusCode == 200) {
        //print("toto ${response.body}");
        final MachineObjectModel Machine =
            machineObjectModelFromJson(response.body);

        return Machine;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return MachineObjectModel();
      }
    } catch (e) {
      if (e.toString() == "XMLHttpRequest error.") return MachineObjectModel();
      if (e.toString().startsWith("TimeoutException"))
        return MachineObjectModel();
      return MachineObjectModel();
    }
  }

  Future<void> getdata(String toto) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse('http://${global.MyMachineN02Config.IP}/$toto');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
      }
    } catch (e) {
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
    }
  }

  Future<String> sendGcodeCommand(String command) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_gcode?gcode=$command');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
        return 'ok';
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'nok';
    }
  }

  Future<String> sendrr_reply() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "text/plain",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse('http://${global.MyMachineN02Config.IP}/rr_reply');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        if (response.body.length > 2)
          global.ReplyListFiFo.addItem(response.body);
        return response.body;
      } else {
        print('Send Reply as occured : Fail to Send commnand, error : ' +
            response.statusCode.toString());
        return 'Error : ${response.statusCode}';
      }
    } catch (e) {
      print(e.toString());
      return 'Error : ${e.toString()}';
    }
  }

  // Function to execute sendrr_reply at a specified interval for a specified duration
  Future<void> sendrr_replyEveryIforD(
      int durationMillis, int intervalMillis) async {
    final int repetitions = durationMillis ~/ intervalMillis;

    for (int i = 0; i < repetitions; i++) {
      await sendrr_reply();
      await Future.delayed(Duration(milliseconds: intervalMillis));
    }
  }

  Future<global.MachineMode> getMachineMode() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?key=state.machineMode');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        if (response.body.toString().contains("FFF"))
          return global.MachineMode.fff;
        if (response.body.toString().contains("CNC"))
          return global.MachineMode.cnc;
        if (response.body.toString().contains("Laser"))
          return global.MachineMode.laser;
        else
          return global.MachineMode.unknow;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return global.MachineMode.unknow;
      }
    } catch (e) {
      print(e.toString());
      return global.MachineMode.unknow;
    }
  }

  Future<ObjectModelMove> getMachineMoveObjectModel() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?key=move&flags=d99vn');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
        final ObjectModelMove myObjectModelMove =
            objectModelMoveFromJson(response.body);
        return myObjectModelMove;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return ObjectModelMove();
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return ObjectModelMove();
    }
  }

  Future<ObjectModelJob> getMachineJobObjectModel() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_model?key=job&flags=d99vn');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final ObjectModelJob myObjectModelJob =
            objectModelJobFromJson(response.body);
        return myObjectModelJob;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return ObjectModelJob();
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return ObjectModelJob();
    }
  }

  Future<List<FileElement?>?> getfileList() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_filelist?dir=0:/gcodes&first=0');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
        final ReturnedListGcodeProgram myReturnedListGcodeProgram =
            returnedListGcodeProgramFromJson(response.body);
        return myReturnedListGcodeProgram.files;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return <FileElement>[];
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return <FileElement>[];
    }
  }

  Future<List<SysFileElement?>?> getfileListSys() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json,text/plain",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_filelist?dir=0:/sys/&first=0');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
        final SystemsFiles myReturnedListofFiles =
            systemsFilesFromJson(response.body);
        return myReturnedListofFiles.files;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return <SysFileElement>[];
      }
    } catch (e) {
      print(e.toString());
      //if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      //if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return <SysFileElement>[];
    }
  }

  Future<String> upLoadAFile(
      String path, String ContentLength, Uint8List FileContent) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Content-Length": FileContent.length.toString(),
      "Accept": "*/*",
      "Access-Control-Allow-Origin": "*",
      "Accept-Encoding": "gzip, deflate",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_upload?name=$path');

    try {
      var response = await http
          .post(uri, headers: requestHeaders, body: FileContent)
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        return 'ok';
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'nok';
    }
  }

  Future<String> deleteAFile(String FileName, String path) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_delete?name=0:/$path/$FileName');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return "ok";
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'nok';
    }
  }

  Future<String> downLoadAFile(String path, String FileName) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/$path/$FileName');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 50));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'NOK';
    }
  } // Pour obtenir le répertoire temporaire

  Future<String> downLoadPartOfFile(
      String path, String fileName, int startLine, int endLine) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/$path/$fileName');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        // Obtenir le répertoire temporaire
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/$fileName';

        // Écrire le fichier téléchargé dans le répertoire temporaire
        File tempFile = File(tempPath);

        // Lire le fichier
        List<String> lines = await tempFile.readAsLines();

        // Valider les paramètres startLine et endLine
        if (startLine < 0) startLine = 0;
        if (endLine > lines.length) endLine = lines.length;
        if (startLine > endLine) startLine = endLine;

        // Extraire les lignes spécifiques
        List<String> selectedLines = lines.sublist(startLine, endLine);

        print(selectedLines.join('\n'));
        return selectedLines.join('\n');
      } else {
        print(
            'Fail to Send command, error : ' + response.statusCode.toString());
        return 'nok';
      }
    } catch (e) {
      print(e.toString());
      return 'NOK';
    }
  }

  Future<bool> dlFileToTempDir(String path, String fileName) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/$path/$fileName');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 50));

      if (response.statusCode == 200) {
        // Obtenir le répertoire temporaire
        Directory tempDir = await getTemporaryDirectory();
        fileName = "job.g";
        String tempPath = '${tempDir.path}/$fileName';

        // Écrire le fichier téléchargé dans le répertoire temporaire
        File tempFile = File(tempPath);
        await tempFile.writeAsBytes(response.bodyBytes);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<MachineN02Config> downLoadNwcSettings() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/sys/nwc-settings.json');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
        final MachineN02Config Myconfig =
            returnedMachineN02ConfigFromJson(response.body);
        //print(response.body);
        return Myconfig;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return global.MyMachineN02Config;
      }
    } catch (e) {
      print(e.toString());
      return global.MyMachineN02Config;
    }
  }

  Future<PlacementOutil> downLoadToolSettings() async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse(
        'http://${global.MyMachineN02Config.IP}/rr_download?name=0:/sys/outil-settings.json');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));
      if (response.statusCode == 200) {
        final PlacementOutil Myconfig = returnedOutilFromJson(response.body);
        //print(response.body);
        return Myconfig;
      } else {
        print(
            'Fail to Send commnand, error : ' + response.statusCode.toString());
        return global.magasinOutil;
      }
    } catch (e) {
      print(e.toString());
      return global.magasinOutil;
    }
  }

  // Insertion en BDD
  Future<String> pushDataToDb(String serie, String action) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse(
        'http://naxe.fr/naxen02/post.php?serie=${serie}&action=${action}');
    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 1));

      if (response.statusCode == 200) {
        return 'ok';
      } else {
        return 'nok';
      }
    } catch (e) {
      return 'nok';
    }
  }

  Future<String> sendGcodeToServer({
    required String filename,
    required String content,
    required bool overwrite,
    required String serial,
  }) async {
    const token = '9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825';
    final baseUrl = 'https://naxe.fr/naxen02/reception.php';

    // Joindre les caractères en une seule chaîne

    final uri = Uri.parse(
        '$baseUrl?filename=$filename&overwrite=${overwrite.toString()}&serial=$serial');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'text/plain',
          'Authorization': 'Bearer $token',
          "Access-Control-Allow-Headers": "*",
          "Accept": "*/*",
          "Accept-Encoding": "gzip, deflate",
          "Access-Control-Allow-Origin": "*",
          "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
        },
        body: content,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("✅ Succès : ${responseBody['message']}");
        print("📄 Fichier enregistré sous : ${responseBody['filename']}");
        return response.statusCode.toString();
      } else {
        print("❌ Erreur : ${responseBody['message']}");
        return response.statusCode.toString();
      }
    } catch (e) {
      print("⚠️ Erreur lors de l’envoi : $e");
      return "404";
    }
  }

  Future<void> showUploadProgressDialog({
    required BuildContext context,
    required List<SysFileElement> files,
    required bool overwrite,
    required String serial,
  }) async {
    final progressNotifier = ValueNotifier<double>(0.0);
    final stepTextNotifier = ValueNotifier<String>("Préparation...");
    bool cancelRequested = false;

    // Afficher la boîte modale de progression
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Envoi en cours'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: progressNotifier,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(value: value);
                    },
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable: stepTextNotifier,
                    builder: (context, value, _) => Text(value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cancelRequested = true;
                    Navigator.of(context).pop(); // Ferme le popup immédiatement
                  },
                  child: Text('Annuler'),
                ),
              ],
            );
          },
        );
      },
    );

    int total = files.length;
    int done = 0;
    int successCount = 0;
    int failCount = 0;

    for (final file in files) {
      if (cancelRequested) break;

      done++;

      if (file.name == null) {
        failCount++;
        progressNotifier.value = done / total;
        continue;
      }

      stepTextNotifier.value = 'Téléchargement : ${file.name}';

      try {
        final content = await downLoadAFile('sys', file.name!);

        if (content.toLowerCase() == 'nok') {
          failCount++;
        } else {
          stepTextNotifier.value = 'Envoi : ${file.name}';
          await sendGcodeToServer(
            filename: file.name!,
            content: content,
            overwrite: overwrite,
            serial: serial,
          );
          successCount++;
        }
      } catch (e) {
        failCount++;
      }

      progressNotifier.value = done / total;
    }

    // Affiche un résumé seulement si ce n'était pas annulé
    if (!cancelRequested) {
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Résultat de l\'envoi'),
            content: Text('✔️ Succès : $successCount\n❌ Échecs : $failCount'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> getUpdatedFiles(
      String serial, int since) async {
    final uri = Uri.parse(
        'https://naxe.fr/naxen02/get_updated_files.php?serial=$serial&since=$since');

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer 9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      final json = jsonDecode(response.body);
      if (json['success'] == true) {
        return List<Map<String, dynamic>>.from(json['files']);
      }
    }

    throw Exception('Erreur lors de la récupération des fichiers mis à jour');
  }

  /// Fonction principale de synchronisation
  Future<void> synchronizeFilesToMachine({
    required BuildContext context,
    required String serial,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncTimestamp = prefs.getInt('$_lastSyncKey-$serial') ?? 100;

    int successCount = 0;
    int failCount = 0;
    final StringBuffer logBuffer = StringBuffer();

    try {
      // 1️⃣ Demander le numéro de série à l'utilisateur
      String enteredSerial = await _promptSerialNumber(context, serial);
      if (enteredSerial.isEmpty) {
        print('⚠️ Annulé par l\'utilisateur');
        return;
      }

      // 2️⃣ Vérifier si le numéro correspond à celui configuré
      if (enteredSerial != serial) {
        final confirm =
            await _confirmSerialMismatch(context, serial, enteredSerial);
        if (!confirm) {
          print('⚠️ Annulé par l\'utilisateur après mismatch');
          return;
        }
      }

      // 3️⃣ Récupérer la liste des fichiers modifiés
      List<Map<String, dynamic>> updatedFiles = [];
      try {
        updatedFiles = await getUpdatedFiles(enteredSerial, lastSyncTimestamp);
      } catch (e) {
        print('❌ Erreur lors de la récupération de la liste des fichiers : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur récupération fichiers')),
        );
        return;
      }

      if (updatedFiles.isEmpty) {
        print('ℹ️ Aucun fichier à synchroniser');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun fichier à synchroniser')),
        );
        return;
      }

      // 4️⃣ OUVERTURE DU DIALOGUE APRÈS VÉRIFICATION
      final progressNotifier = ValueNotifier<double>(0.0);
      final stepTextNotifier = ValueNotifier<String>('Préparation...');
      bool cancelRequested = false;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Synchronisation'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: progressNotifier,
                    builder: (context, value, _) {
                      return LinearProgressIndicator(value: value);
                    },
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable: stepTextNotifier,
                    builder: (context, value, _) => Text(value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cancelRequested = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text('Annuler'),
                ),
              ],
            );
          });
        },
      );

      // 5️⃣ Traitement séquentiel
      int total = updatedFiles.length;
      int done = 0;
      int newMaxTimestamp = lastSyncTimestamp;

      for (final file in updatedFiles) {
        if (cancelRequested) break;

        final filename = file['filename'];
        final timestamp = file['timestamp'] as int;

        if (timestamp > newMaxTimestamp) {
          newMaxTimestamp = timestamp;
        }

        stepTextNotifier.value = 'Téléchargement : $filename';

        String downloadStatus = 'nok';
        String uploadStatus = 'nok';

        try {
          // Télécharger le fichier depuis le serveur
          final content = await downloadFileFromServer(enteredSerial, filename);
          downloadStatus = 'ok';

          // Convertir en Uint8List
          final fileContent = Uint8List.fromList(utf8.encode(content));

          // Envoyer à la machine
          stepTextNotifier.value = 'Envoi à la machine : $filename';

          final result = await upLoadAFile(
              filename, fileContent.length.toString(), fileContent);

          if (result.toLowerCase() == 'ok') {
            uploadStatus = 'ok';
            successCount++;
          } else {
            uploadStatus = 'nok';
            failCount++;
          }
        } catch (e) {
          print('⚠️ Erreur avec $filename : $e');
          failCount++;
        }

        String _twoDigits(int n) => n.toString().padLeft(2, '0');

        final now = DateTime.now();
        final timestamp2 =
            "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}";

        logBuffer.writeln(
            '[$timestamp2] Nom: $filename | Serial: $enteredSerial | Téléchargement: $downloadStatus | Upload: $uploadStatus');

        done++;
        progressNotifier.value = done / total;
      }

      // 6️⃣ Fermer la modale après traitement
      Navigator.of(context).pop();

      // 7️⃣ Mettre à jour le timestamp local si non annulé
      if (!cancelRequested && newMaxTimestamp > lastSyncTimestamp) {
        await prefs.setInt('$_lastSyncKey-$enteredSerial', newMaxTimestamp);
      }

      // 8️⃣ Envoi du fichier de log à la machine
      if (!cancelRequested) {
        final logContent = logBuffer.toString();
        final logBytes = Uint8List.fromList(utf8.encode(logContent));

        final logResult = await upLoadAFile(
            'log_synchro.txt', logBytes.length.toString(), logBytes);

        // 9️⃣ Envoi du log au serveur distant
        final serverResult = await sendLogFileToServer(serial, logContent);
        print('🌐 Transfert du log au serveur : $serverResult');

        print('📄 Transfert du log : $logResult');
      }

      // 9️⃣ Résumé final
      if (!cancelRequested) {
        await showDialog(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text('Synchronisation terminée'),
              content: Text('✔️ Succès : $successCount\n❌ Échecs : $failCount'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on TimeoutException catch (_) {
      print('⏱️ Synchronisation annulée (timeout)');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : synchronisation annulée (timeout)')),
      );
    }
  }

  /// Boîte de dialogue pour demander le numéro de série
  Future<String> _promptSerialNumber(
      BuildContext context, String defaultSerial) async {
    String enteredSerial = '';
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final controller = TextEditingController(text: defaultSerial);
        return AlertDialog(
          title: Text('Numéro de série'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Numéro de série'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                enteredSerial = controller.text.trim();
                Navigator.of(dialogContext).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
    return enteredSerial;
  }

  /// Boîte de confirmation si le numéro saisi ne correspond pas
  Future<bool> _confirmSerialMismatch(
      BuildContext context, String expectedSerial, String enteredSerial) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Numéro de série différent'),
          content: Text(
              'Le numéro de série saisi ($enteredSerial) est différent de celui attendu ($expectedSerial). Voulez-vous continuer ?'),
          actions: [
            TextButton(
              onPressed: () {
                confirmed = false;
                Navigator.of(dialogContext).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                confirmed = true;
                Navigator.of(dialogContext).pop();
              },
              child: Text('Continuer'),
            ),
          ],
        );
      },
    );
    return confirmed;
  }

  Future<String> sendLogFileToServer(String serial, String logContent) async {
    final uri = Uri.parse('https://naxe.fr/naxen02/upload_log.php');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer 9fa98b3c-2c4e-4cb3-86b3-c3f5f8e10825',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'serial': serial,
        'filename': 'log_synchro.txt',
        'content': logContent,
      }),
    );

    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return 'nok';
    }
  }

  /// Télécharger un fichier individuel
  Future<String> downloadFileFromServer(String serial, String filename) async {
    final uri = Uri.parse(
        'https://naxe.fr/naxen02/get_file.php?serial=$serial&filename=${Uri.encodeComponent(filename)}');
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $_token'
    }).timeout(Duration(seconds: 3));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Erreur téléchargement $filename');
    }
  }
}
