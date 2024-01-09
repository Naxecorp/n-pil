import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:nweb/globals_var.dart' as global;

import '../service/API/API_Manager.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
    this.title,
    this.child,
    required this.onAnyTap,
  });

  final String? title;
  final Widget? child;

  final VoidCallback onAnyTap;

  @override
  State<SideMenu> createState() => _SideMenu(onAnyTap);
}

class _SideMenu extends State<SideMenu> {
  final VoidCallback _onAnytap;

  _SideMenu(this._onAnytap);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 1;
                  Navigator.pushNamed(context, '/dashboard');
                  //Navigator.pop(context);
                  //return _onAnytap();
                },
                tileColor: pageToShow == 1 ? Color(0xFF9A9A9A) : Colors.white,
                leading: Icon(
                  Icons.home_filled,
                  color: pageToShow == 1 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                      color: pageToShow == 1 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 2;
                  Navigator.pushNamed(context, '/conversationel');
                },
                tileColor: pageToShow == 2 ? Color(0xFF9A9A9A) : Colors.white,
                leading: Icon(
                  Icons.screen_share_outlined,
                  color: pageToShow == 2 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  'Conversationel',
                  style: TextStyle(
                      color: pageToShow == 2 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 3;
                  API_Manager()
                      .getfileList()
                      .then((value) => global.ListofGcodeFile = value);
                  Navigator.pushNamed(context, '/programmes');
                },
                tileColor: pageToShow == 3 ? Color(0xFF9A9A9A) : Colors.white,
                leading: Icon(
                  Icons.insert_drive_file,
                  color: pageToShow == 3 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  'Programmes',
                  style: TextStyle(
                      color: pageToShow == 3 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: pageToShow == 4 ? Color(0xFF9A9A9A) : Colors.white,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 4;
                  Navigator.pushNamed(context, '/jobStatus');
                },
                leading: Icon(
                  Icons.play_arrow_sharp,
                  color: pageToShow == 4 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  'Job Status',
                  style: TextStyle(
                      color: pageToShow == 4 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: pageToShow == 6 ? Color(0xFF9A9A9A) : Colors.white,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 6;
                  Navigator.pushNamed(context, '/origin');
                },
                leading: Icon(
                  Icons.play_arrow_sharp,
                  color: pageToShow == 6 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  "Changement d'outil",
                  style: TextStyle(
                      color: pageToShow == 6 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: pageToShow == 8 ? Color(0xFF9A9A9A) : Colors.white,
              child: ListTile(
                enabled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 8;
                  Navigator.pushNamed(context, '/setpos');
                },
                leading: Icon(
                  Icons.radar,
                  color: pageToShow == 8 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  "Set Position",
                  style: TextStyle(
                      color: pageToShow == 8 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: pageToShow == 5 ? Color(0xFF9A9A9A) : Colors.white,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 5;
                  Navigator.pushNamed(context, '/parameters');
                },
                leading: Icon(
                  Icons.settings,
                  color: pageToShow == 5 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  'Paramêtres',
                  style: TextStyle(
                      color: pageToShow == 5 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: pageToShow == 7 ? Color(0xFF9A9A9A) : Colors.white,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  pageToShow = 7;
                  Navigator.pushNamed(context, '/admin');
                },
                leading: Icon(
                  Icons.settings,
                  color: pageToShow == 7 ? Colors.white : Color(0xFF9A9A9A),
                ),
                title: Text(
                  'Admin',
                  style: TextStyle(
                      color: pageToShow == 7 ? Colors.white : Color(0xFF9A9A9A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
