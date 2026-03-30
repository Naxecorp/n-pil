import 'dart:convert';

MaintenanceConfig maintenanceConfigFromJson(String source) {
  return MaintenanceConfig.fromJson(
    json.decode(source) as Map<String, dynamic>,
  );
}

String maintenanceConfigToJson(MaintenanceConfig data) {
  return json.encode(data.toJson());
}

class MaintenanceSection {
  MaintenanceSection({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory MaintenanceSection.fromJson(Map<String, dynamic> json) {
    return MaintenanceSection(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  MaintenanceSection copy() {
    return MaintenanceSection(id: id, name: name);
  }
}

class MaintenanceOperation {
  static const String modeMachineOn = 'machine_on';
  static const String modeProcessing = 'processing';

  MaintenanceOperation({
    required this.id,
    required this.name,
    required this.description,
    this.sectionId = MaintenanceConfig.machineSectionId,
    this.countdownMode = modeMachineOn,
    this.countedSeconds = 0,
    this.frequencyDays = 0,
    this.frequencyHours = 0,
    this.lastDoneAt,
    this.lastDoneByUserId,
    this.lastDoneByUserName,
  }) {
    normalizeFrequency();
    normalizeCounter();
  }

  String id;
  String name;
  String description;
  String sectionId;
  String countdownMode;
  double countedSeconds;
  int frequencyDays;
  int frequencyHours;
  String? lastDoneAt;
  String? lastDoneByUserId;
  String? lastDoneByUserName;

  DateTime? get lastDoneDateTime {
    if (lastDoneAt == null || lastDoneAt!.isEmpty) {
      return null;
    }
    return DateTime.tryParse(lastDoneAt!);
  }

  Duration get frequencyDuration =>
      Duration(days: frequencyDays, hours: frequencyHours);

  void normalizeFrequency() {
    if (frequencyDays < 0) {
      frequencyDays = 0;
    }
    if (frequencyHours < 0) {
      frequencyHours = 0;
    }
    frequencyDays += frequencyHours ~/ 24;
    frequencyHours = frequencyHours % 24;
  }

  static int _parseNonNegativeInt(dynamic value, {int fallback = 0}) {
    final int? parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed < 0) {
      return fallback;
    }
    return parsed;
  }

  static double _parseNonNegativeDouble(dynamic value, {double fallback = 0}) {
    final double? parsed = double.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed < 0) {
      return fallback;
    }
    return parsed;
  }

  void normalizeCounter() {
    if (countdownMode != modeMachineOn && countdownMode != modeProcessing) {
      countdownMode = modeMachineOn;
    }
    if (countedSeconds.isNaN ||
        countedSeconds.isInfinite ||
        countedSeconds < 0) {
      countedSeconds = 0;
    }
  }

  factory MaintenanceOperation.fromJson(Map<String, dynamic> json) {
    final bool hasDays = json.containsKey('frequencyDays');
    final bool hasHours = json.containsKey('frequencyHours');
    final bool hasCountedSeconds = json.containsKey('countedSeconds');
    int parsedDays = _parseNonNegativeInt(json['frequencyDays']);
    int parsedHours = _parseNonNegativeInt(json['frequencyHours']);
    if (!hasDays && !hasHours) {
      parsedDays = 30;
      parsedHours = 0;
    }

    String parsedMode = json['countdownMode']?.toString() ?? modeMachineOn;
    if (parsedMode != modeMachineOn && parsedMode != modeProcessing) {
      parsedMode = modeMachineOn;
    }

    double parsedCountedSeconds =
        _parseNonNegativeDouble(json['countedSeconds']);

    // Migration for older JSON payloads: if no persisted counter existed,
    // approximate elapsed time from lastDoneAt for machine_on mode.
    if (!hasCountedSeconds && parsedMode == modeMachineOn) {
      final DateTime? lastDone =
          DateTime.tryParse(json['lastDoneAt']?.toString() ?? '');
      if (lastDone != null) {
        final Duration delta = DateTime.now().difference(lastDone);
        if (!delta.isNegative) {
          parsedCountedSeconds = delta.inSeconds.toDouble();
        }
      }
    }

    return MaintenanceOperation(
      id: json['id']?.toString() ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Operation sans nom',
      description: json['description']?.toString() ?? '',
      sectionId:
          json['sectionId']?.toString() ?? MaintenanceConfig.machineSectionId,
      countdownMode: parsedMode,
      countedSeconds: parsedCountedSeconds,
      frequencyDays: parsedDays,
      frequencyHours: parsedHours,
      lastDoneAt: json['lastDoneAt']?.toString(),
      lastDoneByUserId: json['lastDoneByUserId']?.toString(),
      lastDoneByUserName: json['lastDoneByUserName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'sectionId': sectionId,
      'countdownMode': countdownMode,
      'countedSeconds': countedSeconds,
      'frequencyDays': frequencyDays,
      'frequencyHours': frequencyHours,
      'lastDoneAt': lastDoneAt,
      'lastDoneByUserId': lastDoneByUserId,
      'lastDoneByUserName': lastDoneByUserName,
    };
  }

  MaintenanceOperation copy() {
    return MaintenanceOperation(
      id: id,
      name: name,
      description: description,
      sectionId: sectionId,
      countdownMode: countdownMode,
      countedSeconds: countedSeconds,
      frequencyDays: frequencyDays,
      frequencyHours: frequencyHours,
      lastDoneAt: lastDoneAt,
      lastDoneByUserId: lastDoneByUserId,
      lastDoneByUserName: lastDoneByUserName,
    );
  }
}

class MaintenanceConfig {
  MaintenanceConfig({
    required this.sections,
    required this.operations,
    this.lastModification,
  }) {
    ensureConsistency();
  }

  static const String fileName = 'maintenance-operations.json';
  static const String machineSectionId = 'machine';
  static const String machineSectionName = 'machine';

  List<MaintenanceSection> sections;
  List<MaintenanceOperation> operations;
  String? lastModification;

  factory MaintenanceConfig.fromJson(Map<String, dynamic> json) {
    final dynamic rawSections = json['sections'];
    final List<MaintenanceSection> parsedSections = rawSections is List
        ? rawSections
            .whereType<Map<String, dynamic>>()
            .map(MaintenanceSection.fromJson)
            .where(
                (section) => section.id.isNotEmpty && section.name.isNotEmpty)
            .toList()
        : <MaintenanceSection>[];

    final dynamic rawList = json['operations'];
    final List<MaintenanceOperation> parsedOperations = rawList is List
        ? rawList
            .whereType<Map<String, dynamic>>()
            .map(MaintenanceOperation.fromJson)
            .toList()
        : <MaintenanceOperation>[];

    return MaintenanceConfig(
      sections: parsedSections,
      operations: parsedOperations,
      lastModification: json['lastModification']?.toString(),
    );
  }

  void ensureConsistency() {
    final bool hasMachine =
        sections.any((section) => section.id == machineSectionId);
    if (!hasMachine) {
      sections.insert(
        0,
        MaintenanceSection(
          id: machineSectionId,
          name: machineSectionName,
        ),
      );
    }

    final Set<String> validSectionIds =
        sections.map((section) => section.id).toSet();
    for (final MaintenanceOperation operation in operations) {
      if (!validSectionIds.contains(operation.sectionId)) {
        operation.sectionId = machineSectionId;
      }
      operation.normalizeCounter();
    }
  }

  String sectionNameFor(String sectionId) {
    for (final MaintenanceSection section in sections) {
      if (section.id == sectionId) {
        return section.name;
      }
    }
    return machineSectionName;
  }

  bool isMachineSection(String sectionId) {
    return sectionId == machineSectionId;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lastModification': lastModification,
      'sections': sections.map((section) => section.toJson()).toList(),
      'operations': operations.map((op) => op.toJson()).toList(),
    };
  }

  MaintenanceConfig copy() {
    return MaintenanceConfig(
      sections: sections.map((section) => section.copy()).toList(),
      operations: operations.map((op) => op.copy()).toList(),
      lastModification: lastModification,
    );
  }

  static MaintenanceConfig defaults() {
    return MaintenanceConfig(
      lastModification: DateTime.now().toIso8601String(),
      sections: <MaintenanceSection>[
        MaintenanceSection(id: machineSectionId, name: machineSectionName),
      ],
      operations: <MaintenanceOperation>[
        MaintenanceOperation(
          id: 'rails-cleaning',
          name: 'Nettoyage des rails et vis',
          description:
              'Depoussierer puis nettoyer les rails/vis avec un chiffon non pelucheux. '
              'Verifier l\'absence de copeaux sur les guidages et reappliquer un lubrifiant adapte.',
          sectionId: machineSectionId,
          frequencyDays: 7,
          frequencyHours: 0,
        ),
        MaintenanceOperation(
          id: 'spindle-check',
          name: 'Controle broche et refroidissement',
          description:
              'Verifier le bon serrage de la broche, le bruit au demarrage et le systeme de refroidissement. '
              'Confirmer qu\'aucune alerte temperature n\'est presente.',
          sectionId: machineSectionId,
          frequencyDays: 14,
          frequencyHours: 0,
        ),
        MaintenanceOperation(
          id: 'electrical-check',
          name: 'Controle capteurs et connectique',
          description:
              'Verifier le bon etat des connecteurs, capteurs de fin de course et cables en mouvement. '
              'Remplacer ou resserrer tout element suspect.',
          sectionId: machineSectionId,
          frequencyDays: 30,
          frequencyHours: 0,
        ),
      ],
    );
  }
}
