import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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

import '../nwc-settings/nwc-settings.dart';
import '../system/SystemsFilesElement.dart';

class API_Manager {
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
        print("toto ${response.body}");
        final MachineObjectModel Machine =
            machineObjectModelFromJson(response.body);
        
        return Machine;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return MachineObjectModel();
      }
    } catch (e) {
      if (e.toString() == "XMLHttpRequest error.")return MachineObjectModel();
      if (e.toString().startsWith("TimeoutException"))return MachineObjectModel();
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
          .timeout(Duration(seconds: 30));
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

  // Future<int> getCurrentLine(String path, String fileName, int currentByte) async {

  //   try {
  //       // Obtenir le répertoire temporaire
  //       Directory tempDir = await getTemporaryDirectory();
  //       String tempPath = '${tempDir.path}/$fileName';

  //       // Lire le fichier
  //       List<String> lines = await tempFile.readAsLines();

  //       // Obtenir le nombre total de lignes
  //       int totalLines = lines.length;

  //       // Obtenir la taille totale du fichier en octets
  //       int totalBytes = response.contentLength ?? await tempFile.length();

  //       // Calculer le pourcentage de progression
  //       double percentage = currentByte / totalBytes;

  //       // Calculer la ligne actuelle basée sur le pourcentage
  //       int currentLine = (percentage * totalLines).round();

  //       print(currentLine);
  //       return currentLine;

  //   } catch (e) {
  //     print(e.toString());
  //     return 0;
  //   }
  // }

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

  //Recupération données en BDD
  // Future getDataFromDB() async {
  //   try {
  //     var url = Uri.parse('https://naxe.fr/naxen02/get.php');
  //     http.Response response = await http.get(url);
  //     var data = jsonDecode(response.body);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> writeToFile(String message) async {
  //   try {
  //     // Obtenir le répertoire local où le fichier sera stocké
  //     final directory = await getApplicationDocumentsDirectory();
  //     final path = '${directory.path}/logfile.txt';
  //     final file = File(path);

  //     // Vérifier si le fichier existe
  //     if (!await file.exists()) {
  //       await file.create();
  //     }

  //     // Obtenir la date et l'heure actuelles
  //     final now = DateTime.now();
  //     final formattedDate =
  //         '${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}';

  //     // Préparer le contenu à écrire
  //     final content = '$formattedDate: $message\n';

  //     // Écrire le contenu dans le fichier
  //     await file.writeAsString(content, mode: FileMode.append);

  //     print('Message écrit dans le fichier avec succès\n ${directory.path}');
  //   } catch (e) {
  //     print('Erreur lors de l\'écriture dans le fichier: $e');
  //   }
  // }

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
}
