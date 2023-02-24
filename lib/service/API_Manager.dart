import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'ObjectModelManager.dart';
import 'ObjectModelMoveManager.dart';
import 'package:nweb/globals_var.dart' as global;
import 'package:nweb/gCodeProgram.dart';

class Ethernet_Connection{

  bool? isConnected=false;

  Ethernet_Connection({
    this.isConnected,
  });
}

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

    var uri = Uri.parse('http://192.168.1.73/rr_model?flags=d99fn');
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {
        final MachineObjectModel Machine =
            machineObjectModelFromJson(response.body);
        return Machine;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return MachineObjectModel();
      }
    } catch (e) {
      print(e.toString());
      if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
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

    var uri = Uri.parse('http://192.168.1.73/'+toto);
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {

      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
      }
    } catch (e) {
      print(e.toString());
      if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
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

    var uri = Uri.parse('http://192.168.1.73/rr_gcode?gcode=$command');
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
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

    var uri = Uri.parse('http://192.168.1.73/rr_reply');

    try {
      var response = await http
          .get(uri, headers: requestHeaders)
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        //print(response.);
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

    var uri = Uri.parse('http://192.168.1.73/rr_model?key=state.machineMode');

    try {
      var response = await http
          .get(uri,headers: requestHeaders)
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        print(response.body);
        if(response.body.toString().contains("FFF")) return global.MachineMode.fff;
        if(response.body.toString().contains("CNC")) return global.MachineMode.cnc;
        if(response.body.toString().contains("Laser")) return global.MachineMode.laser;
        else return global.MachineMode.unknow;
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


    var uri = Uri.parse('http://192.168.1.73/rr_model?key=move&flags=d99vn');
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {
        final ObjectModelMove myObjectModelMove = objectModelMoveFromJson(response.body);
        return myObjectModelMove;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return ObjectModelMove();
      }
    } catch (e) {
      print(e.toString());
      if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return ObjectModelMove();
    }
  }

  Future<void> CORSInit() async {

    Map<String, String> requestHeaders = {
      "Access-Control-Request-Method":"POST, GET",
      "Access-Control-Request-Headers": "origin, x-requested-with",
      "Access-Control-Allow-Origin": "*",
      "Origin": "*",
    };


    var uri = Uri.parse('http://192.168.1.73/');
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {

      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());

      }
    } catch (e) {
      print(e.toString());
      if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;

    }
  }

  Future<List<FileElement?>?>getfileList()async{
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse('http://192.168.1.73/rr_filelist?dir=0%3A%2Fgcodes&first=0');
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {
        final ReturnedListGcodeProgram myReturnedListGcodeProgram = returnedListGcodeProgramFromJson(response.body);
        return myReturnedListGcodeProgram.files ;
      } else {
        print('Fail to get data, error : ' + response.statusCode.toString());
        return <FileElement>[];
      }
    } catch (e) {
      print(e.toString());
      if (e.toString()=="XMLHttpRequest error.")global.myEthernet_connection.isConnected=false;
      if (e.toString().startsWith("TimeoutException"))global.myEthernet_connection.isConnected=false;
      return <FileElement>[];
    }

  }

  Future<String> upLoadAFile(String path,String ContentLength,Uint8List FileContent) async {

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

    var uri = Uri.parse('http://192.168.1.73/rr_upload?name=$path');

    try {
      var response = await http
          .post(uri, headers: requestHeaders,body: FileContent)
          .timeout(Duration(seconds: 30));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {
        print(response.body.toString());
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

  Future<String> deleteAFile(String FileName) async {
    Map<String, String> requestHeaders = {
      "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };

    var uri = Uri.parse('http://192.168.1.73/rr_delete?name=0:/gcodes/$FileName');
    http://192.168.1.73/rr_delete?name=0%3A%2Fgcodes%2Ftest5.gcode

    try {
      var response = await http
          .get(uri,headers: requestHeaders)
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


  Future<String> downLoadAFile(String FileName) async {
    Map<String, String> requestHeaders = {
    "Access-Control-Allow-Headers": "*",
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate",
      "Access-Control-Allow-Origin": "*",
      "Accept-Language": "fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7",
      "Connection": "keep-alive",
    };
    var uri = Uri.parse("http://192.168.1.73/rr_download?name=0:/gcodes/$FileName");
    try {
      var response = await http.get(uri,headers: requestHeaders).timeout(Duration(seconds: 2));
      global.myEthernet_connection.isConnected=true;
      if (response.statusCode == 200) {
        print(response.body);
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

}
