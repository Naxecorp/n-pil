class MagasinOutils {
  double? CoordX;
  double? CoordY;
  double? CoordZ;
  double? Ecartement;

  MagasinOutils({this.CoordX, this.CoordY, this.CoordZ, this.Ecartement});

  bool hasAnyNull() {
    return [CoordX, CoordY, CoordZ, Ecartement].any((element) => element == null);
  }

  MagasinOutils.fromJson(Map<String, dynamic> json)
      : CoordX = json['CoordX'],
        CoordY = json['CoordY'],
        CoordZ = json['CoordZ'],
        Ecartement = json['Ecartement'];

  Map<String, dynamic> toJson() => {
        'CoordX': CoordX,
        'CoordY': CoordY,
        'CoordZ': CoordZ,
        'Ecartement': Ecartement,
      };
}
