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
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B879B)),
                  onPressed: () {
                    global.viewListOfOperation = !global.viewListOfOperation;
                    print(global.viewListOfOperation);
                    setState(() {
                      OpeSelected = 0;
                    });
                    global.bottomMenuToShow = 'Menu2';
                    return onAnytap!();
                  },
                  child: SizedBox(
                      height: 100,
                      child: Center(
                          child: Text(
                        'Voir liste opération',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )))),
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
