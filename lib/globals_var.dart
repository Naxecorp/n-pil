library my_prj.globals;

import 'dart:async';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/logging/action_log_config.dart';
import 'package:nweb/service/nwc-settings/magasinOutils.dart';
import 'package:nweb/service/nwc-settings/position.dart';
import 'package:nweb/service/nwc-settings/offset.dart';
import 'package:nweb/service/outils.dart';
import 'service/ObjectModelManager.dart';
import 'service/ObjectModelMoveManager.dart';
import 'service/ObjectModelJobManager.dart';
import 'service/gCode/gCodeProgram.dart';
import 'service/maintenance/maintenance_config.dart';
import 'service/nwc-settings/PalperOutil.dart';
import 'service/nwc-settings/nwc-settings.dart';
import 'service/security/user_accounts_config.dart';
import 'service/system/SystemsFilesElement.dart';
import 'service/system/replyListFiFO.dart';

String pwd = "douzil";
String Title = DefaultTitle;
String DefaultTitle = version;
String version = "Version 1.10.3";
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
bool zSafetyPopupIsShown = false;
bool AdminLogged = false;
String bottomMenuToShow = "Menu1";
bool viewListOfOperation = true;
int positions = 4;
int secondsElapsedSinceBeginning =
    0; // Temps écoulé depuis le début en secondes
String globalTimeValue = "00:00:00";
double pourcentageComplet = 0.0; // Pourcentage complet de la tâche
bool isJobStartedByUser = false; // Si le programme a bien été lancé par le User
bool popupEstAffiche = false;
bool popUpCaissonIsShown = false;
bool isRestarting = false;
double compensation = 0; // BabyStep Z
double sliderValueSpeedFactor = 0;
bool isJobPausedByUser =
    false; // Si le programme a bien été mis en pause par le User
bool isErrorDriver = false;
List<String> commandHistory = []; // Historique cmd gcode
int maxLineOfProg = 0;
var selectedGcodeFileIndex = 0;
bool DefaultConfigWasLoaded = false;
bool isModeDegrade = false;

bool programmEndUpByUser = false;

MachineObjectModel machineObjectModel = MachineObjectModel();
ObjectModelMove objectModelMove = ObjectModelMove();
ObjectModelJob objectModelJob = ObjectModelJob();
MaintenanceConfig maintenanceConfig = MaintenanceConfig.defaults();
UserAccountsConfig userAccountsConfig = UserAccountsConfig.defaults();
ActionLogConfig actionLogConfig = ActionLogConfig.defaults();
String currentUserId = "";
String currentUserName = "";

enum MachineMode { cnc, fff, laser, unknow }

MachineMode machineMode = MachineMode.unknow;

PlacementOutil magasinOutil = PlacementOutil(outil: [
  Outil(
    coordX: 122.0,
    coordY: 144.0,
    coordZ: 180.0,
    name: "Outil1",
    diametre: 2,
    hauteur: 2,
  ),
  Outil(
    coordX: 122.0,
    coordY: 144.0,
    coordZ: 180.0,
    name: "Outil2",
    diametre: 2,
    hauteur: 2,
  ),
  Outil(
    coordX: 122.0,
    coordY: 144.0,
    coordZ: 180.0,
    name: "Outil3",
    diametre: 2,
    hauteur: 2,
  ),
  Outil(
    coordX: 122.0,
    coordY: 144.0,
    coordZ: 180.0,
    name: "Outil4",
    diametre: 2,
    hauteur: 2,
  ),
  Outil(
    coordX: 122.0,
    coordY: 144.0,
    coordZ: 180.0,
    name: "Outil5",
    diametre: 2,
    hauteur: 2,
  ),
]);

MachineN02Config MyMachineN02Config = MachineN02Config(
    Palpeur: PalpeurOutil(PosX: 0, PosY: 630, Height: 33),
    Serie: "01902",
    IP: "192.168.1.78",
    GlobalMachineUsedTime: 0,
    email: "contact@naxe.fr",
    DefaultMode: "CNC",
    Positions: [
      Position(Name: "Prog1", PosX: 20, PosY: 40, PosZ: 100),
      Position(Name: "Prog2", PosX: 21, PosY: 41, PosZ: 110),
      Position(Name: "Prog3", PosX: 22, PosY: 42, PosZ: 120),
      Position(Name: "Prog4", PosX: 23, PosY: 44, PosZ: 135)
    ],
    SetPosAffichage: 4,
    HasHeatBed: 0,
    HasFanOnEnclosure: 0,
    HasLedOnEnclosure: 0,
    HasLockOnEnclosure: 0,
    HasWebAcess: 0,
    HasACT: 0,
    VitesseBroche: 24000,
    VitesseDefaut: 6400,
    Offset: [
      Offsets(Name: "Offset 3D", DecalX: 1, DecalY: 2, DecalZ: 3),
      Offsets(Name: "Offset Laser", DecalX: 4, DecalY: 5, DecalZ: 6),
    ],
    MagasinOutil: [
      MagasinOutils(CoordX: 125, CoordY: 125, CoordZ: 189, Ecartement: 60),
    ]);

MachineN02Config MyMachineN02ConfigDeflaut = MachineN02Config(
    Palpeur: PalpeurOutil(PosX: 0, PosY: 630, Height: 33),
    Serie: "DEFAULT",
    IP: "192.168.1.78",
    GlobalMachineUsedTime: 0,
    Lastmodifition: "Now",
    email: "defaultconfig",
    DefaultMode: "CNC",
    Positions: [
      Position(Name: "Prog1", PosX: 20, PosY: 40, PosZ: 100),
      Position(Name: "Prog2", PosX: 21, PosY: 41, PosZ: 110),
      Position(Name: "Prog3", PosX: 22, PosY: 42, PosZ: 120),
      Position(Name: "Prog4", PosX: 23, PosY: 44, PosZ: 135)
    ],
    SetPosAffichage: 4,
    HasHeatBed: 0,
    HasFanOnEnclosure: 0,
    HasLedOnEnclosure: 0,
    HasLockOnEnclosure: 0,
    HasWebAcess: 0,
    HasACT: 0,
    VitesseBroche: 24000,
    VitesseDefaut: 6400,
    Offset: [
      Offsets(Name: "Offset 3D", DecalX: 1, DecalY: 2, DecalZ: 3),
      Offsets(Name: "Offset Laser", DecalX: 4, DecalY: 5, DecalZ: 6),
    ],
    MagasinOutil: [
      MagasinOutils(CoordX: 457, CoordY: 1206, CoordZ: 189, Ecartement: 60),
    ]);
List<FileElement?>? ListofGcodeFile = [];
bool isJobPaused = false;

List<SysFileElement?>? ListofSysFile = [];

//List<String> ReplyList = [];
replyListFiFO ReplyListFiFo = replyListFiFO(15);

StreamController<MachineObjectModel> controllerMachineObjectModel =
    StreamController<MachineObjectModel>.broadcast();
Stream streamMachineObjectModel = controllerMachineObjectModel.stream;

String ContentofFileToEdit = "";
int selectedFileSysIndex = 0;

double Accel = 250;
double SpeedValue = 3700;
double Jerk = 350;

double ExtrudeFactor = 100;
double VentilatorFan = 0;

String progName = "";

StreamController<List<String>> controllerContentGcodeToDisplay =
    StreamController<List<String>>.broadcast();
Stream streamcontrollerContentGcodeToDisplay =
    controllerContentGcodeToDisplay.stream;

ValueNotifier<int> cursorNotifier = ValueNotifier<int>(0);

Timer? timer;
bool timerStarted = false;

void showZSafetyPopup(String message) {
  final BuildContext? context = appNavigatorKey.currentContext;
  if (context == null || zSafetyPopupIsShown) {
    return;
  }

  zSafetyPopupIsShown = true;
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text(
          "Alerte securite Z",
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  ).whenComplete(() {
    zSafetyPopupIsShown = false;
  });
}

void checkAndShowDialog(context) async {
  Timer.periodic(
    const Duration(milliseconds: 600),
    (timer) {
      if ((machineObjectModel.result?.state?.status
                  ?.toString()
                  .contains("pausing") ??
              false) ||
          (machineObjectModel.result?.state?.status
                  ?.toString()
                  .contains("busy") ??
              false)) {
        if (popupEstAffiche == false) {
          if ((machineObjectModel.result?.sensors?.gpIn?[9]?.value ?? 1) == 1) {
            popupEstAffiche = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "L'un des axes est surchargé et demande trop de puissance\nVérifiez vos paramètres d'usinage",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        API_Manager().sendGcodeCommand("M0");
                        Future.delayed(const Duration(seconds: 1), () {
                          API_Manager().sendGcodeCommand("M106 P3 S0");
                          Future.delayed(const Duration(seconds: 1), () {
                            API_Manager().sendGcodeCommand("M18 X Y");
                            Future.delayed(const Duration(seconds: 1), () {
                              API_Manager().sendGcodeCommand("M17 X Y");
                              Navigator.pushNamed(context, '/dashboard');
                              popupEstAffiche = false;
                              isJobPausedByUser = false;
                              isErrorDriver = true;
                            });
                          });
                        });
                      },
                      child: const Text(
                        "Réinitialiser les drivers & arrêter le programme",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              },
            );
          }
        }
      }
    },
  );
}

void checkCaissonOpen(BuildContext context) {
  popUpCaissonIsShown = false;
  Timer.periodic(const Duration(milliseconds: 600), (timer) {
    if (AdminLogged == false && isModeDegrade == false) {
      if ((machineObjectModel.result?.sensors?.gpIn?[10]?.value ?? 1) == 0) {
        if (popUpCaissonIsShown == false) {
          popUpCaissonIsShown = true;
          if ((machineObjectModel.result?.state?.status
                      ?.toString()
                      .contains("idle") ??
                  false) ||
              (machineObjectModel.result?.state?.status
                      ?.toString()
                      .contains("processing") ??
                  false) ||
              (machineObjectModel.result?.state?.status
                      ?.toString()
                      .contains("pausing") ??
                  false) ||
              (machineObjectModel.result?.state?.status
                      ?.toString()
                      .contains("paused") ??
                  false) ||
              (machineObjectModel.result?.state?.status
                      ?.toString()
                      .contains("busy") ??
                  false)) {
            ((machineObjectModel.result?.state?.status
                            ?.toString()
                            .contains("idle") ??
                        false) ||
                    (machineObjectModel.result?.state?.status
                            ?.toString()
                            .contains("busy") ??
                        false))
                ? API_Manager().sendGcodeCommand("M5 P0")
                : null;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "La porte du caisson s'est ouverte !",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        popUpCaissonIsShown = false;
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Fermer",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              },
            );
          }
        }
      }
    }
  });
}
