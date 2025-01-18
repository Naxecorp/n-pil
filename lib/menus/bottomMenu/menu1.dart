import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nweb/OpeListView.dart';
import '../../OpeListView.dart';
import '../../screen/screens.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/globals_var.dart' as global;

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
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(flex: 10, child: Container()),
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                label: const Text(
                  "Voir liste opération",
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B879B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  global.viewListOfOperation = !global.viewListOfOperation;
                  setState(() {
                    OpeSelected = 0;
                  });
                  global.bottomMenuToShow = 'Menu2';
                  return onAnytap!();
                },
              ),
            ),
          ),
          Flexible(flex: 10, child: Container()),
          Flexible(flex: 15, child: Container()),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
