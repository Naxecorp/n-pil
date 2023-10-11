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
