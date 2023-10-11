import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nweb/OpeListView.dart';
import '../../screen/screens.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/globals_var.dart' as global;

import 'menu1.dart';
import 'menu2.dart';

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
    return global.bottomMenuToShow == 'Menu1'
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
