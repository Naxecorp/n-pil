import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../ObjectModelManager.dart';
import '../ObjectModelMoveManager.dart';
import '../ObjectModelJobManager.dart';
import 'package:nweb/globals_var.dart' as global;
import '../system/SystemsFiles.dart';
import '../gCode/gCodeProgram.dart';

import '../nwc-settings/nwc-settings.dart';

class Ethernet_Connection {
  bool? isConnected = false;

  Ethernet_Connection({
    this.isConnected,
  });
}
