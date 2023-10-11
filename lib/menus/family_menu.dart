import 'dart:async';
import 'package:flutter/material.dart';
import '../screen/screens.dart';

class FamilyMenu extends StatefulWidget {
  const FamilyMenu({
    super.key,
    this.title,
    this.child,
    required this.onAnyTap,
  });

  final String? title;
  final Widget? child;

  final VoidCallback onAnyTap;

  @override
  State<FamilyMenu> createState() => _FamilyMenu(onAnyTap);
}

class _FamilyMenu extends State<FamilyMenu> {
  final VoidCallback onAnytap;

  _FamilyMenu(this.onAnytap);

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
                children: [
                  Flexible(
                    flex: 1,
                    child: const FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Famille",
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Card(
                      child: ListTile(
                        tileColor: FamillyToShow == 'classique'
                            ? Color(0xFF9A9A9A)
                            : Colors.white,
                        onTap: () {
                          FamillyToShow = 'classique';
                          setState(() {});
                          return onAnytap();
                        },
                        leading: Image(
                          image:
                              AssetImage('assets/Icon Usinage classique.png'),
                        ),
                        title: Text(
                          'Usinage classique',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Card(
                      child: ListTile(
                        tileColor: FamillyToShow == 'connecteur'
                            ? Color(0xFF9A9A9A)
                            : Colors.white,
                        onTap: () {
                          FamillyToShow = 'connecteur';
                          setState(() {});
                          return onAnytap();
                        },
                        leading: Image(
                          image: AssetImage('assets/Icon cnc conecteurs.png'),
                        ),
                        title: Text(
                          'Connecteurs',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Card(
                      child: ListTile(
                        tileColor: FamillyToShow == 'autres'
                            ? Color(0xFF9A9A9A)
                            : Colors.white,
                        onTap: () {
                          FamillyToShow = 'autres';
                          setState(() {});
                          return onAnytap();
                        },
                        leading: Icon(
                          Icons.stream,
                          color: Colors.black45,
                        ),
                        title: Text(
                          'Autres',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Card(
                      child: ListTile(
                        tileColor: FamillyToShow == 'personalises'
                            ? Color(0xFF9A9A9A)
                            : Colors.white,
                        onTap: () {
                          FamillyToShow = 'personalises';
                          setState(() {});
                          return onAnytap();
                        },
                        leading: Icon(
                          Icons.star,
                          color: Colors.black45,
                        ),
                        title: Text(
                          'Personalisés',
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
    );
    throw UnimplementedError();
  }
}
