import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nweb/screen/screens.dart';
import 'package:path_provider/path_provider.dart';
import '/globals_var.dart' as global;
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:vector_math/vector_math.dart' as vector_math;
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

Iterable<Cube3D> _generateCubes() sync* {
  final colors = [
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade400,
    Colors.grey.shade500,
    Colors.grey.shade600,
    Colors.grey.shade700,
    Colors.grey.shade800,
    Colors.grey.shade900,
  ];

  const count = 8;
  for (var x = count; x > 0; x--) {
    for (var y = count; y > 0; y--) {
      for (var z = count; z > 0; z--) {
        yield Cube3D(
          0.9,
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
          color: colors[(colors.length - y) % colors.length],
        );
      }
    }
  }
}

Iterable<Point3D> _generatePoints() sync* {
  for (var x = 0; x < 10; x++) {
    for (var y = 0; y < 10; y++) {
      for (var z = 0; z < 10; z++) {
        yield Point3D(
          vector.Vector3(
            x.toDouble() * 2,
            y.toDouble() * 2,
            z.toDouble() * 2,
          ),
        );
      }
    }
  }
}

enum DisplayMode {
  cubes,
  wireframe,
  points,
}

extension DisplayModeTitle on DisplayMode {
  String get title {
    switch (this) {
      case DisplayMode.cubes:
        return "Cubes";
      case DisplayMode.wireframe:
        return "Wireframe";
      case DisplayMode.points:
        return "Points";
    }
  }
}

class GcodeViewer extends StatefulWidget {
  List<String>? CommandsToDisplay;

  Function? refresh;

  GcodeViewer({this.refresh, this.CommandsToDisplay});

  @override
  State<GcodeViewer> createState() =>
      GcodeViewerState(CommandsToDisplay: CommandsToDisplay, refresh: refresh);
}

class GcodeViewerState extends State<GcodeViewer> {
  List<String>? CommandsToDisplay;

  Function? refresh;

  GcodeViewerState({this.refresh, this.CommandsToDisplay});

  final TextEditingController _controllers = TextEditingController();
  List<Line3D> listeDeLine3D = [];

  @override
  initState() {
    super.initState();
    global.streamcontrollerContentGcodeToDisplay.listen((value) {
      setState(() {
        listeDeLine3D = convertirEnListeDeLine3D(value);
      });
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/nps2.gcode');
  }

  Future<File> writeANewFile(String FileName, String hello) async {
    final path2 = await _localPath;
    final file = File('$path2/nps2filtred.gcode');

    var sink = file.openWrite(mode: FileMode.write);

    sink.write('FILE ACCESSED ${DateTime.now()}\n');
    sink.write(hello);
    sink.write('FILE closed ${DateTime.now()}\n');
    sink.close();

    return file;
  }

  Future<List<String>> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final contents2 = await file.readAsLines();

      return contents2;
    } catch (e) {
      // If encountering an error, return 0
      return List.empty();
    }
  }

  Future<List<String>> readGcodeFile(String filePath) async {
    final path = await _localPath;

    try {
      File file = File("$path/nps2.gcode");
      List<String> lines = await file.readAsLines();
      return lines;
    } catch (e) {
      print('Erreur lors de la lecture du fichier Gcode: $e');
      return [];
    }
  }

  Map<String, double> parseGcodeLine(String line) {
    final Map<String, double> coordinates = {'x': 0, 'y': 0, 'z': 0};
    final RegExpMatch? match =
        RegExp(r'([XYZ])([+-]?\d+(\.\d+)?)').firstMatch(line);

    if (match != null) {
      match.groups([1, 2]).forEach((group) {
        final String axis = group![1]!;
        final double value = double.parse(group[2]!);
        coordinates[axis.toLowerCase()] = value;
      });
    }

    return coordinates;
  }

  Future<List<String>> lireFichierGcode(String chemin) async {
    File fichier = File(chemin);
    List<String> lignes = await fichier.readAsLines();
    return lignes;
  }

  List<Line3D> convertirEnListeDeLine3D(List<String>? lignes) {
    List<Line3D> result = [];
    vector.Vector3 debut = vector.Vector3.zero();

    double x = 0;
    double y = 0;
    double z = 0;
    result.add(Line3D(
      vector.Vector3(0, 0, 0),
      vector.Vector3(10, 0, 0),
      width: 3,
      color: Colors.red,
    ));

    result.add(Line3D(
      vector.Vector3(0, 0, 0),
      vector.Vector3(0, 10, 0),
      width: 3,
      color: Colors.blue,
    ));

    result.add(Line3D(
      vector.Vector3(0, 0, 0),
      vector.Vector3(0, 0, 20),
      width: 3,
      color: Colors.green,
    ));

    for (var ligne in lignes!) {
      List<String> commandes = ligne.split(' ');

      if (commandes.isNotEmpty &&
          (commandes[0] == 'G0' || commandes[0] == 'G1')) {
        for (var commande in commandes) {
          if (commande.startsWith('X')) {
            x = double.parse(commande.substring(1));
          } else if (commande.startsWith('Y')) {
            y = double.parse(commande.substring(1));
          } else if (commande.startsWith('Z')) {
            z = double.parse(commande.substring(1));
          }
        }

        var fin = vector.Vector3(x, z, y);

        var couleur = commandes[0] == 'G0' && result.isEmpty
            ? Colors.purple
            : (commandes[0] == 'G0'
                ? Colors.orange[200]
                : Colors.blueGrey[700]);

        var ligne3D = Line3D(debut, fin, width: 2, color: couleur);
        result.add(ligne3D);

        debut = fin; // Mettre à jour le début pour la prochaine itération
      } else if (commandes.isNotEmpty &&
          (commandes[0] == 'G2' || commandes[0] == 'G3')) {
        bool clockwise = commandes[0] == 'G2';
        double i = 0, j = 0, k = 0;

        for (var commande in commandes) {
          if (commande.startsWith('X')) {
            x = double.parse(commande.substring(1));
          } else if (commande.startsWith('Y')) {
            y = double.parse(commande.substring(1));
          } else if (commande.startsWith('Z')) {
            z = double.parse(commande.substring(1));
          } else if (commande.startsWith('I')) {
            i = double.parse(commande.substring(1));
          } else if (commande.startsWith('J')) {
            j = double.parse(commande.substring(1));
          } else if (commande.startsWith('K')) {
            k = double.parse(commande.substring(1));
          }
        }

        var arcSegments = generateArcSegments(
          start: debut,
          endX: x,
          endY: z,
          endZ: y,
          centerOffsetx: i,
          centerOffsety: k,
          centerOffsetz: j,
          clockwise: clockwise,
        );
        result.addAll(arcSegments);
        debut = vector.Vector3(x, z, y);
      }
    }

    return result;
  }

  final _controller = DiTreDiController(
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );

  List<Line3D> generateArcSegments({
    required vector.Vector3 start,
    required double endX,
    required double endY,
    required double endZ,
    required double centerOffsetx,
    required double centerOffsety,
    required double centerOffsetz,
    int numberOfSegments = 10,
    required bool clockwise,
    String targetPlane = "XZ", // Target plane: "XY", "XZ", or "YZ"
  }) {
    // Calcule le centre de l'arc
    final vector.Vector3 center = vector.Vector3(
      start.x + centerOffsetx,
      start.y + centerOffsety,
      start.z + centerOffsetz,
    );

    vector.Vector3 end = vector.Vector3(endX, endY, endZ);

    // Fonction pour convertir un point en coordonnées polaires 2D autour du centre
    double calculateAngle(vector.Vector3 p, vector.Vector3 c) {
      switch (targetPlane) {
        case "XY":
          return atan2(p.y - c.y, p.x - c.x); // Plan XY
        case "XZ":
          return atan2(p.z - c.z, p.x - c.x); // Plan XZ
        case "YZ":
          return atan2(p.z - c.z, p.y - c.y); // Plan YZ
        default:
          throw ArgumentError("Invalid targetPlane: $targetPlane");
      }
    }

    // Calcul dynamique du rayon en fonction du plan
    double radius;
    switch (targetPlane) {
      case "XY":
        radius = sqrt(pow(start.x - center.x, 2) + pow(start.y - center.y, 2));
        break;
      case "XZ":
        radius = sqrt(pow(start.x - center.x, 2) + pow(start.z - center.z, 2));
        break;
      case "YZ":
        radius = sqrt(pow(start.y - center.y, 2) + pow(start.z - center.z, 2));
        break;
      default:
        throw ArgumentError("Invalid targetPlane: $targetPlane");
    }

    // Calcul des angles de départ et d'arrivée
    double startAngle = calculateAngle(start, center);
    double endAngle = calculateAngle(end, center);

    // Ajuste le sens de rotation
    if (clockwise && startAngle < endAngle) {
      startAngle += 2 * pi;
    } else if (!clockwise && startAngle > endAngle) {
      endAngle += 2 * pi;
    }

    // Calcul des segments
    final double angleStep = (endAngle - startAngle) / numberOfSegments;
    List<Line3D> lines = [];

    for (int i = 0; i < numberOfSegments; i++) {
      // Angle de début et de fin pour ce segment
      double angle1 = startAngle + i * angleStep;
      double angle2 = startAngle + (i + 1) * angleStep;

      // Points de début et de fin en coordonnées cartésiennes selon le plan
      vector.Vector3 point1, point2;
      switch (targetPlane) {
        case "XY":
          point1 = vector.Vector3(
            center.x + radius * cos(angle1),
            center.y + radius * sin(angle1),
            center.z,
          );
          point2 = vector.Vector3(
            center.x + radius * cos(angle2),
            center.y + radius * sin(angle2),
            center.z,
          );
          break;
        case "XZ":
          point1 = vector.Vector3(
            center.x + radius * cos(angle1),
            center.y,
            center.z + radius * sin(angle1),
          );
          point2 = vector.Vector3(
            center.x + radius * cos(angle2),
            center.y,
            center.z + radius * sin(angle2),
          );
          break;
        case "YZ":
          point1 = vector.Vector3(
            center.x,
            center.y + radius * cos(angle1),
            center.z + radius * sin(angle1),
          );
          point2 = vector.Vector3(
            center.x,
            center.y + radius * cos(angle2),
            center.z + radius * sin(angle2),
          );
          break;
        default:
          throw ArgumentError("Invalid targetPlane: $targetPlane");
      }

      // Crée une ligne et l'ajoute à la liste
      lines.add(Line3D(point1, point2, width: 2, color: Colors.blueGrey[400]));
    }

    // Forcer le point final pour correspondre exactement à endX, endY, endZ
    //lines.add(Line3D(lines.last.end, end, width: 2, color: Colors.green));

    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 15,
              child: DiTreDiDraggable(
                controller: _controller,
                child: DiTreDi(
                  figures: listeDeLine3D,
                  controller: _controller,
                  config: DiTreDiConfig(
                    supportZIndex: true,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        "   X ",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Y ",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Z                            ",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Container(
                      child: Text(
                        "G0  ",
                        style: TextStyle(color: Colors.orange[200]),
                      ),
                    ),
                    Container(
                      child: Text(
                        "G1  ",
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                    ),
                    Container(
                      child: Text(
                        "G2/G3 ",
                        style: TextStyle(color: Colors.blueGrey[400]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
