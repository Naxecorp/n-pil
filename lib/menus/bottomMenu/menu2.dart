import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nweb/OpeListView.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/ObjectModelJobManager.dart';
import '../../screen/screens.dart';
import '../../OpeListView.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/globals_var.dart' as global;

class Menu2 extends StatefulWidget {
  const Menu2({
    super.key,
    this.title,
    this.child,
    this.onAnyTap,
  });

  final String? title;
  final Widget? child;
  final VoidCallback? onAnyTap;

  @override
  State<Menu2> createState() => _Menu2(onAnyTap);
}

class _Menu2 extends State<Menu2> {
  String fileName = "Prog1"; // Initialisez le nom de fichier ici
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text =
        fileName; // Initialisez le contrôleur avec la valeur initiale
  }

  Future<void> askForNameFile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Définir un nom de programme"),
          content: Container(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'[a-zA-Z0-9\s]')), // Permet seulement les lettres, chiffres et espaces
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gapPadding: 5.0,
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      // Traitez ici la validation ou le traitement avec la valeur entrée
                      fileName = value; // Mettez à jour le nom du fichier
                      Navigator.of(context)
                          .pop(); // Fermez la boîte de dialogue
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Le programme ${fileName} a bien été crée.\nSouhaitez-vous visualiser la liste des programmes ?"),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () async {
                                  pageToShow = 3;
                                  Navigator.pushNamed(context, '/programmes');
                                },
                                child: const Text(
                                  "Oui",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Non",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      // Faites ce que vous devez faire avec fileName ici
                      List<String> buffer = [];
                      ListOfOperationCurrent.forEach((element) {
                        element.construct();
                        element.trajectoires.forEach((element2) {
                          buffer.add(element2);
                        });
                      });
                      String bufferJoined = buffer.join("\n");
                      API_Manager()
                          .upLoadAFile(
                              "0:/gcodes/$fileName.gcode",
                              buffer.toString().codeUnits.length.toString(),
                              Uint8List.fromList(bufferJoined.codeUnits))
                          .then((notused) {
                        API_Manager()
                            .getfileList()
                            .then((value) => global.ListofGcodeFile = value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final VoidCallback? onAnytap;

  _Menu2(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: double.infinity,
              height: 50, // Hauteur fixe pour tous les boutons
              child: ElevatedButton.icon(
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Retour opérations",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: const Color(0xFF696969),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  global.viewListOfOperation = !global.viewListOfOperation;
                  setState(() {});
                  global.bottomMenuToShow = 'Menu1';
                  return onAnytap!();
                },
              ),
            ),
          ),
        ),
        Flexible(flex: 2, child: Container()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: double.infinity,
              height: 50, // Hauteur fixe pour tous les boutons
              child: ElevatedButton.icon(
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Editer opérations",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: const Color(0xFF2B879B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: null,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: double.infinity,
              height: 50, // Hauteur fixe pour tous les boutons
              child: ElevatedButton.icon(
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Supprimer opérations",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: const Color(0xFFCD805F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  ListOfOperationCurrent.removeAt(selectedIndex);
                  if (selectedIndex >= 1) selectedIndex--;
                  return onAnytap!();
                },
              ),
            ),
          ),
        ),
        Flexible(flex: 15, child: Container()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: double.infinity,
              height: 50, // Hauteur fixe pour le bouton
              child: ElevatedButton.icon(
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Créer programme",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: const Color(0xFF2B9B80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () async {
                  await askForNameFile();
                },
              ),
            ),
          ),
        ),
      ],
    );
    throw UnimplementedError();
  }
}
