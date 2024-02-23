class Offset {
  String? Name;
  double? DecalX;
  double? DecalY;
  double? DecalZ;

  Offset({this.Name, this.DecalX, this.DecalY, this.DecalZ});

  Offset.fromJson(Map<String, dynamic> json)
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
