import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, this.title, this.child,required this.onAnyTap,});

  final String? title;
  final Widget? child;

  final VoidCallback onAnyTap;

  @override
  State<SideMenu> createState() => _SideMenu(onAnyTap);
}

class _SideMenu extends State<SideMenu> {

  final VoidCallback onAnytap;

  _SideMenu(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Card(
              child: ListTile(
                onTap: (){pageToShow = 1; return onAnytap();},
                tileColor: pageToShow==1?Color(0xFF9A9A9A):Colors.white,
                leading: Icon(Icons.home_filled,color: pageToShow==1?Colors.white:Color(0xFF9A9A9A),),
                title: Text('Dashboard',style: TextStyle(color: pageToShow==1?Colors.white:Color(0xFF9A9A9A),fontWeight: FontWeight.bold),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: Card(
              child: ListTile(
                onTap: (){pageToShow = 2; return onAnytap();},
                tileColor: pageToShow==2?Color(0xFF9A9A9A):Colors.white,
                leading: Icon(Icons.screen_share_outlined,color: pageToShow==2?Colors.white:Color(0xFF9A9A9A),),
                title: Text('Conversationel',style: TextStyle(color: pageToShow==2?Colors.white:Color(0xFF9A9A9A),fontWeight: FontWeight.bold),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: Card(
              child: ListTile(
                onTap: (){pageToShow = 3; return onAnytap();},
                tileColor: pageToShow==3?Color(0xFF9A9A9A):Colors.white,
                leading: Icon(Icons.insert_drive_file,color: pageToShow==3?Colors.white:Color(0xFF9A9A9A),),
                title: Text('Programmes',style: TextStyle(color: pageToShow==3?Colors.white:Color(0xFF9A9A9A),fontWeight: FontWeight.bold),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: Card(
              color: pageToShow==4?Color(0xFF9A9A9A):Colors.white,
              child: ListTile(
                onTap: (){pageToShow = 4;
                return onAnytap();},
                leading: Icon(Icons.settings, color: pageToShow==4?Colors.white:Color(0xFF9A9A9A),),
                title: Text('Parametres',style: TextStyle(color: pageToShow==4?Colors.white:Color(0xFF9A9A9A),fontWeight: FontWeight.bold),),
              ),
            ),
          ),

        ],
      ),
    );
    throw UnimplementedError();
  }
}
