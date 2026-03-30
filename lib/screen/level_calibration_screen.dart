import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nweb/main.dart';
import 'package:nweb/menus/side_menu.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/widgetUtils/account_toolbar_button.dart';
import 'package:nweb/widgetUtils/window.dart';

import '../globals_var.dart' as global;

TextEditingController manualGcodeCommand = TextEditingController();

class _LevelPoint {
  _LevelPoint({
    required this.index,
    required this.x,
    required this.y,
  });

  final int index;
  final double x;
  final double y;
  double? rawZ;
  double? deltaZ;
  String source = "";

  bool get hasMeasurement => rawZ != null && deltaZ != null;
}

class _DeltaRange {
  const _DeltaRange({required this.min, required this.max});

  final double? min;
  final double? max;
}

class _HeightmapCsvBuildResult {
  const _HeightmapCsvBuildResult({
    required this.content,
    required this.clippedPoints,
    required this.measuredPoints,
  });

  final String content;
  final int clippedPoints;
  final int measuredPoints;
}

class _ParsedHeightmap {
  const _ParsedHeightmap({
    required this.pointsX,
    required this.pointsY,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.deltas,
  });

  final int pointsX;
  final int pointsY;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final List<double> deltas;
}

class _TopViewPainter extends CustomPainter {
  _TopViewPainter({
    required this.points,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.minDelta,
    required this.maxDelta,
    required this.selectedIndex,
  });

  final List<_LevelPoint> points;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final double? minDelta;
  final double? maxDelta;
  final int selectedIndex;

  double _norm(double value, double min, double max) {
    final double range = max - min;
    if (range.abs() < 0.000001) return 0.5;
    return (value - min) / range;
  }

  Color _colorForPoint(_LevelPoint point) {
    if (!point.hasMeasurement || minDelta == null || maxDelta == null) {
      return const Color(0x55A0A4AF);
    }
    final double t = _norm(point.deltaZ!, minDelta!, maxDelta!).clamp(0.0, 1.0);
    final Color base = Color.lerp(
          const Color(0xFF6CA8FF),
          const Color(0xFFE85A4F),
          t,
        ) ??
        const Color(0xFF20917F);
    final double alpha = 0.40 + (0.60 * t);
    return base.withValues(alpha: alpha);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect frame = Rect.fromLTWH(18, 18, size.width - 36, size.height - 36);

    final Paint framePaint = Paint()
      ..color = const Color(0xFFB7BEC9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRect(frame, framePaint);

    final Paint crossPaint = Paint()
      ..color = const Color(0x33818A99)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(frame.center.dx, frame.top),
      Offset(frame.center.dx, frame.bottom),
      crossPaint,
    );
    canvas.drawLine(
      Offset(frame.left, frame.center.dy),
      Offset(frame.right, frame.center.dy),
      crossPaint,
    );

    for (final _LevelPoint point in points) {
      final double nx = _norm(point.x, minX, maxX).clamp(0.0, 1.0);
      final double ny = _norm(point.y, minY, maxY).clamp(0.0, 1.0);
      final double px = frame.left + (nx * frame.width);
      final double py = frame.bottom - (ny * frame.height);

      final Paint pointPaint = Paint()
        ..color = _colorForPoint(point)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(px, py), 7, pointPaint);

      final bool isSelected = point.index == selectedIndex;
      final Paint strokePaint = Paint()
        ..color = isSelected ? const Color(0xFF1F8A76) : const Color(0xFF6E7786)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.5 : 1.1;
      canvas.drawCircle(Offset(px, py), isSelected ? 8.5 : 7.5, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TopViewPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.minX != minX ||
        oldDelegate.maxX != maxX ||
        oldDelegate.minY != minY ||
        oldDelegate.maxY != maxY ||
        oldDelegate.minDelta != minDelta ||
        oldDelegate.maxDelta != maxDelta ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

class _SchematicPoint {
  const _SchematicPoint({
    required this.index,
    required this.xMachine,
    required this.yMachine,
    required this.deltaZ,
    required this.hasMeasurement,
  });

  final int index;
  final double xMachine;
  final double yMachine;
  final double deltaZ;
  final bool hasMeasurement;
}

class _TopView3DPainter extends CustomPainter {
  _TopView3DPainter({
    required this.points,
    required this.pointsX,
    required this.pointsY,
    required this.minDelta,
    required this.maxDelta,
    required this.selectedIndex,
    required this.bedWidthMm,
    required this.bedDepthMm,
    required this.cameraYaw,
    required this.cameraPitch,
    required this.cameraZoom,
    required this.cameraPan,
  });

  final List<_SchematicPoint> points;
  final int pointsX;
  final int pointsY;
  final double? minDelta;
  final double? maxDelta;
  final int selectedIndex;
  final double bedWidthMm;
  final double bedDepthMm;
  final double cameraYaw;
  final double cameraPitch;
  final double cameraZoom;
  final Offset cameraPan;

  double _norm(double value, double min, double max) {
    final double range = max - min;
    if (range.abs() < 0.000001) return 0.5;
    return (value - min) / range;
  }

  Color _colorForDelta(double delta) {
    if (minDelta == null || maxDelta == null) {
      return const Color(0x669AA1AE);
    }
    final double t = _norm(delta, minDelta!, maxDelta!).clamp(0.0, 1.0);
    final Color base = Color.lerp(
          const Color(0xFF6CA8FF),
          const Color(0xFFE85A4F),
          t,
        ) ??
        const Color(0xFF20917F);
    return base.withValues(alpha: 0.70);
  }

  Offset _project({
    required double xMm,
    required double yMm,
    required double zMm,
    required Size size,
    required double scale,
    required double zExaggeration,
  }) {
    final double centeredX = xMm - (bedWidthMm / 2.0);
    final double centeredY = yMm - (bedDepthMm / 2.0);
    final double scaledZ = zMm * zExaggeration;

    final double x1 =
        (centeredX * math.cos(cameraYaw)) - (centeredY * math.sin(cameraYaw));
    final double y1 =
        (centeredX * math.sin(cameraYaw)) + (centeredY * math.cos(cameraYaw));
    final double y2 =
        (y1 * math.cos(cameraPitch)) + (scaledZ * math.sin(cameraPitch));

    final double effectiveScale = scale * cameraZoom;
    final double sx = (size.width / 2.0) + (x1 * effectiveScale) + cameraPan.dx;
    final double sy =
        (size.height / 2.0) - (y2 * effectiveScale) + cameraPan.dy;
    return Offset(sx, sy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect frame = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    canvas.clipRect(frame);

    final double bedScaleX = frame.width / (bedWidthMm * 1.75);
    final double bedScaleY = frame.height / (bedDepthMm * 0.95);
    final double scale = math.min(bedScaleX, bedScaleY).clamp(0.15, 1.0);

    final List<Offset> bedCorners = <Offset>[
      _project(
        xMm: 0,
        yMm: 0,
        zMm: 0,
        size: size,
        scale: scale,
        zExaggeration: 1,
      ),
      _project(
        xMm: bedWidthMm,
        yMm: 0,
        zMm: 0,
        size: size,
        scale: scale,
        zExaggeration: 1,
      ),
      _project(
        xMm: bedWidthMm,
        yMm: bedDepthMm,
        zMm: 0,
        size: size,
        scale: scale,
        zExaggeration: 1,
      ),
      _project(
        xMm: 0,
        yMm: bedDepthMm,
        zMm: 0,
        size: size,
        scale: scale,
        zExaggeration: 1,
      ),
    ];

    final Path bedPath = Path()
      ..moveTo(bedCorners[0].dx, bedCorners[0].dy)
      ..lineTo(bedCorners[1].dx, bedCorners[1].dy)
      ..lineTo(bedCorners[2].dx, bedCorners[2].dy)
      ..lineTo(bedCorners[3].dx, bedCorners[3].dy)
      ..close();
    canvas.drawPath(
      bedPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(0x1E8A95A8),
    );
    canvas.drawPath(
      bedPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFF7D8898),
    );

    final Offset origin = _project(
      xMm: 0,
      yMm: 0,
      zMm: 0,
      size: size,
      scale: scale,
      zExaggeration: 1,
    );
    final Offset xAxisEnd = _project(
      xMm: math.min(180, bedWidthMm),
      yMm: 0,
      zMm: 0,
      size: size,
      scale: scale,
      zExaggeration: 1,
    );
    final Offset yAxisEnd = _project(
      xMm: 0,
      yMm: math.min(180, bedDepthMm),
      zMm: 0,
      size: size,
      scale: scale,
      zExaggeration: 1,
    );
    canvas.drawLine(
      origin,
      xAxisEnd,
      Paint()
        ..color = const Color(0xFFC74A4A)
        ..strokeWidth = 2.0,
    );
    canvas.drawLine(
      origin,
      yAxisEnd,
      Paint()
        ..color = const Color(0xFF336FC7)
        ..strokeWidth = 2.0,
    );
    canvas.drawCircle(
      origin,
      3.2,
      Paint()
        ..color = const Color(0xFF1F8A76)
        ..style = PaintingStyle.fill,
    );

    if (points.isNotEmpty) {
      double pieceMinX = points.first.xMachine;
      double pieceMaxX = points.first.xMachine;
      double pieceMinY = points.first.yMachine;
      double pieceMaxY = points.first.yMachine;
      for (final _SchematicPoint p in points) {
        if (p.xMachine < pieceMinX) pieceMinX = p.xMachine;
        if (p.xMachine > pieceMaxX) pieceMaxX = p.xMachine;
        if (p.yMachine < pieceMinY) pieceMinY = p.yMachine;
        if (p.yMachine > pieceMaxY) pieceMaxY = p.yMachine;
      }
      final List<Offset> pieceCorners = <Offset>[
        _project(
          xMm: pieceMinX,
          yMm: pieceMinY,
          zMm: 0,
          size: size,
          scale: scale,
          zExaggeration: 1,
        ),
        _project(
          xMm: pieceMaxX,
          yMm: pieceMinY,
          zMm: 0,
          size: size,
          scale: scale,
          zExaggeration: 1,
        ),
        _project(
          xMm: pieceMaxX,
          yMm: pieceMaxY,
          zMm: 0,
          size: size,
          scale: scale,
          zExaggeration: 1,
        ),
        _project(
          xMm: pieceMinX,
          yMm: pieceMaxY,
          zMm: 0,
          size: size,
          scale: scale,
          zExaggeration: 1,
        ),
      ];

      final Path piecePath = Path()
        ..moveTo(pieceCorners[0].dx, pieceCorners[0].dy)
        ..lineTo(pieceCorners[1].dx, pieceCorners[1].dy)
        ..lineTo(pieceCorners[2].dx, pieceCorners[2].dy)
        ..lineTo(pieceCorners[3].dx, pieceCorners[3].dy)
        ..close();
      canvas.drawPath(
        piecePath,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color(0x2A5AAE6B),
      );
      canvas.drawPath(
        piecePath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = const Color(0xFF4F9360),
      );
    }

    if (points.isEmpty ||
        pointsX < 2 ||
        pointsY < 2 ||
        points.length < pointsX * pointsY) {
      return;
    }

    final List<_SchematicPoint> validPoints =
        points.where((p) => p.hasMeasurement).toList();
    final double zRange = validPoints.isEmpty
        ? 1
        : ((maxDelta ?? 0) - (minDelta ?? 0)).abs().clamp(0.1, 4.0);
    final double zExaggeration = (35.0 / zRange).clamp(8.0, 45.0);

    for (int row = 0; row < pointsY - 1; row++) {
      for (int col = 0; col < pointsX - 1; col++) {
        final _SchematicPoint p00 = points[(row * pointsX) + col];
        final _SchematicPoint p10 = points[(row * pointsX) + col + 1];
        final _SchematicPoint p11 = points[((row + 1) * pointsX) + col + 1];
        final _SchematicPoint p01 = points[((row + 1) * pointsX) + col];
        if (!p00.hasMeasurement ||
            !p10.hasMeasurement ||
            !p11.hasMeasurement ||
            !p01.hasMeasurement) {
          continue;
        }

        final Offset v00 = _project(
          xMm: p00.xMachine,
          yMm: p00.yMachine,
          zMm: p00.deltaZ,
          size: size,
          scale: scale,
          zExaggeration: zExaggeration,
        );
        final Offset v10 = _project(
          xMm: p10.xMachine,
          yMm: p10.yMachine,
          zMm: p10.deltaZ,
          size: size,
          scale: scale,
          zExaggeration: zExaggeration,
        );
        final Offset v11 = _project(
          xMm: p11.xMachine,
          yMm: p11.yMachine,
          zMm: p11.deltaZ,
          size: size,
          scale: scale,
          zExaggeration: zExaggeration,
        );
        final Offset v01 = _project(
          xMm: p01.xMachine,
          yMm: p01.yMachine,
          zMm: p01.deltaZ,
          size: size,
          scale: scale,
          zExaggeration: zExaggeration,
        );

        final double avgDelta =
            (p00.deltaZ + p10.deltaZ + p11.deltaZ + p01.deltaZ) / 4;
        final Path cell = Path()
          ..moveTo(v00.dx, v00.dy)
          ..lineTo(v10.dx, v10.dy)
          ..lineTo(v11.dx, v11.dy)
          ..lineTo(v01.dx, v01.dy)
          ..close();
        canvas.drawPath(
          cell,
          Paint()
            ..style = PaintingStyle.fill
            ..color = _colorForDelta(avgDelta),
        );
        canvas.drawPath(
          cell,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.6
            ..color = const Color(0x55778293),
        );
      }
    }

    for (final _SchematicPoint point in points) {
      if (!point.hasMeasurement) {
        continue;
      }
      final Offset projected = _project(
        xMm: point.xMachine,
        yMm: point.yMachine,
        zMm: point.deltaZ,
        size: size,
        scale: scale,
        zExaggeration: zExaggeration,
      );
      final bool isSelected = point.index == selectedIndex;
      canvas.drawCircle(
        projected,
        isSelected ? 5.4 : 3.4,
        Paint()
          ..style = PaintingStyle.fill
          ..color =
              isSelected ? const Color(0xFF1F8A76) : const Color(0xFF243044),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TopView3DPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.pointsX != pointsX ||
        oldDelegate.pointsY != pointsY ||
        oldDelegate.minDelta != minDelta ||
        oldDelegate.maxDelta != maxDelta ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.bedWidthMm != bedWidthMm ||
        oldDelegate.bedDepthMm != bedDepthMm ||
        oldDelegate.cameraYaw != cameraYaw ||
        oldDelegate.cameraPitch != cameraPitch ||
        oldDelegate.cameraZoom != cameraZoom ||
        oldDelegate.cameraPan != cameraPan;
  }
}

class LevelCalibrationScreen extends StatefulWidget {
  const LevelCalibrationScreen({super.key});

  @override
  State<LevelCalibrationScreen> createState() => _LevelCalibrationScreenState();
}

class _LevelCalibrationScreenState extends State<LevelCalibrationScreen> {
  static const double _machineBedWidthMm = 800.0;
  static const double _machineBedDepthMm = 1230.0;
  static const double _default3DYaw = 0.0;
  static const double _default3DPitch = math.pi / 7;
  static const double _min3DPitch = 0.25;
  static const double _max3DPitch = 1.30;
  static const double _min3DZoom = 0.45;
  static const double _max3DZoom = 4.50;

  final TextEditingController _minXController =
      TextEditingController(text: "20");
  final TextEditingController _maxXController =
      TextEditingController(text: "180");
  final TextEditingController _minYController =
      TextEditingController(text: "20");
  final TextEditingController _maxYController =
      TextEditingController(text: "180");
  final TextEditingController _pointsXController =
      TextEditingController(text: "5");
  final TextEditingController _pointsYController =
      TextEditingController(text: "5");
  final TextEditingController _safeZController =
      TextEditingController(text: "189");
  final TextEditingController _manualZController = TextEditingController();
  final TextEditingController _mapFileNameController =
      TextEditingController(text: "heightmap_piece.csv");
  final TextEditingController _clipPositiveController =
      TextEditingController(text: "1.00");
  final TextEditingController _clipNegativeController =
      TextEditingController(text: "1.00");

  StreamSubscription? _machineSubscription;

  final List<_LevelPoint> _points = <_LevelPoint>[];
  int _selectedIndex = 0;
  int _pointsX = 0;
  int _pointsY = 0;
  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _offsetXMachineMinusUser = 0;
  double _offsetYMachineMinusUser = 0;
  double _offsetZMachineMinusUser = 0;
  bool _hasUserToMachineTransform = false;
  bool _clipCompensationEnabled = false;
  bool _showSchematic3D = false;
  double _cameraYaw = _default3DYaw;
  double _cameraPitch = _default3DPitch;
  double _cameraZoom = 1.0;
  Offset _cameraPan = Offset.zero;
  double _gestureStartYaw = _default3DYaw;
  double _gestureStartZoom = 1.0;
  Offset _gestureStartPan = Offset.zero;
  Offset _gestureStartFocalPoint = Offset.zero;
  int _activePointerCount = 0;
  bool _isInMultiTouchGesture = false;
  bool _hasShownBetaWarning = false;
  static const List<String> _zJogStepOptions = <String>[
    "10",
    "1",
    "0.1",
    "0.01"
  ];
  String _selectedZJogStep = "1";
  double? _referenceZ;
  bool _isBusy = false;
  String _status =
      "Configurer la grille en coordonnees utilisateur puis mapper les points.";

  @override
  void initState() {
    super.initState();
    pageToShow = 9;
    _machineSubscription = global.streamMachineObjectModel.listen((_) {
      if (!mounted) return;
      setState(() {});
    });
    global.checkAndShowDialog(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBetaWarningIfNeeded();
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      if (global.MyMachineN02Config.HasFanOnEnclosure == 1) {
        global.checkCaissonOpen(context);
      }
    });
  }

  void _reset3DCamera() {
    setState(() {
      _cameraYaw = _default3DYaw;
      _cameraPitch = _default3DPitch;
      _cameraZoom = 1.0;
      _cameraPan = Offset.zero;
    });
  }

  void _on3DPointerDown(PointerDownEvent _) {
    _activePointerCount++;
  }

  void _on3DPointerUpOrCancel(PointerEvent _) {
    _activePointerCount = (_activePointerCount - 1).clamp(0, 10).toInt();
    if (_activePointerCount < 2) {
      _isInMultiTouchGesture = false;
    }
  }

  void _on3DScaleStart(ScaleStartDetails details) {
    _gestureStartYaw = _cameraYaw;
    _gestureStartZoom = _cameraZoom;
    _gestureStartPan = _cameraPan;
    _gestureStartFocalPoint = details.focalPoint;
    _isInMultiTouchGesture = _activePointerCount >= 2;
  }

  void _on3DScaleUpdate(ScaleUpdateDetails details) {
    final bool multiTouch = _activePointerCount >= 2;
    if (multiTouch && !_isInMultiTouchGesture) {
      _gestureStartYaw = _cameraYaw;
      _gestureStartZoom = _cameraZoom;
      _gestureStartPan = _cameraPan;
      _gestureStartFocalPoint = details.focalPoint;
      _isInMultiTouchGesture = true;
    } else if (!multiTouch) {
      _isInMultiTouchGesture = false;
    }

    if (multiTouch) {
      setState(() {
        _cameraZoom =
            (_gestureStartZoom * details.scale).clamp(_min3DZoom, _max3DZoom);
        _cameraYaw = _gestureStartYaw + details.rotation;
        _cameraPan =
            _gestureStartPan + (_gestureStartFocalPoint - details.focalPoint);
      });
      return;
    }

    setState(() {
      _cameraYaw += details.focalPointDelta.dx * 0.0085;
      _cameraPitch = (_cameraPitch - (details.focalPointDelta.dy * 0.0065))
          .clamp(_min3DPitch, _max3DPitch);
      if ((details.scale - 1.0).abs() > 0.0001) {
        _cameraZoom =
            (_cameraZoom * details.scale).clamp(_min3DZoom, _max3DZoom);
      }
    });
  }

  void _on3DPointerSignal(dynamic event) {
    try {
      final dynamic scrollDelta = event.scrollDelta;
      if (scrollDelta == null) {
        return;
      }
      setState(() {
        final double dy = (scrollDelta.dy as num?)?.toDouble() ?? 0.0;
        final double factor = dy > 0 ? 0.92 : 1.08;
        _cameraZoom = (_cameraZoom * factor).clamp(_min3DZoom, _max3DZoom);
      });
    } catch (_) {
      return;
    }
  }

  Future<void> _showBetaWarningIfNeeded() async {
    if (!mounted || _hasShownBetaWarning) {
      return;
    }
    _hasShownBetaWarning = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFC46B22)),
              SizedBox(width: 8),
              Text("Avertissement BETA"),
            ],
          ),
          content: const Text(
            "Cette page de calibration est en BETA.\n\n"
            "Verifier systematiquement le comportement de l'axe Z avant et pendant les deplacements.\n"
            "En cas de doute, arreter immediatement la machine.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("J'ai compris"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _machineSubscription?.cancel();
    _minXController.dispose();
    _maxXController.dispose();
    _minYController.dispose();
    _maxYController.dispose();
    _pointsXController.dispose();
    _pointsYController.dispose();
    _safeZController.dispose();
    _manualZController.dispose();
    _mapFileNameController.dispose();
    _clipPositiveController.dispose();
    _clipNegativeController.dispose();
    super.dispose();
  }

  String _axisText(int axisIndex) {
    final axes = global.machineObjectModel.result?.move?.axes;
    if (axes == null || axes.length <= axisIndex) {
      return "...";
    }
    return axes.elementAt(axisIndex).userPosition?.toStringAsFixed(2) ?? "...";
  }

  double? _axisMachineValue(int axisIndex) {
    final axes = global.machineObjectModel.result?.move?.axes;
    if (axes == null || axes.length <= axisIndex) {
      return null;
    }
    final num? value = axes.elementAt(axisIndex).machinePosition;
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  double? _axisUserValue(int axisIndex) {
    final axes = global.machineObjectModel.result?.move?.axes;
    if (axes == null || axes.length <= axisIndex) {
      return null;
    }
    final num? value = axes.elementAt(axisIndex).userPosition;
    if (value == null) {
      return null;
    }
    return double.tryParse(value.toString());
  }

  bool _captureUserToMachineTransform() {
    final double? machineX = _axisMachineValue(0);
    final double? machineY = _axisMachineValue(1);
    final double? machineZ = _axisMachineValue(2);
    final double? userX = _axisUserValue(0);
    final double? userY = _axisUserValue(1);
    final double? userZ = _axisUserValue(2);

    if (machineX == null ||
        machineY == null ||
        machineZ == null ||
        userX == null ||
        userY == null ||
        userZ == null) {
      _hasUserToMachineTransform = false;
      return false;
    }

    _offsetXMachineMinusUser = machineX - userX;
    _offsetYMachineMinusUser = machineY - userY;
    _offsetZMachineMinusUser = machineZ - userZ;
    _hasUserToMachineTransform = true;
    return true;
  }

  double _userToMachine(int axisIndex, double userValue) {
    switch (axisIndex) {
      case 0:
        return userValue + _offsetXMachineMinusUser;
      case 1:
        return userValue + _offsetYMachineMinusUser;
      case 2:
        return userValue + _offsetZMachineMinusUser;
      default:
        return userValue;
    }
  }

  bool _machineCanCalibrate() {
    final String status =
        global.machineObjectModel.result?.state?.status?.toString() ?? "";
    return status == "idle" || status == "paused";
  }

  double? _parseDouble(String value) {
    return double.tryParse(value.replaceAll(",", "."));
  }

  int? _parseInt(String value) {
    return int.tryParse(value.trim());
  }

  String _normalizeMapFileName() {
    String name = _mapFileNameController.text.trim();
    if (name.isEmpty) {
      name = "heightmap_piece.csv";
    }
    if (!name.toLowerCase().endsWith(".csv")) {
      name = "$name.csv";
    }
    _mapFileNameController.text = name;
    return name;
  }

  Future<void> _createGrid() async {
    final double? minX = _parseDouble(_minXController.text);
    final double? maxX = _parseDouble(_maxXController.text);
    final double? minY = _parseDouble(_minYController.text);
    final double? maxY = _parseDouble(_maxYController.text);
    final int? pointsX = _parseInt(_pointsXController.text);
    final int? pointsY = _parseInt(_pointsYController.text);

    if (minX == null ||
        maxX == null ||
        minY == null ||
        maxY == null ||
        pointsX == null ||
        pointsY == null) {
      setState(() {
        _status = "Valeurs invalides dans la configuration de grille.";
      });
      return;
    }
    if (maxX <= minX || maxY <= minY || pointsX < 2 || pointsY < 2) {
      setState(() {
        _status = "Verifier min/max et nombre de points (>=2).";
      });
      return;
    }
    if (!_machineCanCalibrate()) {
      setState(() {
        _status = "Machine non prete (etat requis: idle ou paused).";
      });
      return;
    }
    if (!_captureUserToMachineTransform()) {
      setState(() {
        _status =
            "Impossible de calculer la conversion utilisateur->machine (axes non disponibles).";
      });
      return;
    }

    final List<_LevelPoint> generated = <_LevelPoint>[];
    final double stepX = (maxX - minX) / (pointsX - 1);
    final double stepY = (maxY - minY) / (pointsY - 1);
    int index = 0;
    for (int row = 0; row < pointsY; row++) {
      for (int col = 0; col < pointsX; col++) {
        generated.add(
          _LevelPoint(
            index: index,
            x: minX + (stepX * col),
            y: minY + (stepY * row),
          ),
        );
        index++;
      }
    }

    final double minXMachine = _userToMachine(0, minX);
    final double maxXMachine = _userToMachine(0, maxX);
    final double minYMachine = _userToMachine(1, minY);
    final double maxYMachine = _userToMachine(1, maxY);
    final String m557Command =
        "M557 X${minXMachine.toStringAsFixed(3)}:${maxXMachine.toStringAsFixed(3)} Y${minYMachine.toStringAsFixed(3)}:${maxYMachine.toStringAsFixed(3)} P$pointsX:$pointsY";
    await API_Manager().sendGcodeCommand(m557Command);
    await API_Manager().sendrr_reply();

    setState(() {
      _points
        ..clear()
        ..addAll(generated);
      _selectedIndex = 0;
      _pointsX = pointsX;
      _pointsY = pointsY;
      _minX = minX;
      _maxX = maxX;
      _minY = minY;
      _maxY = maxY;
      _referenceZ = null;
      _status =
          "Grille creee en coordonnees utilisateur ($pointsX x $pointsY). Conversion et M557 machine appliques.";
    });
  }

  Future<void> _runBusyTask(Future<void> Function() task) async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
    });
    try {
      await task();
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      } else {
        _isBusy = false;
      }
    }
  }

  Future<void> _goToSelectedPoint() async {
    if (_points.isEmpty || _selectedIndex >= _points.length) return;
    if (!_machineCanCalibrate()) {
      setState(() {
        _status = "Machine non prete pour un deplacement de calibration.";
      });
      return;
    }

    final _LevelPoint point = _points[_selectedIndex];
    final double safeZMachine = _parseDouble(_safeZController.text) ?? 189.0;

    await _runBusyTask(() async {
      if (!_hasUserToMachineTransform && !_captureUserToMachineTransform()) {
        if (!mounted) return;
        setState(() {
          _status =
              "Conversion utilisateur->machine indisponible pour le deplacement.";
        });
        return;
      }
      final double xMachine = _userToMachine(0, point.x);
      final double yMachine = _userToMachine(1, point.y);

      await API_Manager()
          .sendGcodeCommand("G53 G0 Z${safeZMachine.toStringAsFixed(3)}");
      await API_Manager().sendGcodeCommand(
          "G53 G0 X${xMachine.toStringAsFixed(3)} Y${yMachine.toStringAsFixed(3)}");
      await API_Manager().sendGcodeCommand("M400");
      await API_Manager().waitUntilMachineIsStill(
        stableDuration: const Duration(milliseconds: 300),
        maxWait: const Duration(seconds: 20),
      );
      if (!mounted) return;
      setState(() {
        _status = "Tete positionnee au point ${point.index + 1} "
            "(remontee Z machine=${safeZMachine.toStringAsFixed(2)}) "
            "(User X${point.x.toStringAsFixed(2)} Y${point.y.toStringAsFixed(2)} -> "
            "Machine X${xMachine.toStringAsFixed(2)} Y${yMachine.toStringAsFixed(2)}).";
      });
    });
  }

  Future<void> _jogZDown() async {
    if (!_machineCanCalibrate()) {
      setState(() {
        _status = "Machine non prete pour une descente Z manuelle.";
      });
      return;
    }

    final String step = _selectedZJogStep;
    await _runBusyTask(() async {
      await API_Manager().sendGcodeCommand("G91");
      await API_Manager().sendGcodeCommand("G1 Z-$step F300");
      await API_Manager().sendGcodeCommand("G90");
      await API_Manager().sendGcodeCommand("M400");
      await API_Manager().waitUntilMachineIsStill(
        stableDuration: const Duration(milliseconds: 200),
        maxWait: const Duration(seconds: 10),
      );
      if (!mounted) return;
      setState(() {
        _status =
            "Descente Z de $step mm executee (G91 + G1 Z-$step F300 + G90).";
      });
    });
  }

  void _storeMeasurement(double rawZ, String source) {
    if (_points.isEmpty || _selectedIndex >= _points.length) return;
    _referenceZ ??= rawZ;

    final _LevelPoint point = _points[_selectedIndex];
    point.rawZ = rawZ;
    point.deltaZ = rawZ - _referenceZ!;
    point.source = source;

    setState(() {
      _status =
          "Point ${point.index + 1} mesure: Z=${rawZ.toStringAsFixed(4)} dZ=${point.deltaZ!.toStringAsFixed(4)} ($source).";
    });
  }

  Future<void> _captureManualZ() async {
    final double? zValue = _parseDouble(_manualZController.text);
    if (zValue == null) {
      setState(() {
        _status = "Entrer une valeur Z manuelle valide.";
      });
      return;
    }
    _storeMeasurement(zValue, "manuel");
  }

  Future<void> _captureCurrentZ() async {
    final double? zValue = _axisUserValue(2);
    if (zValue == null) {
      setState(() {
        _status = "Impossible de lire la position Z utilisateur actuelle.";
      });
      return;
    }
    _storeMeasurement(zValue, "Z actuel");
  }

  double? _extractProbeZ(String reply) {
    if (reply.isEmpty) return null;

    final RegExp explicitZ = RegExp(r"[Zz][^0-9+\-]*([+\-]?\d+(?:[.,]\d+)?)");
    final Match? zMatch = explicitZ.firstMatch(reply);
    if (zMatch != null && zMatch.groupCount >= 1) {
      return _parseDouble(zMatch.group(1)!);
    }

    final Iterable<Match> allNumbers =
        RegExp(r"[+\-]?\d+(?:[.,]\d+)?").allMatches(reply);
    if (allNumbers.isEmpty) {
      return null;
    }
    return _parseDouble(allNumbers.last.group(0)!);
  }

  Future<void> _captureProbeZ() async {
    if (!_machineCanCalibrate()) {
      setState(() {
        _status = "Machine non prete pour le palpage.";
      });
      return;
    }
    await _runBusyTask(() async {
      await API_Manager().sendGcodeCommand("G30 S-1");
      final String reply = await API_Manager().sendrr_reply();
      final double? probeZ = _extractProbeZ(reply) ?? _axisUserValue(2);

      if (probeZ == null) {
        if (!mounted) return;
        setState(() {
          _status = "Palpage termine mais valeur Z introuvable.";
        });
        return;
      }

      _storeMeasurement(probeZ, "palpage");
    });
  }

  MapEntry<String, String>? _resolveCompensationPath(String rawPath) {
    String value = rawPath.trim();
    if (value.isEmpty || value == "-" || value.toLowerCase() == "none") {
      return null;
    }
    value = value.replaceAll('"', '').replaceAll("\\", "/");

    final int sdPrefixIndex = value.indexOf(":/");
    if (sdPrefixIndex >= 0) {
      value = value.substring(sdPrefixIndex + 2);
    }
    if (value.startsWith("/")) {
      value = value.substring(1);
    }
    if (value.isEmpty) {
      return null;
    }

    final List<String> parts =
        value.split("/").where((segment) => segment.isNotEmpty).toList();
    if (parts.isEmpty) {
      return null;
    }
    final String fileName = parts.last;
    final String path =
        parts.length > 1 ? parts.sublist(0, parts.length - 1).join("/") : "sys";
    return MapEntry<String, String>(path, fileName);
  }

  _ParsedHeightmap? _parseHeightmapCsv(String content) {
    final List<String> lines = content
        .split(RegExp(r"\r?\n"))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.length < 4) {
      return null;
    }

    int descriptorLineIndex = -1;
    List<String> descriptor = <String>[];
    for (int i = 0; i < lines.length; i++) {
      final List<String> values =
          lines[i].split(",").map((e) => e.trim()).toList();
      if (values.length >= 11 &&
          values[0].toUpperCase() == "X" &&
          values[1].toUpperCase() == "Y") {
        descriptorLineIndex = i;
        descriptor = values;
        break;
      }
    }
    if (descriptorLineIndex < 0) {
      return null;
    }

    final double? minX = _parseDouble(descriptor[2]);
    final double? maxX = _parseDouble(descriptor[3]);
    final double? minY = _parseDouble(descriptor[4]);
    final double? maxY = _parseDouble(descriptor[5]);
    final int? pointsX = _parseInt(descriptor[9]);
    final int? pointsY = _parseInt(descriptor[10]);
    if (minX == null ||
        maxX == null ||
        minY == null ||
        maxY == null ||
        pointsX == null ||
        pointsY == null ||
        pointsX < 2 ||
        pointsY < 2) {
      return null;
    }

    final int firstDataLine = descriptorLineIndex + 1;
    if (lines.length < firstDataLine + pointsY) {
      return null;
    }

    final List<double> deltas = <double>[];
    for (int row = 0; row < pointsY; row++) {
      final List<String> values =
          lines[firstDataLine + row].split(",").map((e) => e.trim()).toList();
      if (values.length < pointsX) {
        return null;
      }
      for (int col = 0; col < pointsX; col++) {
        deltas.add(_parseDouble(values[col]) ?? 0.0);
      }
    }

    return _ParsedHeightmap(
      pointsX: pointsX,
      pointsY: pointsY,
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      deltas: deltas,
    );
  }

  Future<void> _loadAndVisualizeActiveMap() async {
    final String compensationFileRaw =
        global.objectModelMove.result?.compensation?.file?.toString() ?? "";
    MapEntry<String, String>? target =
        _resolveCompensationPath(compensationFileRaw);
    if (target == null) {
      final String fallbackFile = _normalizeMapFileName();
      target = MapEntry<String, String>("sys", fallbackFile);
    }
    final MapEntry<String, String> resolvedTarget = target;

    await _runBusyTask(() async {
      final String content = await API_Manager()
          .downLoadAFile(resolvedTarget.key, resolvedTarget.value);
      if (content.toLowerCase() == "nok") {
        if (!mounted) return;
        setState(() {
          _status =
              "Impossible de telecharger la map active (${resolvedTarget.key}/${resolvedTarget.value}).";
        });
        return;
      }

      final _ParsedHeightmap? parsed = _parseHeightmapCsv(content);
      if (parsed == null) {
        if (!mounted) return;
        setState(() {
          _status =
              "Fichier ${resolvedTarget.value} invalide: format heightmap non reconnu.";
        });
        return;
      }

      if (!_hasUserToMachineTransform) {
        _captureUserToMachineTransform();
      }
      final bool hasTransform = _hasUserToMachineTransform;
      final double stepX = parsed.pointsX > 1
          ? (parsed.maxX - parsed.minX) / (parsed.pointsX - 1)
          : 0;
      final double stepY = parsed.pointsY > 1
          ? (parsed.maxY - parsed.minY) / (parsed.pointsY - 1)
          : 0;

      final List<_LevelPoint> loaded = <_LevelPoint>[];
      int index = 0;
      for (int row = 0; row < parsed.pointsY; row++) {
        for (int col = 0; col < parsed.pointsX; col++) {
          final double xMachine = parsed.minX + (stepX * col);
          final double yMachine = parsed.minY + (stepY * row);
          final double xUser =
              hasTransform ? xMachine - _offsetXMachineMinusUser : xMachine;
          final double yUser =
              hasTransform ? yMachine - _offsetYMachineMinusUser : yMachine;
          final _LevelPoint point = _LevelPoint(
            index: index,
            x: xUser,
            y: yUser,
          );
          final double delta = parsed.deltas[index];
          point.rawZ = delta;
          point.deltaZ = delta;
          point.source = "map active";
          loaded.add(point);
          index++;
        }
      }

      if (!mounted) return;
      setState(() {
        _points
          ..clear()
          ..addAll(loaded);
        _selectedIndex = 0;
        _pointsX = parsed.pointsX;
        _pointsY = parsed.pointsY;
        _minX =
            hasTransform ? parsed.minX - _offsetXMachineMinusUser : parsed.minX;
        _maxX =
            hasTransform ? parsed.maxX - _offsetXMachineMinusUser : parsed.maxX;
        _minY =
            hasTransform ? parsed.minY - _offsetYMachineMinusUser : parsed.minY;
        _maxY =
            hasTransform ? parsed.maxY - _offsetYMachineMinusUser : parsed.maxY;
        _referenceZ = 0;
        _mapFileNameController.text = resolvedTarget.value;
        _status =
            "Map active chargee (${resolvedTarget.value}, ${parsed.pointsX}x${parsed.pointsY}) "
            "et affichee ${hasTransform ? "en coordonnees utilisateur" : "en coordonnees machine"}.";
      });
    });
  }

  void _selectPreviousPoint() {
    if (_points.isEmpty) return;
    setState(() {
      _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex - 1;
    });
  }

  void _selectNextPoint() {
    if (_points.isEmpty) return;
    setState(() {
      _selectedIndex = _selectedIndex >= _points.length - 1
          ? _points.length - 1
          : _selectedIndex + 1;
    });
  }

  double _clampDelta(
    double value, {
    required double maxPositive,
    required double maxNegative,
  }) {
    if (value > maxPositive) {
      return maxPositive;
    }
    if (value < -maxNegative) {
      return -maxNegative;
    }
    return value;
  }

  _HeightmapCsvBuildResult? _buildHeightmapCsv({
    required bool applyClamp,
    required double maxPositiveClamp,
    required double maxNegativeClamp,
  }) {
    if (_points.isEmpty || _pointsX < 2 || _pointsY < 2) {
      return null;
    }

    final double minXMachine = _userToMachine(0, _minX);
    final double maxXMachine = _userToMachine(0, _maxX);
    final double minYMachine = _userToMachine(1, _minY);
    final double maxYMachine = _userToMachine(1, _maxY);
    final double spacingX =
        _pointsX > 1 ? (maxXMachine - minXMachine) / (_pointsX - 1) : 0;
    final double spacingY =
        _pointsY > 1 ? (maxYMachine - minYMachine) / (_pointsY - 1) : 0;

    int clippedPoints = 0;
    int measuredPoints = 0;
    final StringBuffer buffer = StringBuffer();
    buffer.writeln("RepRapFirmware height map file v2 generated by nweb");
    buffer.writeln(
        "axis0,axis1,min0,max0,min1,max1,radius,spacing0,spacing1,num0,num1");
    buffer.writeln(
      "X,Y,${minXMachine.toStringAsFixed(2)},${maxXMachine.toStringAsFixed(2)},${minYMachine.toStringAsFixed(2)},${maxYMachine.toStringAsFixed(2)},-1.00,${spacingX.toStringAsFixed(2)},${spacingY.toStringAsFixed(2)},$_pointsX,$_pointsY",
    );

    for (int row = 0; row < _pointsY; row++) {
      final List<String> values = <String>[];
      for (int col = 0; col < _pointsX; col++) {
        final _LevelPoint point = _points[(row * _pointsX) + col];
        if (!point.hasMeasurement) {
          values.add("0");
          continue;
        }

        measuredPoints++;
        final double rawDelta = point.deltaZ!;
        final double finalDelta = applyClamp
            ? _clampDelta(
                rawDelta,
                maxPositive: maxPositiveClamp,
                maxNegative: maxNegativeClamp,
              )
            : rawDelta;
        if ((finalDelta - rawDelta).abs() > 0.000001) {
          clippedPoints++;
        }
        values.add(finalDelta.toStringAsFixed(4));
      }
      buffer.writeln(values.join(","));
    }

    return _HeightmapCsvBuildResult(
      content: buffer.toString(),
      clippedPoints: clippedPoints,
      measuredPoints: measuredPoints,
    );
  }

  String _describeClippingStatus(_HeightmapCsvBuildResult csvResult) {
    if (!_clipCompensationEnabled) {
      return "sans ecretage";
    }
    return "ecretage ON (+${_clipPositiveController.text} / -${_clipNegativeController.text} mm, ${csvResult.clippedPoints}/${csvResult.measuredPoints} points limites)";
  }

  Future<void> _saveHeightmapFile({bool activateAfterSave = false}) async {
    if (_points.isEmpty) {
      setState(() {
        _status = "Creer une grille avant de sauvegarder.";
      });
      return;
    }
    if (!_points.any((p) => p.hasMeasurement)) {
      setState(() {
        _status = "Aucun point mesure.";
      });
      return;
    }
    if (!_hasUserToMachineTransform && !_captureUserToMachineTransform()) {
      setState(() {
        _status =
            "Impossible de calculer la conversion utilisateur->machine pour sauvegarder la map.";
      });
      return;
    }

    double maxPositiveClamp = double.infinity;
    double maxNegativeClamp = double.infinity;
    if (_clipCompensationEnabled) {
      final double? positive = _parseDouble(_clipPositiveController.text);
      final double? negative = _parseDouble(_clipNegativeController.text);
      if (positive == null ||
          negative == null ||
          positive <= 0 ||
          negative <= 0) {
        setState(() {
          _status =
              "Renseigner des limites d'ecretage valides (> 0) pour Z+ et Z-.";
        });
        return;
      }
      maxPositiveClamp = positive;
      maxNegativeClamp = negative;
    }

    final _HeightmapCsvBuildResult? csvResult = _buildHeightmapCsv(
      applyClamp: _clipCompensationEnabled,
      maxPositiveClamp: maxPositiveClamp,
      maxNegativeClamp: maxNegativeClamp,
    );
    if (csvResult == null || csvResult.content.isEmpty) {
      setState(() {
        _status = "Generation du fichier heightmap impossible.";
      });
      return;
    }

    final String fileName = _normalizeMapFileName();
    await _runBusyTask(() async {
      final String result = await API_Manager().upLoadAFile(
        "0:/sys/$fileName",
        csvResult.content.length.toString(),
        Uint8List.fromList(csvResult.content.codeUnits),
      );
      if (result != "ok") {
        if (!mounted) return;
        setState(() {
          _status = "Echec de sauvegarde de /sys/$fileName.";
        });
        return;
      }

      if (activateAfterSave) {
        await API_Manager().sendGcodeCommand('G29 S1 P"$fileName"');
        final String reply = await API_Manager().sendrr_reply();
        if (!mounted) return;
        setState(() {
          _status = "Map /sys/$fileName sauvegardee et compensation activee. "
              "${_describeClippingStatus(csvResult)}. $reply";
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _status = "Fichier /sys/$fileName sauvegarde "
            "(${_describeClippingStatus(csvResult)}).";
      });
    });
  }

  Future<void> _activateCompensation() async {
    final String fileName = _normalizeMapFileName();
    await _runBusyTask(() async {
      await API_Manager().sendGcodeCommand('G29 S1 P"$fileName"');
      final String reply = await API_Manager().sendrr_reply();
      if (!mounted) return;
      setState(() {
        _status = "Activation compensation demandee (G29 S1). $reply";
      });
    });
  }

  bool? _readZHomedState() {
    final axes = global.objectModelMove.result?.axes;
    if (axes == null || axes.length <= 2) {
      return null;
    }
    return axes.elementAt(2).homed;
  }

  Future<bool?> _requestZUnhomeAndWait({
    Duration timeout = const Duration(seconds: 2),
  }) async {
    await API_Manager().sendGcodeCommand("M18 Z");
    final DateTime start = DateTime.now();
    bool? lastState = _readZHomedState();
    while (DateTime.now().difference(start) < timeout) {
      await Future.delayed(const Duration(milliseconds: 150));
      lastState = _readZHomedState();
      if (lastState == false) {
        return false;
      }
    }
    return lastState;
  }

  Future<void> _disableCompensation() async {
    await _runBusyTask(() async {
      await API_Manager().sendGcodeCommand("G29 S2");
      final String reply = await API_Manager().sendrr_reply();
      final bool? zHomedState = await _requestZUnhomeAndWait();
      if (!mounted) return;
      setState(() {
        if (zHomedState == false) {
          _status =
              "Compensation desactivee (G29 S2). Axe Z passe en unhomed (M18 Z). Refaire un homing Z avant tout deplacement. $reply";
        } else {
          _status =
              "Compensation desactivee (G29 S2). Demande unhomed Z envoyee (M18 Z) mais etat non confirme. Verifier l'etat Z puis refaire un homing Z. $reply";
        }
      });
    });
  }

  Future<void> _deleteCompensationFile() async {
    final String fileName = _normalizeMapFileName();
    await _runBusyTask(() async {
      await API_Manager().sendGcodeCommand("G29 S2");
      final bool? zHomedState = await _requestZUnhomeAndWait();
      final String result = await API_Manager().deleteAFile(fileName, "sys");
      if (!mounted) return;
      setState(() {
        if (result == "ok" && zHomedState == false) {
          _status =
              "Compensation retiree, Z passe en unhomed (M18 Z), fichier /sys/$fileName supprime. Refaire un homing Z.";
        } else if (result == "ok") {
          _status =
              "Compensation retiree et fichier /sys/$fileName supprime. Demande unhomed Z envoyee (M18 Z) mais etat non confirme.";
        } else {
          _status = "Suppression du fichier /sys/$fileName en echec.";
        }
      });
    });
  }

  bool _isCompensationEnabled() {
    final String type = global.objectModelMove.result?.compensation?.type
            ?.toString()
            .toLowerCase() ??
        "none";
    return type != "none" && type != "nil" && type.isNotEmpty;
  }

  Future<void> _toggleCompensation(bool enabled) async {
    if (enabled) {
      await _activateCompensation();
      return;
    }
    await _disableCompensation();
  }

  Widget _buildNumericField(
    TextEditingController controller,
    String label, {
    bool integerOnly = false,
    double width = 90,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
            integerOnly ? RegExp(r"[0-9]") : RegExp(r"[-0-9.,]"),
          ),
        ],
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  Widget _buildZJogStepSelector() {
    return Tooltip(
      message:
          "Choix du pas de descente Z en mm. Utilise ensuite le bouton Descendre Z.",
      waitDuration: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EEF5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD0D8E4)),
        ),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Pas Z",
              style: TextStyle(
                color: Color(0xFF4E596C),
                fontWeight: FontWeight.w700,
              ),
            ),
            for (final String step in _zJogStepOptions)
              ChoiceChip(
                label: Text("$step mm"),
                selected: _selectedZJogStep == step,
                onSelected: _isBusy
                    ? null
                    : (bool selected) {
                        if (!selected) return;
                        setState(() {
                          _selectedZJogStep = step;
                        });
                      },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompensationClampPanel() {
    return Tooltip(
      message:
          "Ecrete la map avant sauvegarde: dZ est limite entre -Max Z- et +Max Z+ (en mm).",
      waitDuration: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EEF5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD0D8E4)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Ecretage compensation",
              style: TextStyle(
                color: Color(0xFF4E596C),
                fontWeight: FontWeight.w700,
              ),
            ),
            Switch.adaptive(
              value: _clipCompensationEnabled,
              onChanged: _isBusy
                  ? null
                  : (bool value) {
                      setState(() {
                        _clipCompensationEnabled = value;
                      });
                    },
            ),
            _buildNumericField(_clipPositiveController, "Max Z+", width: 95),
            _buildNumericField(_clipNegativeController, "Max Z-", width: 95),
            const Text(
              "mm",
              style: TextStyle(
                color: Color(0xFF4E596C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltipActionButton({
    required String label,
    required String tooltipMessage,
    required VoidCallback? onPressed,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Tooltip(
      message: tooltipMessage,
      waitDuration: const Duration(milliseconds: 250),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 1.5,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTag(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE6F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFB7C3D4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: const Color(0xFF40516A)),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF40516A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  bool _statusLooksLikeError() {
    final String lower = _status.toLowerCase();
    return lower.contains("error") ||
        lower.contains("echec") ||
        lower.contains("impossible") ||
        lower.contains("introuvable") ||
        lower.contains("not found") ||
        lower.contains("non prete");
  }

  Widget _buildStatusBanner() {
    final int measuredCount = _points.where((p) => p.hasMeasurement).length;
    final int totalCount = _points.length;
    final double progress =
        totalCount == 0 ? 0 : (measuredCount / totalCount).clamp(0.0, 1.0);

    final bool isError = _statusLooksLikeError();
    final Color accent = _isBusy
        ? const Color(0xFFCC7A00)
        : isError
            ? const Color(0xFFB44747)
            : const Color(0xFF1F8A76);
    final IconData icon = _isBusy
        ? Icons.hourglass_top_rounded
        : isError
            ? Icons.warning_amber_rounded
            : Icons.task_alt_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD2D9E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _status,
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (totalCount > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(accent),
                      backgroundColor: const Color(0xFFE4E9EF),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "$measuredCount/$totalCount",
                  style: const TextStyle(
                    color: Color(0xFF5D6170),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBadge({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFD0D8E4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4E596C)),
          const SizedBox(width: 6),
          Text(
            "$label$value",
            style: const TextStyle(
              color: Color(0xFF4E596C),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  _DeltaRange _deltaRange() {
    final List<double> values =
        _points.where((p) => p.hasMeasurement).map((p) => p.deltaZ!).toList();
    if (values.isEmpty) {
      return const _DeltaRange(min: null, max: null);
    }
    double minValue = values.first;
    double maxValue = values.first;
    for (final double v in values) {
      if (v < minValue) minValue = v;
      if (v > maxValue) maxValue = v;
    }
    return _DeltaRange(min: minValue, max: maxValue);
  }

  Widget _buildLegendChip(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: const Color(0xFF778090)),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF59606D),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  List<_SchematicPoint> _buildMachineSchematicPoints() {
    final bool hasTransform = _hasUserToMachineTransform;
    return _points
        .map(
          (_LevelPoint p) => _SchematicPoint(
            index: p.index,
            xMachine: hasTransform ? _userToMachine(0, p.x) : p.x,
            yMachine: hasTransform ? _userToMachine(1, p.y) : p.y,
            deltaZ: p.deltaZ ?? 0,
            hasMeasurement: p.hasMeasurement,
          ),
        )
        .toList(growable: false);
  }

  Widget _buildInteractive3DSchematic({
    required List<_SchematicPoint> machinePoints,
    required _DeltaRange range,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: const Color(0xFFF4F7FB),
        child: Stack(
          children: [
            Listener(
              onPointerDown: _on3DPointerDown,
              onPointerUp: _on3DPointerUpOrCancel,
              onPointerCancel: _on3DPointerUpOrCancel,
              onPointerSignal: _on3DPointerSignal,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _on3DScaleStart,
                onScaleUpdate: _on3DScaleUpdate,
                child: CustomPaint(
                  painter: _TopView3DPainter(
                    points: machinePoints,
                    pointsX: _pointsX,
                    pointsY: _pointsY,
                    minDelta: range.min,
                    maxDelta: range.max,
                    selectedIndex: _selectedIndex,
                    bedWidthMm: _machineBedWidthMm,
                    bedDepthMm: _machineBedDepthMm,
                    cameraYaw: _cameraYaw,
                    cameraPitch: _cameraPitch,
                    cameraZoom: _cameraZoom,
                    cameraPan: _cameraPan,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: const Color(0xDDF3F6FA),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _reset3DCamera,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.restart_alt_rounded,
                          size: 16,
                          color: Color(0xFF3E4C63),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Reset vue",
                          style: TextStyle(
                            color: Color(0xFF3E4C63),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xDDF3F6FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCAD3E0)),
                ),
                child: const Text(
                  "1 doigt: rotation | 2 doigts: zoom + pan + rotation | molette/pad: zoom",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4E596C),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopViewPanel() {
    if (_points.isEmpty) {
      return const Center(
        child: Text(
          "La vue schematique apparaitra\napres creation de la grille.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF707585)),
        ),
      );
    }

    final _DeltaRange range = _deltaRange();
    final int measuredCount = _points.where((p) => p.hasMeasurement).length;
    final int undefinedCount = _points.length - measuredCount;
    final List<_SchematicPoint> machinePoints = _buildMachineSchematicPoints();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EEF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD0D8E4)),
                ),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      "Vue",
                      style: TextStyle(
                        color: Color(0xFF4E596C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text("2D"),
                      selected: !_showSchematic3D,
                      onSelected: (bool selected) {
                        if (!selected) return;
                        setState(() {
                          _showSchematic3D = false;
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text("3D"),
                      selected: _showSchematic3D,
                      onSelected: (bool selected) {
                        if (!selected) return;
                        setState(() {
                          _showSchematic3D = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Plateau ${_machineBedWidthMm.toStringAsFixed(0)} x ${_machineBedDepthMm.toStringAsFixed(0)} mm"
                  "${_showSchematic3D ? " | Repere machine: X+ droite, Y+ haut, origine bas-gauche" : ""}",
                  style: const TextStyle(
                    color: Color(0xFF5D6170),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _showSchematic3D
                ? _buildInteractive3DSchematic(
                    machinePoints: machinePoints,
                    range: range,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: _TopViewPainter(
                        points: _points,
                        minX: _minX,
                        maxX: _maxX,
                        minY: _minY,
                        maxY: _maxY,
                        minDelta: range.min,
                        maxDelta: range.max,
                        selectedIndex: _selectedIndex,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildLegendChip(
                  const Color(0x55A0A4AF), "Non defini ($undefinedCount)"),
              _buildLegendChip(const Color(0xAA6CA8FF), "Z faible"),
              _buildLegendChip(const Color(0xCCE85A4F), "Z eleve"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            range.min == null || range.max == null
                ? "Aucune mesure Z"
                : "Echelle dZ: ${range.min!.toStringAsFixed(4)} -> ${range.max!.toStringAsFixed(4)}",
            style: const TextStyle(
              color: Color(0xFF5D6170),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompensationSwitch(bool enabled) {
    final String rawName = _mapFileNameController.text.trim();
    final String mapName = rawName.isEmpty
        ? "heightmap_piece.csv"
        : (rawName.toLowerCase().endsWith(".csv") ? rawName : "$rawName.csv");
    final String tooltipMessage =
        'Active/Desactive la compensation. G-code ON: G29 S1 P"$mapName". G-code OFF: G29 S2 puis M18 Z (demande unhomed Z).';

    return Tooltip(
      message: tooltipMessage,
      waitDuration: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECF2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFB8C0CC)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Compensation",
              style: TextStyle(
                color: Color(0xFF59606D),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Switch.adaptive(
              value: enabled,
              onChanged: _isBusy
                  ? null
                  : (bool value) {
                      _toggleCompensation(value);
                    },
            ),
            Text(
              enabled ? "ON" : "OFF",
              style: TextStyle(
                color:
                    enabled ? const Color(0xFF1F8A76) : const Color(0xFF7A818D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsTable() {
    if (_points.isEmpty) {
      return const Center(
        child: Text(
          "Aucune grille. Definir Min/Max et nombre de points puis creer la grille.",
          style: TextStyle(color: Color(0xFF707585)),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: _points.length,
      itemBuilder: (BuildContext context, int index) {
        final _LevelPoint point = _points[index];
        final bool isSelected = index == _selectedIndex;
        final Color rowBorder =
            isSelected ? const Color(0xFF1F8A76) : const Color(0xFFD5DAE3);
        final Color rowBg = isSelected
            ? const Color(0x1A20917F)
            : (index.isEven ? const Color(0xFFF7F9FC) : Colors.white);
        final Color sourceColor = point.source == "palpage"
            ? const Color(0xFF316CC6)
            : point.source == "manuel"
                ? const Color(0xFFC46B22)
                : point.source == "Z actuel"
                    ? const Color(0xFF4C9A63)
                    : point.source == "map active"
                        ? const Color(0xFF7A4BC0)
                        : const Color(0xFF8A94A7);
        return InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: rowBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: rowBorder),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    "#${point.index + 1}",
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1F8A76)
                          : const Color(0xFF707585),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    "X ${point.x.toStringAsFixed(2)}",
                    style: const TextStyle(color: Color(0xFF2E3240)),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    "Y ${point.y.toStringAsFixed(2)}",
                    style: const TextStyle(color: Color(0xFF2E3240)),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    point.rawZ == null
                        ? "Z brut: -"
                        : "Z brut: ${point.rawZ!.toStringAsFixed(4)}",
                    style: const TextStyle(color: Color(0xFF2E3240)),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    point.deltaZ == null
                        ? "dZ: -"
                        : "dZ: ${point.deltaZ!.toStringAsFixed(4)}",
                    style: const TextStyle(color: Color(0xFF2E3240)),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sourceColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: sourceColor.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        point.source.isEmpty
                            ? "source: -"
                            : "source: ${point.source}",
                        style: TextStyle(
                          color: sourceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String compensationType =
        global.objectModelMove.result?.compensation?.type?.toString() ?? "none";
    final String compensationFile =
        global.objectModelMove.result?.compensation?.file?.toString() ?? "-";
    final bool compensationEnabled = _isCompensationEnabled();
    final double commandPanelHeight =
        (MediaQuery.of(context).size.height * 0.42)
            .clamp(340.0, 520.0)
            .toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F3),
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: const Color(0xFFF0F0F3),
        actions: const <Widget>[
          AccountToolbarButton(),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: const Image(image: AssetImage("assets/iconnaxe.png")),
            ),
            Flexible(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 300,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: manualGcodeCommand,
                          decoration: const InputDecoration(
                            hintText: "Gcode",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gapPadding: 5.0,
                            ),
                          ),
                          onSubmitted: (String command) {
                            setState(() {
                              global.commandHistory.add(command);
                              manualGcodeCommand.clear();
                              API_Manager().sendGcodeCommand(command).then(
                                  (value) => API_Manager().sendrr_reply());
                            });
                          },
                        ),
                        PopupMenuButton<String>(
                          tooltip: "Historique",
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (String value) {
                            setState(() {
                              manualGcodeCommand.text = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return global.commandHistory
                                .map<PopupMenuItem<String>>((String value) {
                              return PopupMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    global.Title,
                    style: const TextStyle(color: Color(0xFF707585)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: commandPanelHeight,
              child: Window(
                title1: "Calibration",
                title2: " niveau piece",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTag("1. Configuration Grille",
                                  icon: Icons.grid_on_rounded),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _buildNumericField(_minXController, "Min X"),
                                  _buildNumericField(_maxXController, "Max X"),
                                  _buildNumericField(_minYController, "Min Y"),
                                  _buildNumericField(_maxYController, "Max Y"),
                                  _buildNumericField(
                                      _pointsXController, "Pts X",
                                      integerOnly: true),
                                  _buildNumericField(
                                      _pointsYController, "Pts Y",
                                      integerOnly: true),
                                  _buildNumericField(
                                      _safeZController, "Zsafe M"),
                                  SizedBox(
                                    width: 180,
                                    child: TextFormField(
                                      controller: _mapFileNameController,
                                      decoration: const InputDecoration(
                                        labelText: "Fichier map",
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Creer grille",
                                    tooltipMessage:
                                        "Cree la grille de points. Envoie G-code: M557 X<min:max> Y<min:max> P<nx:ny>.",
                                    onPressed: _isBusy ? null : _createGrid,
                                    icon: Icons.grid_3x3_rounded,
                                    backgroundColor: const Color(0xFF2C5FA8),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Aller point",
                                    tooltipMessage:
                                        "Remonte d'abord en Zsafe machine (G53), puis va au point XY converti depuis les coordonnees utilisateur. Envoie: G53 G0 Z<safe_machine>, G53 G0 X<...> Y<...>, puis M400.",
                                    onPressed: _isBusy || _points.isEmpty
                                        ? null
                                        : _goToSelectedPoint,
                                    icon: Icons.open_with_rounded,
                                    backgroundColor: const Color(0xFF2B7A78),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Point -",
                                    tooltipMessage:
                                        "Selectionne le point precedent (aucune commande G-code).",
                                    onPressed:
                                        _isBusy ? null : _selectPreviousPoint,
                                    icon: Icons.arrow_back_ios_new_rounded,
                                    backgroundColor: const Color(0xFFE6EBF3),
                                    foregroundColor: const Color(0xFF425067),
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Point +",
                                    tooltipMessage:
                                        "Selectionne le point suivant (aucune commande G-code).",
                                    onPressed:
                                        _isBusy ? null : _selectNextPoint,
                                    icon: Icons.arrow_forward_ios_rounded,
                                    backgroundColor: const Color(0xFFE6EBF3),
                                    foregroundColor: const Color(0xFF425067),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildSectionTag("2. Acquisition Z",
                                  icon: Icons.straighten_rounded),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 110,
                                    child: TextFormField(
                                      controller: _manualZController,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r"[-0-9.,]")),
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: "Z manuel",
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Valider Z manuel",
                                    tooltipMessage:
                                        "Enregistre la valeur Z saisie pour le point selectionne (aucune commande G-code).",
                                    onPressed: _isBusy || _points.isEmpty
                                        ? null
                                        : _captureManualZ,
                                    icon: Icons.keyboard_alt_rounded,
                                    backgroundColor: const Color(0xFFE6EBF3),
                                    foregroundColor: const Color(0xFF425067),
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Prendre Z actuel",
                                    tooltipMessage:
                                        "Lit Z depuis move.axes[2].userPosition (aucune commande G-code).",
                                    onPressed: _isBusy || _points.isEmpty
                                        ? null
                                        : _captureCurrentZ,
                                    icon: Icons.my_location_rounded,
                                    backgroundColor: const Color(0xFFE6EBF3),
                                    foregroundColor: const Color(0xFF425067),
                                  ),
                                  _buildZJogStepSelector(),
                                  _buildTooltipActionButton(
                                    label: "Descendre Z",
                                    tooltipMessage:
                                        "Descend l'axe Z du pas choisi. Envoie G-code: G91, G1 Z-<pas> F300, G90, puis M400.",
                                    onPressed: _isBusy ? null : _jogZDown,
                                    icon: Icons.vertical_align_bottom_rounded,
                                    backgroundColor: const Color(0xFF2C5FA8),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Palper (G30 S-1)",
                                    tooltipMessage:
                                        "Palpe au point courant. Envoie G-code: G30 S-1.",
                                    onPressed: _isBusy || _points.isEmpty
                                        ? null
                                        : _captureProbeZ,
                                    icon: Icons.track_changes_rounded,
                                    backgroundColor: const Color(0xFF755CBE),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildCompensationClampPanel(),
                                  _buildTooltipActionButton(
                                    label: "Sauver map",
                                    tooltipMessage:
                                        "Genere le fichier heightmap (avec ecretage si active), puis upload dans /sys (pas de G-code, utilisation rr_upload).",
                                    onPressed: _isBusy
                                        ? null
                                        : () {
                                            _saveHeightmapFile();
                                          },
                                    icon: Icons.save_rounded,
                                    backgroundColor: const Color(0xFF226B4A),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Sauver + activer",
                                    tooltipMessage:
                                        "Sauvegarde la map (avec ecretage si active) puis active la compensation. Envoie G-code: G29 S1 P\"<fichier>\".",
                                    onPressed: _isBusy
                                        ? null
                                        : () {
                                            _saveHeightmapFile(
                                                activateAfterSave: true);
                                          },
                                    icon:
                                        Icons.playlist_add_check_circle_rounded,
                                    backgroundColor: const Color(0xFF1F8A76),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildTooltipActionButton(
                                    label: "Charger map active",
                                    tooltipMessage:
                                        "Telecharge le fichier de compensation actif (ou le fichier map si aucun actif), parse le CSV et l'affiche dans la vue schematique.",
                                    onPressed: _isBusy
                                        ? null
                                        : _loadAndVisualizeActiveMap,
                                    icon: Icons.cloud_download_rounded,
                                    backgroundColor: const Color(0xFF2C5FA8),
                                    foregroundColor: Colors.white,
                                  ),
                                  _buildCompensationSwitch(compensationEnabled),
                                  _buildTooltipActionButton(
                                    label: "Supprimer map",
                                    tooltipMessage:
                                        "Desactive d'abord la compensation, demande le passage de Z en unhomed, puis supprime le fichier map. Envoie G-code: G29 S2 puis M18 Z.",
                                    onPressed: _isBusy
                                        ? null
                                        : _deleteCompensationFile,
                                    icon: Icons.delete_outline_rounded,
                                    backgroundColor: const Color(0xFF9A3940),
                                    foregroundColor: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildInfoBadge(
                                    label: "X ",
                                    value: _axisText(0),
                                    icon: Icons.swap_horiz_rounded,
                                  ),
                                  _buildInfoBadge(
                                    label: "Y ",
                                    value: _axisText(1),
                                    icon: Icons.swap_vert_rounded,
                                  ),
                                  _buildInfoBadge(
                                    label: "Z ",
                                    value: _axisText(2),
                                    icon: Icons.height_rounded,
                                  ),
                                  _buildInfoBadge(
                                    label: "Comp ",
                                    value: compensationType,
                                    icon: Icons.tune_rounded,
                                  ),
                                  _buildInfoBadge(
                                    label: "Map ",
                                    value: compensationFile,
                                    icon: Icons.description_outlined,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              _buildStatusBanner(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool compact = constraints.maxWidth < 1200;
                  if (compact) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Window(
                            title1: "Points",
                            title2: " de calibration",
                            child: _buildPointsTable(),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Window(
                            title1: "Vue",
                            title2: " schematique",
                            child: _buildTopViewPanel(),
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Window(
                          title1: "Points",
                          title2: " de calibration",
                          child: _buildPointsTable(),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Window(
                          title1: "Vue",
                          title2: " schematique",
                          child: _buildTopViewPanel(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
