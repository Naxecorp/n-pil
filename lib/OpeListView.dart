import 'dart:ui';
import 'package:flutter/material.dart';
import 'opeviewer.dart';
import 'operation.dart';


List<Operation> ListOfOperationCurrent = <Operation>[];
int selectedIndex=0;


class OpeListView extends StatefulWidget {
  final VoidCallback? onAnyTap;

  const OpeListView({
    super.key,
    this.onAnyTap,
  });

  @override
  State<OpeListView> createState() => _OpeListView(onAnyTap);
}

class _OpeListView extends State<OpeListView> {
  final VoidCallback? _onAnyTap;

  _OpeListView(this._onAnyTap);

  @override
  Widget build(BuildContext context) {
    if (ListOfOperationCurrent.length>0) {
      return Container(
        child: Row(
      children: [
        Flexible(
            flex: 2,
            child: OpeListSide(
              onAnyTap: () {
                setState(() {});
                return _onAnyTap!();
              },
            )),
        Flexible(
            flex: 7,
            child: GeneralOpeViewer()),
      ],
    ));
    } else return Container(height:double.infinity, child: Center(child: Text('Aucune opération')),);
  }
}

class OpeListSide extends StatefulWidget {
  final VoidCallback? onAnyTap;

  const OpeListSide({
    super.key,
    this.onAnyTap,
  });

  @override
  State<OpeListSide> createState() => _OpeListSide(onAnyTap);
}

class _OpeListSide extends State<OpeListSide> {
  final VoidCallback? _onAnyTap;

  _OpeListSide(this._onAnyTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              //color: Colors.yellow,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Liste des",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 100,
                            color: Color(0xFF707585)),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "opérations",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 100,
                            color: Color(0xFF707585)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 15,
              child: ListView.builder(
                itemCount: ListOfOperationCurrent.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      tileColor: Colors.white,
                      //selectedColor: Colors.orange,
                      selectedTileColor: Colors.black26,
                      selected: index == selectedIndex,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          print(index);
                        });
                        return _onAnyTap!();
                      },

                      leading: Icon(
                        Icons.insert_drive_file,
                        color: Colors.blue,
                      ),
                      title: Text(
                        ListOfOperationCurrent.elementAt(index).label.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ); },

              ))
        ],
      ),
    );
  }
}
