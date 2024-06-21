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
  // Variable pour stocker le temps global
  bool isJobPaused = false;
  bool isPercentage = false; //dit si le programme a été a 100%

  void showCompletionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tâche terminée"),
          content: Text(
              "Le programme est terminé. Durée du dernier programme : ${global.globalTimeValue}"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                global.secondsElapsedSinceBeginning = 0;
                global.timerStarted = false;
                global.isJobPausedByUser = false;
                global.globalTimeValue = "00:00:00";
                global.timer!.cancel();
                Navigator.of(context).pop();
                API_Manager().sendGcodeCommand("M106 P3 S0");
              },
            ),
            ElevatedButton(
              child: Text("Recommencer Programme"),
              onPressed: () async {
                global.secondsElapsedSinceBeginning = 0;
                global.globalTimeValue = "00:00:00";
                global.isJobPausedByUser = false;
                global.timerStarted = false;
                global.timer!.cancel();
                Navigator.of(context).pop();
                API_Manager()
                    .sendGcodeCommand('M32 "0:/gcodes/' + progName + '"');
                Navigator.pushNamed(context, '/jobStatus');
              },
            ),
            ElevatedButton(
              child: Text("Dégager tête"),
              onPressed: () async {
                global.secondsElapsedSinceBeginning = 0;
                global.globalTimeValue = "00:00:00";
                global.isJobPausedByUser = false;
                global.timerStarted = false;
                global.timer!.cancel();
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                  API_Manager().sendGcodeCommand('M98 P"degagerTete.g"').then(
                      (value) => Navigator.pushNamed(context, '/dashboard'));
                });
                // API_Manager().sendGcodeCommand("M106 P3 S0");
                // API_Manager().sendGcodeCommand("G53 G0 Z189").then((value) =>
                //     API_Manager().sendGcodeCommand("G53 G0 X0 Y550"));
              },
            ),
          ],
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    // Extrayez les composants de la durée
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    // Créez une chaîne de format HH:MM:SS
    String formattedDuration =
        '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedDuration;
  }

  // Fonction pour calculer le temps restant en fonction du temps écoulé et du pourcentage de progression
  Duration calculateRemainingTime(int elapsedSeconds, double percentage) {
    // Assurez-vous que le pourcentage est compris entre 0 et 100
    if (percentage < 0.0 || percentage > 100.0) {
      throw ArgumentError('Le pourcentage doit être compris entre 0 et 100.');
    }

    // Assurez-vous que le temps écoulé est positif
    if (elapsedSeconds < 0.0) {
      throw ArgumentError('Le temps écoulé ne peut pas être négatif.');
    }

    // Convertissez le pourcentage en une valeur entre 0 et 1
    double percentageDecimal = percentage / 100.0;

    // Vérifiez si le pourcentage est 100, dans ce cas, le temps restant est 0
    if (percentageDecimal == 1.0) {
      return Duration(seconds: 0);
    }

    // Calculez le temps restant en fonction du temps écoulé et du pourcentage
    if (percentageDecimal > 0) {
      double remainingSeconds =
          (elapsedSeconds / percentageDecimal) - elapsedSeconds;
      // Créez et renvoyez la durée du temps restant en secondes
      return Duration(seconds: remainingSeconds.round());
    } else {
      return Duration(seconds: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!global.timerStarted && global.isJobStartedByUser == true) {
      print(global.timerStarted);
      print(global.isJobStartedByUser);
      actualiserJobObjectModel();
      global.timerStarted = true;
    }
  }

  bool isPopupDisplayed = false;

  Future<void> actualiserJobObjectModel() async {
    global.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isJobPaused &&
          global.machineObjectModel.result?.state?.status == "processing") {
        global.secondsElapsedSinceBeginning++;
        setState(() {
          Duration durreDepuisLeDebut =
              Duration(seconds: global.secondsElapsedSinceBeginning);
          global.globalTimeValue = formatDuration(durreDepuisLeDebut);
        });
      }

      API_Manager().getMachineJobObjectModel().then((job) {
        global.objectModelJob = job;
        global.pourcentageComplet =
            (global.objectModelJob.result?.filePosition ?? 0) /
                (global.objectModelJob.result?.file?.size?.toInt() ?? 1) *
                100;

        if (global.machineObjectModel.result?.state?.status == "idle" &&
            global.isJobStartedByUser == true) {
          isPopupDisplayed = true;
          global.isJobStartedByUser = false;
          timer.cancel();
          global.timer!.cancel();
          global.secondsElapsedSinceBeginning = 0;
          showCompletionPopup(context);
          global.timerStarted = false;
        }
        if (global.pourcentageComplet == 100) {
          isPercentage = true;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            global.globalTimeValue,
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
                            "${formatDuration(calculateRemainingTime(global.secondsElapsedSinceBeginning, global.pourcentageComplet))}",
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
                            "${global.pourcentageComplet.round().toString()}%",
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
