import 'package:flutter/material.dart';
import '../../operations/op_subd9/widget_subd9.dart';
import '../../screen/screens.dart';
import '../../opeviewer.dart';

class OpeMenuConnecteur extends StatefulWidget {
  const OpeMenuConnecteur({
    super.key,
    this.title,
    this.child,
    this.onAnyTap,
  });

  final String? title;
  final Widget? child;

  final VoidCallback? onAnyTap;

  @override
  State<OpeMenuConnecteur> createState() => _OpeMenuConnecteur(onAnyTap);
}

class _OpeMenuConnecteur extends State<OpeMenuConnecteur> {
  final VoidCallback? onAnytap;

  _OpeMenuConnecteur(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                  )),
              Flexible(
                flex: 2,
                child: Container(
                  //color: Colors.yellow,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: const FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Opérations",
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
                        child: const FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Connecteur",
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
                  flex: 20,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Card(
                          child: ListTile(
                            tileColor: opeToShow == 'subd9'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'subd9';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon Subd.png'),
                            ),
                            title: Text(
                              'Sub-D 9',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Card(
                          child: ListTile(
                            tileColor: opeToShow == 'subd15'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'subd15';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon Subd.png'),
                            ),
                            title: Text(
                              'Sub-D 15',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Card(
                          child: ListTile(
                            tileColor: opeToShow == 'subd25'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'subd25';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon Subd.png'),
                            ),
                            title: Text(
                              'Sub-D25',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Card(
                          child: ListTile(
                            tileColor: opeToShow == 'hdmi'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'hdmi';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon HDMI.png'),
                            ),
                            title: Text(
                              'HDMI',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ), // Affichage du menu
        Flexible(
            flex: 10,
            child: Container(
              //color: Colors.greenAccent.withOpacity(0.5),
              child: opeToShow == 'subd9'
                  ? OpeSubd9()
                  : opeToShow == 'subd15'
                      ? OpeSubd15()
                      : opeToShow == 'subd25'
                          ? Center(
                              child: Text(
                                  'Ne soyez pas impacient ! Cette opération arrive bientôt :)'))
                          : opeToShow == 'hdmi'
                              ? Center(
                                  child: Text(
                                      'Ne soyez pas impacient ! Cette opération arrive bientôt :)'))
                              : Center(child: Text('Selectionner opération')),
            )) // Affichage des VUES opération
      ],
    );
    throw UnimplementedError();
  }
}
