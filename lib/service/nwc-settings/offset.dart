class Offsets {
  String? Name;
  double? DecalX;
  double? DecalY;
  double? DecalZ;

  Offsets({this.Name, this.DecalX, this.DecalY, this.DecalZ});

  bool hasAnyNull() {
    return [Name, DecalX, DecalY, DecalZ].any((element) => element == null);
  }

  Offsets.fromJson(Map<String, dynamic> json)
      : Name = json["Name"],
        DecalX = json['DecalX'],
        DecalY = json['DecalY'],
        DecalZ = json['DecalZ'];

  Map<String, dynamic> toJson() => {
        'Name': Name,
        'DecalX': DecalX,
        'DecalY': DecalY,
        'DecalZ': DecalZ,
      };
}
