import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nweb/OpeListView.dart';
import '../screens.dart';
import 'package:nweb/service/API_Manager.dart';
import 'package:nweb/globals_var.dart'as global;


class BottomMenu extends StatefulWidget {
  const BottomMenu({
    super.key,
    this.title,
    this.child,
    this.onAnyTap,
  });

  final String? title;
  final Widget? child;
  final VoidCallback? onAnyTap;

  @override
  State<BottomMenu> createState() => _BottomMenu(onAnyTap);
}

class _BottomMenu extends State<BottomMenu> {
  final VoidCallback? onAnytap;

  _BottomMenu(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return bottomMenuToShow == 'Menu1'
        ? Menu1(
            onAnyTap: () {
              setState(() {});
              return onAnytap!();
            },
          )
        : Menu2(
            onAnyTap: () {
              setState(() {});
              return onAnytap!();
            },
          );
    throw UnimplementedError();
  }
}

class Menu1 extends StatefulWidget {
  const Menu1({
    super.key,
    this.title,
    this.child,
    this.onAnyTap,
  });

  final String? title;
  final Widget? child;
  final VoidCallback? onAnyTap;

  @override
  State<Menu1> createState() => _Menu1(onAnyTap);
}

class _Menu1 extends State<Menu1> {
  final VoidCallback? onAnytap;

  _Menu1(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(flex: 10, child: Container()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B879B)),
                onPressed: () {
                  viewListOfOperation = !viewListOfOperation;

                  setState(() {
                    OpeSelected = 0;
                  });
                  bottomMenuToShow = 'Menu2';
                  return onAnytap!();
                },
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Voir liste opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
        Flexible(flex: 10, child: Container()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B9B80)),
                onPressed: null,
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Charger opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B9B80)),
                onPressed: () {ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Liste chargée'),
                                  duration: const Duration(milliseconds: 400),
                                ));},
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Charger liste opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
      ],
    );
    throw UnimplementedError();
  }
}

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

  String FileName="Prog1";

  Future<void> askForNameFile()async {
    String _FileName="";
    showDialog(
      context: context,
      builder: (BuildContext context)
    {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Définir un nom de programme"),
        content: Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: TextFormField(
                  initialValue: "Prog1",
                  onChanged: (text) {
                    _FileName = text;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      gapPadding: 5.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: Text("Annuler"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              child: Text("Ok"),
              onPressed: () {
                FileName = _FileName;
                Navigator.of(context).pop();
                List<String> Buffer = [];
                ListOfOperationCurrent.forEach((element) {
                  element.construct();
                  element.trajectoires.forEach((element2) {
                    Buffer.add(element2);
                  });
                });
                String Bufferjoined = Buffer.join("\n");
                API_Manager().upLoadAFile("0:/gcodes/$FileName.gcode", Buffer.toString().codeUnits.length.toString(), Uint8List.fromList(Bufferjoined.codeUnits)).then((notused) {
                  API_Manager().getfileList().then((value) => global.ListofGcodeFile=value);
                }
                );
              }
          ),
        ],
      );
    });
  }


  final VoidCallback? onAnytap;

  _Menu2(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF696969)),
                onPressed: () {
                  viewListOfOperation = !viewListOfOperation;

                  setState(() {});
                  bottomMenuToShow = 'Menu1';
                  return onAnytap!();
                },
                child: SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      'Retour opérations',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                )),
          ),
        ),
        Flexible(flex: 2, child: Container()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B879B)),
                onPressed: null,
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Editer opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCD805F)),
                onPressed: () {
                  ListOfOperationCurrent.removeAt(selectedIndex);
                  if (selectedIndex >= 1) selectedIndex--;
                  return onAnytap!();
                },
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Supprimer opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
        Flexible(flex: 12, child: Container()),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B9B80)),
                onPressed: null,
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Charger opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B9B80)),
                onPressed: () async{

                  await askForNameFile();

                },
                child: SizedBox(
                    height: 100,
                    child: Center(
                        child: Text(
                      'Charger liste opération',
                      textAlign: TextAlign.center,
                    )))),
          ),
        ),
      ],
    );
    throw UnimplementedError();
  }
}
