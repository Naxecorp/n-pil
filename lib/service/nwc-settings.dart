import 'dart:convert';

import 'package:nweb/globals_var.dart';

MachineN02Config returnedMachineN02ConfigFromJson(String str) =>
    MachineN02Config.fromJson(json.decode(str));

String machineN02ConfigToJson(MachineN02Config data) =>
    json.encode(data.toJson());

class MachineN02Config {
  String? IP;
  String? email;
  String? Lastmodifition;
  int? GlobalMachineUsedTime;
  String? DefaultMode;
  PalpeurOutil? Palpeur;

  MachineN02Config({this.IP, this.email, this.Lastmodifition,this.GlobalMachineUsedTime, this.DefaultMode, this.Palpeur});



  factory MachineN02Config.fromJson(Map<String, dynamic> json) =>
      MachineN02Config(
          IP: json["IP"],
          email: json["email"],
          Lastmodifition: json["lastmodification"],
          GlobalMachineUsedTime : json["GlobalMachineUsedTime"],
          DefaultMode: json["DefaultMode"],
          Palpeur: json["Palpeur"] == null ? null : PalpeurOutil.fromJson(json["Palpeur"]));

  Map<String, dynamic> toJson() => {
        "IP": IP,
        "email": email,
        "lastmodification": Lastmodifition,
        "GlobalMachineUsedTime" : GlobalMachineUsedTime,
        "DefaultMode": DefaultMode,
        "Palpeur": Palpeur!.toJson(),
      };
}

class PalpeurOutil {
  double? PosX;
  double? PosY;
  double? Height;

  PalpeurOutil({this.PosX, this.PosY, this.Height});

  PalpeurOutil.fromJson(Map<String, dynamic> json)
      : PosX = json['PosX'],
        PosY = json['PosY'],
        Height = json['Height'];

  Map<String, dynamic> toJson() => {
        'PosX': PosX,
        'PosY': PosY,
        'Height': Height,
      };
}
