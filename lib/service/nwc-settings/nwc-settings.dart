import 'dart:convert';

import 'package:nweb/globals_var.dart';
import 'package:nweb/service/nwc-settings/position.dart';

import 'PalperOutil.dart';

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
  List<Position>? Positions;
  int? SetPosAffichage;
  int? HasHeatBed;
  int? HasFanOnEnclosure;
  int? HasLedOnEnclosure;

  MachineN02Config(
      {this.IP,
      this.email,
      this.Lastmodifition,
      this.GlobalMachineUsedTime,
      this.DefaultMode,
      this.Palpeur,
      this.Positions,
      this.SetPosAffichage, this.HasHeatBed,this.HasFanOnEnclosure,this.HasLedOnEnclosure});

  factory MachineN02Config.fromJson(Map<String, dynamic> json) =>
      MachineN02Config(
        IP: json["IP"],
        email: json["email"],
        Lastmodifition: json["lastmodification"],
        GlobalMachineUsedTime: json["GlobalMachineUsedTime"],
        DefaultMode: json["DefaultMode"],
        Positions: json["Positions"] == null
            ? []
            : List<Position>.from(
                json["Positions"]!.map(
                  (x) => Position.fromJson(x),
                ),
              ),
        Palpeur: json["Palpeur"] == null
            ? null
            : PalpeurOutil.fromJson(json["Palpeur"]),
        SetPosAffichage: json["SetPosAffichage"],
        HasHeatBed: json["HasHeatBed"],
        HasFanOnEnclosure: json["HasFanOnEnclosure"],
        HasLedOnEnclosure: json["HasLedOnEnclosure"],
      );

  Map<String, dynamic> toJson() => {
        "IP": IP,
        "email": email,
        "lastmodification": Lastmodifition,
        "GlobalMachineUsedTime": GlobalMachineUsedTime,
        "DefaultMode": DefaultMode,
        "Positions": Positions == null
            ? []
            : List<dynamic>.from(Positions!.map((x) => x.toJson())),
        "Palpeur": Palpeur!.toJson(),
        "SetPosAffichage": SetPosAffichage,
        "HasBedOnlaser": HasHeatBed,
        "HasFanOnEnclosure": HasFanOnEnclosure,
        "HasLedOnEnclosure": HasLedOnEnclosure,
      };
}
