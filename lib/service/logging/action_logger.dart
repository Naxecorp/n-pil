import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:nweb/globals_var.dart' as global;
import 'package:nweb/service/API/API_Manager.dart';

import 'action_log_config.dart';

class ActionLogger {
  static Future<void> _queue = Future<void>.value();

  static Future<void> log({
    required String category,
    required String action,
    String? target,
    String? details,
    String result = 'ok',
  }) async {
    _queue = _queue.then((_) async {
      final String nowIso = DateTime.now().toIso8601String();
      final ActionLogEntry entry = ActionLogEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        timestamp: nowIso,
        userId:
            global.currentUserId.isNotEmpty ? global.currentUserId : 'unknown',
        userName: global.currentUserName.isNotEmpty
            ? global.currentUserName
            : 'unknown',
        category: category,
        action: action,
        target: target,
        details: details,
        result: result,
      );

      final ActionLogConfig currentConfig = global.actionLogConfig.copy();
      currentConfig.prepend(entry);
      global.actionLogConfig = currentConfig;

      await _persist();
    }).catchError((_) {});

    await _queue;
  }

  static Future<void> _persist() async {
    final ActionLogConfig config = global.actionLogConfig.copy();
    final String content = actionLogConfigToJson(config);
    final Uint8List bytes = Uint8List.fromList(utf8.encode(content));
    await API_Manager().upLoadAFile(
      "0:/sys/${ActionLogConfig.fileName}",
      bytes.length.toString(),
      bytes,
    );
  }
}
