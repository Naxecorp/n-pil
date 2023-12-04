import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/widgetUtils/ArretUrgence.dart';
import '../globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';
import '../globals_var.dart';
import '../widgetUtils/touche.dart';
import '../widgetUtils/Joystick/my_joystick.dart';
import 'package:nweb/service/ObjectModelMoveManager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobInfo extends StatefulWidget {
  @override
  State<JobInfo> createState() => JobInfoState();
}

class JobInfoState extends State<JobInfo> {
  int secondsElapsedSinceBeginning =
      0; // Temps écoulé depuis le début en secondes
  late Timer timer;
  double pourcentageComplet = 0.0; // Pourcentage complet de la tâche
  String globalTimeValue = "00:00:00"; // Variable pour stocker le temps global
  bool isJobPaused = false;
  bool isPercentage = false; //dit si le programme a été a 100%

  void showCompletionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tâche terminée"),
          content: Text(
              "Le programme est terminé. Durée du programme : $globalTimeValue"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                API_Manager().sendGcodeCommand("M106 P3 S0");
              },
            ),
            ElevatedButton(
              child: Text("Recommencer Programme"),
              onPressed: () {
                Navigator.of(context).pop();
                API_Manager()
                    .sendGcodeCommand('M32 "0:/gcodes/' + progName + '"');
                Navigator.pushNamed(context, '/jobStatus');
              },
            ),
            ElevatedButton(
              child: Text("Dégager tête"),
              onPressed: () {
                Navigator.of(context).pop();
                API_Manager().sendGcodeCommand("M106 P3 S0");
                API_Manager().sendGcodeCommand("G53 G0 Z189").then((value) =>
                    API_Manager().sendGcodeCommand("G53 G0 X0 Y550"));
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
          ],
        );
      },
    );
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    actualiserJobObjectModel();
  }

  bool isPopupDisplayed = false;

  Future<void> actualiserJobObjectModel() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isJobPaused) {
        setState(() {
          secondsElapsedSinceBeginning++;
          int hours = secondsElapsedSinceBeginning ~/ 3600;
          int minutes = (secondsElapsedSinceBeginning % 3600) ~/ 60;
          int seconds = secondsElapsedSinceBeginning % 60;
          globalTimeValue =
              "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        });
      }

      API_Manager().getMachineJobObjectModel().then((job) {
        global.objectModelJob = job;
        pourcentageComplet = (global.objectModelJob.result?.filePosition ?? 0) /
            (global.objectModelJob.result?.file?.size?.toInt() ?? 1) *
            100;

        if (global.machineObjectModel.result?.state?.status == "idle" &&
            !isPopupDisplayed &&
            isPercentage == true) {
          isPopupDisplayed = true;
          showCompletionPopup(context);
        }
        if (pourcentageComplet == 100) {
          isPercentage = true;
        }
      });
      if (global.myEthernet_connection.isConnected == false) timer.cancel();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int hours = secondsElapsedSinceBeginning ~/ 3600;
    int minutes = (secondsElapsedSinceBeginning % 3600) ~/ 60;
    int seconds = secondsElapsedSinceBeginning % 60;
    int tempsTotalEnSecondes = 0;

    if (pourcentageComplet != 0.0) {
      int tempsTotalEnSecondes =
          (secondsElapsedSinceBeginning / (pourcentageComplet / 100)).toInt();
    }
    int tempsRestantEnSecondes =
        tempsTotalEnSecondes - secondsElapsedSinceBeginning;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      surfaceTintColor: Color.fromRGBO(240, 240, 243, 1),
      elevation: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 1, maxHeight: 30),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 35,
                        minHeight: 15,
                        maxWidth: 1000,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 5.0),
                        child: Text(
                          "Job",
                          style: TextStyle(
                            color: Color(0xFF707585),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 35,
                        minHeight: 15,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          " en cours",
                          style: TextStyle(
                            color: Color(0xFF707585),
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Depuis début",
                            style: const TextStyle(color: Color(0xFF494949)),
                          ),
                          Text(
                            globalTimeValue,
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Color(0xFF707585),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Durée restante estimée",
                            style: TextStyle(color: Color(0xFF494949)),
                          ),
                          Text(
                            "${formatDuration(tempsRestantEnSecondes)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                                color: Color(0xFF707585)),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Pourcentage",
                            style: const TextStyle(color: Color(0xFF494949)),
                          ),
                          Text(
                            "${pourcentageComplet.round().toString()}%",
                            style: const TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15,
                                color: Color(0xFF707585)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
