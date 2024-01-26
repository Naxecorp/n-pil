class Position {
  String? Name;
  double? PosX;
  double? PosY;
  double? PosZ;

  Position({this.Name, this.PosX, this.PosY, this.PosZ});

  Position.fromJson(Map<String, dynamic> json)
      : Name = json["Name"],
        PosX = json['PosX'],
        PosY = json['PosY'],
        PosZ = json['PosZ'];

  Map<String, dynamic> toJson() => {
        'Name': Name,
        'PosX': PosX,
        'PosY': PosY,
        'PosZ': PosZ,
      };
}
