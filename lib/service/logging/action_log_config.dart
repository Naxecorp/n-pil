import 'dart:convert';

ActionLogConfig actionLogConfigFromJson(String source) {
  return ActionLogConfig.fromJson(
    json.decode(source) as Map<String, dynamic>,
  );
}

String actionLogConfigToJson(ActionLogConfig data) {
  return json.encode(data.toJson());
}

class ActionLogEntry {
  ActionLogEntry({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.userName,
    required this.category,
    required this.action,
    this.target,
    this.details,
    this.result = 'ok',
  });

  String id;
  String timestamp;
  String userId;
  String userName;
  String category;
  String action;
  String? target;
  String? details;
  String result;

  factory ActionLogEntry.fromJson(Map<String, dynamic> json) {
    return ActionLogEntry(
      id: json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp:
          json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
      userId: json['userId']?.toString() ?? 'unknown',
      userName: json['userName']?.toString() ?? 'unknown',
      category: json['category']?.toString() ?? 'general',
      action: json['action']?.toString() ?? 'unknown',
      target: json['target']?.toString(),
      details: json['details']?.toString(),
      result: json['result']?.toString() ?? 'ok',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
      'userId': userId,
      'userName': userName,
      'category': category,
      'action': action,
      'target': target,
      'details': details,
      'result': result,
    };
  }

  ActionLogEntry copy() {
    return ActionLogEntry(
      id: id,
      timestamp: timestamp,
      userId: userId,
      userName: userName,
      category: category,
      action: action,
      target: target,
      details: details,
      result: result,
    );
  }
}

class ActionLogConfig {
  ActionLogConfig({
    required this.entries,
    this.lastModification,
  });

  static const String fileName = 'user-actions-log.json';
  static const int maxEntries = 1500;

  List<ActionLogEntry> entries;
  String? lastModification;

  factory ActionLogConfig.fromJson(Map<String, dynamic> json) {
    final dynamic rawEntries = json['entries'];
    final List<ActionLogEntry> parsedEntries = rawEntries is List
        ? rawEntries
            .whereType<Map<String, dynamic>>()
            .map(ActionLogEntry.fromJson)
            .toList()
        : <ActionLogEntry>[];
    return ActionLogConfig(
      entries: parsedEntries,
      lastModification: json['lastModification']?.toString(),
    );
  }

  void ensureConsistency() {
    if (entries.length > maxEntries) {
      entries = entries.sublist(0, maxEntries);
    }
  }

  void prepend(ActionLogEntry entry) {
    entries.insert(0, entry);
    ensureConsistency();
    lastModification = DateTime.now().toIso8601String();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lastModification': lastModification,
      'entries': entries.map((entry) => entry.toJson()).toList(),
    };
  }

  ActionLogConfig copy() {
    return ActionLogConfig(
      entries: entries.map((entry) => entry.copy()).toList(),
      lastModification: lastModification,
    );
  }

  static ActionLogConfig defaults() {
    return ActionLogConfig(
      lastModification: DateTime.now().toIso8601String(),
      entries: <ActionLogEntry>[],
    );
  }
}
