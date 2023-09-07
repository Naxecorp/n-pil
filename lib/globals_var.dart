library my_prj.globals;
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:nweb/service/API_Manager.dart';
import 'package:nweb/service/SystemsFiles.dart';

import 'service/ObjectModelManager.dart';
import 'service/ObjectModelMoveManager.dart';
import 'service/ObjectModelJobManager.dart';
import 'service/gCodeProgram.dart';
import 'service/nwc-settings.dart';

String pwd = "douzil";
String Title = DefaultTitle;
String DefaultTitle = version;
String version = "Version 1.0.1O"; //poche carre
bool AdminLogged = false;

MachineObjectModel machineObjectModel = MachineObjectModel();
ObjectModelMove objectModelMove = ObjectModelMove();
ObjectModelJob objectModelJob = ObjectModelJob();

enum MachineMode{cnc,fff,laser,unknow}
MachineMode machineMode = MachineMode.unknow;

MachineN02Config MyMachineN02Config = MachineN02Config(Palpeur: PalpeurOutil(PosX: 0,PosY: 630,Height: 33),IP: "192.168.1.73",GlobalMachineUsedTime:0,email: "jordan.fortel@naxe.fr",DefaultMode: "CNC");


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

String progName = "";
