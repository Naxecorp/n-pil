import 'dart:async' show Future;

class Operation {
  List<String> trajectoires = <String>[];

  double OriginX = 0;
  double OriginY = 0;
  double OriginZ = 0;
  final String? label;

  Operation(
      {required this.OriginZ,
      required this.OriginY,
      required this.OriginX,
      this.label});

  void setOrigin(double _OriginX, double _OriginY, double _OriginZ) {
    OriginX = _OriginX;
    OriginY = _OriginY;
    OriginZ = _OriginZ;
  }

  void init() {
    trajectoires.add('Programe initial');
  }

  Future<void> construct() async {}

  void showValues() {}
}
