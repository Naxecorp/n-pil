library my_prj.globals;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/nwc-settings/position.dart';
import 'package:nweb/service/nwc-settings/offset.dart';
import 'package:nweb/service/system/SystemsFiles.dart';

import 'service/API/Ethernet_connection.dart';
import 'service/ObjectModelManager.dart';
import 'service/ObjectModelMoveManager.dart';
import 'service/ObjectModelJobManager.dart';
import 'service/gCode/gCodeProgram.dart';
import 'service/nwc-settings/PalperOutil.dart';
import 'service/nwc-settings/nwc-settings.dart';
import 'service/system/SystemsFilesElement.dart';
import 'service/system/replyListFiFO.dart';

String pwd = "douzil";
String Title = DefaultTitle;
String DefaultTitle = version;
String version = "Version 1.6.5";
bool AdminLogged = false;
String bottomMenuToShow = "Menu1";
bool viewListOfOperation = true;
int positions = 4;
int secondsElapsedSinceBeginning =
    0; // Temps écoulé depuis le début en secondes
double pourcentageComplet = 0.0; // Pourcentage complet de la tâche
bool isJobStartedByUser = false; // Si le programme a bien été lancé par le User
double compensation = 0; // BabyStep Z

MachineObjectModel machineObjectModel = MachineObjectModel();
ObjectModelMove objectModelMove = ObjectModelMove();
ObjectModelJob objectModelJob = ObjectModelJob();

enum MachineMode { cnc, fff, laser, unknow }

MachineMode machineMode = MachineMode.unknow;

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
    VitesseBroche: 24000,
    VitesseDefaut: 6400,
    Offset: [
      Offsets(Name: "Offset 3D", DecalX: 1, DecalY: 2, DecalZ: 3),
      Offsets(Name: "Offset Laser", DecalX: 4, DecalY: 5, DecalZ: 6),
    ]);

MachineN02Config MyMachineN02ConfigDeflaut = MachineN02Config(
    Palpeur: PalpeurOutil(PosX: 0, PosY: 630, Height: 33),
    Serie: "DEFAULT",
    IP: "192.168.1.78",
    GlobalMachineUsedTime: 0,
    email: "defaultconfig",
    DefaultMode: "CNC",
    Positions: [
      Position(Name: "Prog1", PosX: 20, PosY: 40, PosZ: 100),
      Position(Name: "Prog2", PosX: 21, PosY: 41, PosZ: 110),
      Position(Name: "Prog3", PosX: 22, PosY: 42, PosZ: 120),
      Position(Name: "Prog4", PosX: 23, PosY: 44, PosZ: 135)
    ],
    SetPosAffichage: 4,
    HasHeatBed: 1,
    HasFanOnEnclosure: 1,
    HasLedOnEnclosure: 1,
    VitesseBroche: 24000,
    VitesseDefaut: 6400,
    Offset: [
      Offsets(Name: "Offset 3D", DecalX: 1, DecalY: 2, DecalZ: 3),
      Offsets(Name: "Offset Laser", DecalX: 4, DecalY: 5, DecalZ: 6),
    ]);

Ethernet_Connection myEthernet_connection = Ethernet_Connection();
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

Timer? timer;
bool timerStarted = false;
