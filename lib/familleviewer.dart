import 'package:flutter/material.dart';
import 'menus/opeMenu/ope_menu_connect.dart';
import 'screen/screens.dart';
import 'menus/opeMenu/ope_menu.dart';

class FamilleWiewer extends StatefulWidget {
  const FamilleWiewer({
    super.key,
    this.title,
    this.child,
    this.onAnyTap,
  });

  final String? title;
  final Widget? child;

  final VoidCallback? onAnyTap;

  @override
  State<FamilleWiewer> createState() => _FamilleWiewer(onAnyTap);
}

class _FamilleWiewer extends State<FamilleWiewer> {
  final VoidCallback? onAnytap;

  _FamilleWiewer(this.onAnytap);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.orange,
      child: FamillyToShow == 'classique'
          ? OpeMenuUsinage()
          : FamillyToShow == 'connecteur'
              ? OpeMenuConnecteur()
              : Container(),
    );
    throw UnimplementedError();
  }
}
