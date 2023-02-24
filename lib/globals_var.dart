library my_prj.globals;
import 'package:nweb/service/API_Manager.dart';
import 'package:nweb/widgetUtils/Keyboard.dart';

import 'service/ObjectModelManager.dart';
import 'service/ObjectModelMoveManager.dart';
import 'gCodeProgram.dart';


MachineObjectModel machineObjectModel = MachineObjectModel();
ObjectModelMove objectModelMove = ObjectModelMove();


Ethernet_Connection myEthernet_connection = Ethernet_Connection();

enum MachineMode{cnc,fff,laser,unknow}
MachineMode machineMode = MachineMode.fff;

List<FileElement?>? ListofGcodeFile = [];

bool isJobPaused = false;