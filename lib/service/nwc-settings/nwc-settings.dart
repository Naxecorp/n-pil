import 'dart:convert';
import 'dart:ffi';

import 'package:nweb/globals_var.dart';
import 'package:nweb/service/nwc-settings/position.dart';
import 'package:nweb/service/nwc-settings/offset.dart';

import 'PalperOutil.dart';

MachineN02Config returnedMachineN02ConfigFromJson(String str) =>
    MachineN02Config.fromJson(json.decode(str));

String machineN02ConfigToJson(MachineN02Config data) =>
    json.encode(data.toJson());

class MachineN02Config {
  String? Serie;
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
  int? VitesseBroche;
  int? VitesseDefaut;
  List<Offset>? Offsets;

  MachineN02Config(
      {this.Serie,
      this.IP,
      this.email,
      this.Lastmodifition,
      this.GlobalMachineUsedTime,
      this.DefaultMode,
      this.Palpeur,
      this.Positions,
      this.SetPosAffichage,
      this.HasHeatBed,
      this.HasFanOnEnclosure,
      this.HasLedOnEnclosure,
      this.VitesseBroche,
      this.VitesseDefaut,
      this.Offsets});

  factory MachineN02Config.fromJson(Map<String, dynamic> json) =>
      MachineN02Config(
        Serie: json["Serie"],
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
        VitesseBroche: json["VitesseBroche"],
        VitesseDefaut: json["VitesseDefaut"],
        Offsets: json["Offset"] == null
            ? []
            : List<Offset>.from(
                json["Positions"]!.map(
                  (x) => Offset.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "Serie": Serie,
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
        "HasHeatBed": HasHeatBed,
        "HasFanOnEnclosure": HasFanOnEnclosure,
        "HasLedOnEnclosure": HasLedOnEnclosure,
        "VitesseBroche": VitesseBroche,
        "VitesseDefaut": VitesseDefaut,
        "Offset": Offsets == null
            ? []
            : List<dynamic>.from(Offsets!.map((x) => x.toJson())),
      };
}
