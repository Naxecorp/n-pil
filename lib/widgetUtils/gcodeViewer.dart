import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nweb/screen/screens.dart';
import 'package:path_provider/path_provider.dart';
import '/globals_var.dart' as global;
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:vector_math/vector_math.dart' as vector_math;
import 'package:ditredi/ditredi.dart';
import 'package:vector_math/vector_math_64.dart'as vector;

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

  Function? refresh ;

  GcodeViewer({
    this.refresh,
    this.CommandsToDisplay
  });

  @override
  State<GcodeViewer> createState() => GcodeViewerState(CommandsToDisplay: CommandsToDisplay,refresh:refresh);
}

class GcodeViewerState extends State<GcodeViewer> {

  List<String>? CommandsToDisplay;

  Function? refresh ;

  GcodeViewerState({
    this.refresh,
    this.CommandsToDisplay,
  });

  final TextEditingController _controllers = TextEditingController();
  List<Line3D> listeDeLine3D=[];

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
  final RegExpMatch? match = RegExp(r'([XYZ])([+-]?\d+(\.\d+)?)').firstMatch(line);

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

    for (var ligne in lignes!) {
    List<String> commandes = ligne.split(' ');

    if (commandes.isNotEmpty && (commandes[0] == 'G0' || commandes[0] == 'G1')) {


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

      var couleur =
          commandes[0] == 'G0' ? Colors.orange : Colors.blue;

      var ligne3D = Line3D(debut, fin, width: 2, color: couleur);
      result.add(ligne3D);

      debut = fin; // Mettre à jour le début pour la prochaine itération
    }
  }

  return result;
}





final _controller = DiTreDiController(
    //rotationX: -20,
    //rotationY: 30,
    light: vector.Vector3(-0.5, -0.5, 0.5),
  );



  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child:  DiTreDiDraggable(
          controller: _controller,
          child: DiTreDi(
            figures: listeDeLine3D,
            controller: _controller,
            config: DiTreDiConfig(
              supportZIndex: true,
            ),
          ),
        )
        ),
    );

    
  }

  

}