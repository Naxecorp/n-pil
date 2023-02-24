import 'package:flutter/material.dart';

class Vector3DWidget extends StatelessWidget {
  final double x;
  final double y;
  final double z;

  const Vector3DWidget({Key? key, required this.x, required this.y, required this.z}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Vector3DPainter(x: x, y: y, z: z),
      child: Container(),
    );
  }
}

class _Vector3DPainter extends CustomPainter {
  final double x;
  final double y;
  final double z;

  _Vector3DPainter({required this.x, required this.y, required this.z});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;
    final path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(x, y);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
