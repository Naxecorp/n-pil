import 'dart:convert';
import 'dart:ffi';

import 'package:nweb/globals_var.dart';
import 'package:nweb/service/nwc-settings/magasinOutils.dart';
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
  int? HasACT;
  int? VitesseBroche;
  int? VitesseDefaut;
  List<Offsets>? Offset;
  List<MagasinOutils>? MagasinOutil;

  bool hasAnyNull() {
    return [
      Serie,
      IP,
      email,
      Lastmodifition,
      GlobalMachineUsedTime,
      DefaultMode,
      Palpeur,
      Positions,
      SetPosAffichage,
      HasHeatBed,
      HasFanOnEnclosure,
      HasLedOnEnclosure,
      HasACT,
      VitesseBroche,
      VitesseDefaut,
      Offset,
      magasinOutil,
    ].any((element) => element == null) ||
    Positions?.any((pos) =>  pos.hasAnyNull()) == true ||
    Offset?.any((off) =>  off.hasAnyNull()) == true ||
    MagasinOutil?.any((outil) =>  outil.hasAnyNull()) == true ||
    (Palpeur != null && Palpeur!.hasAnyNull());
  }

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
      this.HasACT,
      this.VitesseBroche,
      this.VitesseDefaut,
      this.Offset,
      this.MagasinOutil});

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
        HasACT: json["HasACT"],
        VitesseBroche: json["VitesseBroche"],
        VitesseDefaut: json["VitesseDefaut"],
        Offset: json["Offset"] == null
            ? []
            : List<Offsets>.from(
                json["Offset"]!.map(
                  (x) => Offsets.fromJson(x),
                ),
              ),
        MagasinOutil: json["MagasinOutil"] == null
            ? []
            : List<MagasinOutils>.from(
                json["MagasinOutil"]!.map(
                  (x) => MagasinOutils.fromJson(x),
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
        "HasACT": HasACT,
        "VitesseBroche": VitesseBroche,
        "VitesseDefaut": VitesseDefaut,
        "Offset": Offset == null
            ? []
            : List<dynamic>.from(Offset!.map((x) => x.toJson())),
        "MagasinOutil": MagasinOutil == null
            ? []
            : List<dynamic>.from(MagasinOutil!.map((x) => x.toJson())),
      };
}
