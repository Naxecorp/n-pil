import 'dart:convert';

PlacementOutil returnedOutilFromJson(String str) =>
    PlacementOutil.fromJson(json.decode(str));

String outilToJson(PlacementOutil data) => json.encode(data.toJson());

class PlacementOutil {
  List<Outil>? outil;

  PlacementOutil({
    this.outil,
  });

  factory PlacementOutil.fromJson(String str) =>
      PlacementOutil.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlacementOutil.fromMap(Map<String, dynamic> json) => PlacementOutil(
        outil: json["outil"] == null
            ? []
            : List<Outil>.from(json["outil"]!.map((x) => Outil.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "outil": outil == null
            ? []
            : List<dynamic>.from(outil!.map((x) => x.toMap())),
      };
}

class Outil {
  double? coordX;
  double? coordY;
  double? coordZ;
  String? name;
  int? hauteur;
  int? diametre;

  Outil({
    this.coordX,
    this.coordY,
    this.coordZ,
    this.name,
    this.hauteur,
    this.diametre,
  });

  factory Outil.fromJson(String str) => Outil.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Outil.fromMap(Map<String, dynamic> json) => Outil(
        coordX: json["coordX"]?.toDouble(),
        coordY: json["coordY"]?.toDouble(),
        coordZ: json["coordZ"]?.toDouble(),
        name: json["name"],
        hauteur: json["hauteur"],
        diametre: json["diametre"],
      );

  Map<String, dynamic> toMap() => {
        "coordX": coordX,
        "coordY": coordY,
        "coordZ": coordZ,
        "name": name,
        "hauteur": hauteur,
        "diametre": diametre,
      };
}
