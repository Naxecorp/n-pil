// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../../operations/op_contournage/widget_contournage.dart';
import '../../operations/op_ligne_droite/widget_ligne_droite.dart';
import '../../operations/op_poche_carre/widget_poche_carre.dart';
import '../../operations/op_poche_ronde/widget_poche_ronde.dart';
import '../../operations/op_subd9/widget_subd9.dart';
import '../../operations/ope_surfacage/widget_surfacage.dart';
import '../../screen/screens.dart';
import '../../opeviewer.dart';

class OpeMenuUsinage extends StatefulWidget {
  const OpeMenuUsinage({
    super.key,
    this.title,
    this.child,
    this.onAnyTap,
  });

  final String? title;
  final Widget? child;

  final VoidCallback? onAnyTap;

  @override
  State<OpeMenuUsinage> createState() => _OpeMenuUsinage(onAnyTap);
}

class _OpeMenuUsinage extends State<OpeMenuUsinage> {
  final VoidCallback? onAnytap;

  _OpeMenuUsinage(this.onAnytap);

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
                            "d'usinage",
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            tileColor: opeToShow == 'Surfacage'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'Surfacage';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: AssetImage('assets/Icon Surfacage.png'),
                              ),
                            ),
                            title: Text(
                              'Surfacage',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            tileColor: opeToShow == 'PocheCarre'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'PocheCarre';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon poche carre.png'),
                            ),
                            title: Text(
                              'Poche carée',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            tileColor: opeToShow == 'PocheRonde'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'PocheRonde';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon Poche ronde.png'),
                            ),
                            title: Text(
                              'Poche Ronde',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            tileColor: opeToShow == 'Contournage'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'Contournage';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image: AssetImage('assets/Icon Contournage.png'),
                            ),
                            title: Text(
                              'Contournage',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            tileColor: opeToShow == 'LigneDroite'
                                ? Color(0xFF9A9A9A)
                                : Colors.white,
                            onTap: () {
                              opeToShow = 'LigneDroite';
                              setState(() {});
                              return onAnytap!();
                            },
                            leading: Image(
                              image:
                                  AssetImage('assets/Icon ligne droites.png'),
                            ),
                            title: Text(
                              'Lignes Droites',
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
              child: opeToShow == 'Surfacage'
                  ? OpeSurfacage()
                  : opeToShow == 'PocheCarre'
                      ? OpePocheCarre()
                      : opeToShow == 'PocheRonde'
                          ? OpePocheRonde()
                          : opeToShow == 'Contournage'
                              ? OpeContournage()
                              : opeToShow == 'LigneDroite'
                                  ? OpeLigneDroite()
                                  : Center(
                                      child: Text('Sélectionner opération')),
            )) // Affichage des VUES opération
      ],
    );
    throw UnimplementedError();
  }
}
