library my_prj.globals;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/nwc-settings/position.dart';
import 'package:nweb/service/system/SystemsFiles.dart';

import 'service/API/Ethernet_connection.dart';
import 'service/ObjectModelManager.dart';
import 'service/ObjectModelMoveManager.dart';
import 'service/ObjectModelJobManager.dart';
import 'service/gCode/gCodeProgram.dart';
import 'service/nwc-settings/PalperOutil.dart';
import 'service/nwc-settings/nwc-settings.dart';
import 'service/system/SystemsFilesElement.dart';

String pwd = "douzil";
String Title = DefaultTitle;
String DefaultTitle = version;
String version = "Version 1.3.1"; 
bool AdminLogged = false;
String bottomMenuToShow = "Menu1";
bool viewListOfOperation = true;

MachineObjectModel machineObjectModel = MachineObjectModel();
ObjectModelMove objectModelMove = ObjectModelMove();
ObjectModelJob objectModelJob = ObjectModelJob();

enum MachineMode { cnc, fff, laser, unknow }

MachineMode machineMode = MachineMode.unknow;

MachineN02Config MyMachineN02Config = MachineN02Config(
    Palpeur: PalpeurOutil(PosX: 0, PosY: 630, Height: 33),
    IP: "192.168.1.78",
    GlobalMachineUsedTime: 0,
    email: "jordan.fortel@naxe.fr",
    DefaultMode: "CNC",
    Positions: [
      Position(PosX: 20, PosY: 40, PosZ: 100),
      Position(PosX: 21, PosY: 41, PosZ: 110),
      Position(PosX: 22, PosY: 42, PosZ: 120)
    ]);

MachineN02Config MyMachineN02ConfigDeflaut = MachineN02Config(
    Palpeur: PalpeurOutil(PosX: 0, PosY: 630, Height: 33),
    IP: "192.168.1.78",
    GlobalMachineUsedTime: 0,
    email: "defaultconfig",
    DefaultMode: "CNC",
    Positions: [
      Position(PosX: 20, PosY: 40, PosZ: 100),
      Position(PosX: 21, PosY: 41, PosZ: 110),
      Position(PosX: 22, PosY: 42, PosZ: 120)
    ]);

Ethernet_Connection myEthernet_connection = Ethernet_Connection();
List<FileElement?>? ListofGcodeFile = [];
bool isJobPaused = false;

List<SysFileElement?>? ListofSysFile = [];

List<String> ReplyList = [];

StreamController<MachineObjectModel> controllerMachineObjectModel = StreamController<MachineObjectModel>.broadcast();
Stream streamMachineObjectModel = controllerMachineObjectModel.stream;

String ContentofFileToEdit = "";
int selectedFileSysIndex = 0;

double Accel = 250;
double SpeedValue = 3700;
double Jerk = 350;

double ExtrudeFactor = 100;
double VentilatorFan = 0;



String progName = "";


StreamController<List<String>> controllerContentGcodeToDisplay = StreamController<List<String>>.broadcast();
Stream streamcontrollerContentGcodeToDisplay = controllerContentGcodeToDisplay.stream;
