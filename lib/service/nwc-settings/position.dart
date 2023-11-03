class Position {
  double? PosX;
  double? PosY;
  double? PosZ;

  Position({this.PosX, this.PosY, this.PosZ});

  Position.fromJson(Map<String, dynamic> json)
      : PosX = json['PosX'],
        PosY = json['PosY'],
        PosZ = json['PosZ'];

  Map<String, dynamic> toJson() => {
        'PosX': PosX,
        'PosY': PosY,
        'PosZ': PosZ,
      };
}
