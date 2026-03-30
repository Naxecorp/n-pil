import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/menus/side_menu.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/logging/action_logger.dart';
import 'package:nweb/service/maintenance/maintenance_config.dart';
import 'package:nweb/widgetUtils/account_toolbar_button.dart';
import 'package:nweb/widgetUtils/window.dart';

import '../globals_var.dart' as global;

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  static const String _allSectionsFilterId = '__all__';

  List<MaintenanceSection> _sections = <MaintenanceSection>[];
  List<MaintenanceOperation> _operations = <MaintenanceOperation>[];
  String _sectionFilterId = _allSectionsFilterId;
  bool _isBusy = false;
  String _status = '';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    pageToShow = 10;
    final MaintenanceConfig initialConfig = global.maintenanceConfig.copy();
    _sections = initialConfig.sections;
    _operations = initialConfig.operations;
    if (_sections.isEmpty) {
      final MaintenanceConfig fallback = MaintenanceConfig.defaults();
      _sections = fallback.sections;
    }

    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (global.MyMachineN02Config.HasFanOnEnclosure == 1) {
        global.checkCaissonOpen(context);
      }
    });

    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _ensureFilterIsValid() {
    if (_sectionFilterId == _allSectionsFilterId) {
      return;
    }
    final bool exists =
        _sections.any((section) => section.id == _sectionFilterId);
    if (!exists) {
      _sectionFilterId = _allSectionsFilterId;
    }
  }

  bool _isMachineSection(String sectionId) {
    return sectionId == MaintenanceConfig.machineSectionId;
  }

  String _sectionNameFor(String sectionId) {
    for (final MaintenanceSection section in _sections) {
      if (section.id == sectionId) {
        return section.name;
      }
    }
    return MaintenanceConfig.machineSectionName;
  }

  List<MaintenanceOperation> _filteredOperations() {
    if (_sectionFilterId == _allSectionsFilterId) {
      return _operations;
    }
    return _operations
        .where((operation) => operation.sectionId == _sectionFilterId)
        .toList();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return 'Jamais effectuee';
    }
    final DateTime? parsed = DateTime.tryParse(isoDate);
    if (parsed == null) {
      return 'Date invalide';
    }
    final String d = parsed.day.toString().padLeft(2, '0');
    final String m = parsed.month.toString().padLeft(2, '0');
    final String y = parsed.year.toString();
    final String hh = parsed.hour.toString().padLeft(2, '0');
    final String mm = parsed.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $hh:$mm';
  }

  String _currentUserIdForMaintenance() {
    if (global.currentUserId.isNotEmpty) {
      return global.currentUserId;
    }
    return 'inconnu';
  }

  String _currentUserNameForMaintenance() {
    if (global.currentUserName.isNotEmpty) {
      return global.currentUserName;
    }
    if (global.currentUserId.isNotEmpty) {
      return global.currentUserId;
    }
    return 'inconnu';
  }

  void _setOperationLastDoneByCurrentUser(MaintenanceOperation operation) {
    operation.lastDoneByUserId = _currentUserIdForMaintenance();
    operation.lastDoneByUserName = _currentUserNameForMaintenance();
  }

  String _formatLastDoneBy(MaintenanceOperation operation) {
    final String id = (operation.lastDoneByUserId ?? '').trim();
    final String name = (operation.lastDoneByUserName ?? '').trim();
    if (id.isEmpty && name.isEmpty) {
      return 'Inconnu';
    }
    if (id.isEmpty) {
      return name;
    }
    if (name.isEmpty) {
      return id;
    }
    return '$name ($id)';
  }

  String _normalizeStorageText(String input) {
    const Map<String, String> replacements = <String, String>{
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'å': 'a',
      'À': 'A',
      'Á': 'A',
      'Â': 'A',
      'Ã': 'A',
      'Ä': 'A',
      'Å': 'A',
      'ç': 'c',
      'Ç': 'C',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'È': 'E',
      'É': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'Ì': 'I',
      'Í': 'I',
      'Î': 'I',
      'Ï': 'I',
      'ñ': 'n',
      'Ñ': 'N',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'Ò': 'O',
      'Ó': 'O',
      'Ô': 'O',
      'Õ': 'O',
      'Ö': 'O',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'Ù': 'U',
      'Ú': 'U',
      'Û': 'U',
      'Ü': 'U',
      'ý': 'y',
      'ÿ': 'y',
      'Ý': 'Y',
      'œ': 'oe',
      'Œ': 'OE',
      'æ': 'ae',
      'Æ': 'AE',
    };

    final StringBuffer buffer = StringBuffer();
    for (final int rune in input.runes) {
      final String char = String.fromCharCode(rune);
      buffer.write(replacements[char] ?? char);
    }

    String value = buffer.toString();
    value = value.replaceAll(RegExp(r'[^A-Za-z0-9 \n_\-.,:;!?()/+%]'), '');
    value = value.replaceAll(RegExp(r' +'), ' ');
    value = value.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return value.trim();
  }

  MaintenanceConfig _sanitizeConfigForStorage(MaintenanceConfig source) {
    final List<MaintenanceSection> sanitizedSections =
        source.sections.map((section) => section.copy()).toList();
    for (final MaintenanceSection section in sanitizedSections) {
      if (_isMachineSection(section.id)) {
        section.name = MaintenanceConfig.machineSectionName;
      } else {
        section.name = _normalizeStorageText(section.name);
        if (section.name.isEmpty) {
          section.name = 'section';
        }
      }
    }

    final List<MaintenanceOperation> sanitizedOperations =
        source.operations.map((operation) => operation.copy()).toList();
    for (final MaintenanceOperation operation in sanitizedOperations) {
      operation.name = _normalizeStorageText(operation.name);
      operation.description = _normalizeStorageText(operation.description);
      final String cleanedUserId =
          _normalizeStorageText(operation.lastDoneByUserId ?? '');
      final String cleanedUserName =
          _normalizeStorageText(operation.lastDoneByUserName ?? '');
      operation.lastDoneByUserId = cleanedUserId.isEmpty ? null : cleanedUserId;
      operation.lastDoneByUserName =
          cleanedUserName.isEmpty ? null : cleanedUserName;
      if (operation.name.isEmpty) {
        operation.name = 'Operation';
      }
      if (operation.description.isEmpty) {
        operation.description = 'Aucun detail';
      }
    }

    final MaintenanceConfig sanitized = MaintenanceConfig(
      sections: sanitizedSections,
      operations: sanitizedOperations,
      lastModification: source.lastModification,
    );
    sanitized.ensureConsistency();
    return sanitized;
  }

  String _formatFrequency(MaintenanceOperation operation) {
    return '${operation.frequencyDays}j ${operation.frequencyHours}h';
  }

  String _counterModeLabel(MaintenanceOperation operation) {
    if (operation.countdownMode == MaintenanceOperation.modeProcessing) {
      return 'processing';
    }
    return 'machine allumee';
  }

  bool _isProcessingStatus() {
    final String status =
        global.machineObjectModel.result?.state?.status?.toLowerCase() ?? '';
    return status == 'processing';
  }

  double _requiredSeconds(MaintenanceOperation operation) {
    return operation.frequencyDuration.inSeconds.toDouble();
  }

  double _remainingSeconds(MaintenanceOperation operation) {
    final double remaining =
        _requiredSeconds(operation) - operation.countedSeconds;
    if (remaining < 0) {
      return 0;
    }
    return remaining;
  }

  String _formatDurationSeconds(double seconds) {
    final int totalSeconds = seconds.round();
    final int days = totalSeconds ~/ 86400;
    final int hours = (totalSeconds % 86400) ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int remainingSeconds = totalSeconds % 60;
    return '${days}j ${hours}h ${minutes}m ${remainingSeconds}s';
  }

  String _nextOperationDateText(MaintenanceOperation operation) {
    final double remainingSeconds = _remainingSeconds(operation);
    if (remainingSeconds <= 0) {
      return 'A faire maintenant';
    }

    if (operation.countdownMode == MaintenanceOperation.modeMachineOn) {
      final DateTime due = DateTime.now().add(
        Duration(seconds: remainingSeconds.round()),
      );
      return _formatDate(due.toIso8601String());
    }

    if (_isProcessingStatus()) {
      final DateTime estimate = DateTime.now().add(
        Duration(seconds: remainingSeconds.round()),
      );
      return '${_formatDate(estimate.toIso8601String())} (estimation)';
    }
    return 'En attente de temps processing';
  }

  bool _isOverdue(MaintenanceOperation operation) {
    return _remainingSeconds(operation) <= 0;
  }

  Future<void> _reloadFromMachine() async {
    if (_isBusy) return;
    setState(() {
      _isBusy = true;
      _status = 'Chargement depuis /sys/${MaintenanceConfig.fileName}...';
    });

    try {
      final String content =
          await API_Manager().downLoadAFile('sys', MaintenanceConfig.fileName);

      if (content.toLowerCase() == 'nok') {
        setState(() {
          final MaintenanceConfig fallback = MaintenanceConfig.defaults();
          _sections = fallback.sections;
          _operations = fallback.operations;
          _ensureFilterIsValid();
          _status =
              'Fichier non trouve sur la machine, liste par defaut chargee localement.';
        });
        return;
      }

      final MaintenanceConfig parsed = maintenanceConfigFromJson(content);
      setState(() {
        if (parsed.sections.isEmpty) {
          final MaintenanceConfig fallback = MaintenanceConfig.defaults();
          _sections = fallback.sections;
        } else {
          _sections = parsed.sections.map((section) => section.copy()).toList();
        }
        _operations = parsed.operations.map((op) => op.copy()).toList();
        _ensureFilterIsValid();
        _status = 'Liste maintenance rechargee depuis la machine.';
      });
    } catch (_) {
      setState(() {
        _status = 'Erreur pendant le chargement des operations de maintenance.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _saveToMachine() async {
    if (_isBusy) return;
    final MaintenanceConfig rawConfig = MaintenanceConfig(
      sections: _sections.map((section) => section.copy()).toList(),
      operations: _operations.map((op) => op.copy()).toList(),
      lastModification: DateTime.now().toIso8601String(),
    );
    final MaintenanceConfig nextConfig = _sanitizeConfigForStorage(rawConfig);

    final String jsonContent = maintenanceConfigToJson(nextConfig);

    setState(() {
      _isBusy = true;
      _status = 'Enregistrement dans /sys/${MaintenanceConfig.fileName}...';
    });

    try {
      final String result = await API_Manager().upLoadAFile(
        '0:/sys/${MaintenanceConfig.fileName}',
        jsonContent.length.toString(),
        Uint8List.fromList(utf8.encode(jsonContent)),
      );

      if (result == 'ok') {
        global.maintenanceConfig = nextConfig;
        await ActionLogger.log(
          category: 'maintenance',
          action: 'save_maintenance_config',
          target: MaintenanceConfig.fileName,
          details: 'Configuration maintenance enregistree',
          result: 'ok',
        );
        setState(() {
          _sections =
              nextConfig.sections.map((section) => section.copy()).toList();
          _operations = nextConfig.operations
              .map((operation) => operation.copy())
              .toList();
          _ensureFilterIsValid();
          _status = 'Maintenance sauvegardee sur la machine.';
        });
      } else {
        setState(() {
          _status = 'Echec de sauvegarde maintenance.';
        });
      }
    } catch (_) {
      setState(() {
        _status = 'Erreur pendant la sauvegarde maintenance.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _markDoneNow(int index) {
    final DateTime now = DateTime.now();
    final String operationName = _operations[index].name;
    setState(() {
      _operations[index].lastDoneAt = now.toIso8601String();
      _setOperationLastDoneByCurrentUser(_operations[index]);
      _operations[index].countedSeconds = 0;
      _status =
          'Operation "${_operations[index].name}" mise a jour a ${_formatDate(_operations[index].lastDoneAt)}.';
    });
    unawaited(
      ActionLogger.log(
        category: 'maintenance',
        action: 'mark_operation_done',
        target: operationName,
        details: 'Operation marquee comme effectuee',
        result: 'ok',
      ),
    );
  }

  Future<void> _pickDoneDate(int index) async {
    final DateTime base = _operations[index].lastDoneDateTime ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;
    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );

    if (pickedTime == null) return;
    if (!mounted) return;

    final DateTime finalDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _operations[index].lastDoneAt = finalDate.toIso8601String();
      _setOperationLastDoneByCurrentUser(_operations[index]);
      if (_operations[index].countdownMode ==
          MaintenanceOperation.modeMachineOn) {
        final Duration elapsed = DateTime.now().difference(finalDate);
        _operations[index].countedSeconds =
            elapsed.isNegative ? 0 : elapsed.inSeconds.toDouble();
      } else {
        _operations[index].countedSeconds = 0;
      }
      _status =
          'Date operation "${_operations[index].name}" mise a jour a ${_formatDate(_operations[index].lastDoneAt)}.';
    });
    unawaited(
      ActionLogger.log(
        category: 'maintenance',
        action: 'set_operation_done_datetime',
        target: _operations[index].name,
        details: 'Date/heure operation definie manuellement',
        result: 'ok',
      ),
    );
  }

  String _sanitizeSectionId(String value) {
    final String normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    if (normalized.isEmpty) {
      return 'section-${DateTime.now().millisecondsSinceEpoch}';
    }
    return normalized;
  }

  String _uniqueSectionId(
    String preferredName,
    List<MaintenanceSection> existingSections,
  ) {
    final String base = _sanitizeSectionId(preferredName);
    String candidate = base;
    int suffix = 1;
    final Set<String> existingIds = existingSections.map((s) => s.id).toSet();
    while (existingIds.contains(candidate)) {
      candidate = '$base-$suffix';
      suffix++;
    }
    return candidate;
  }

  Future<void> _manageSections() async {
    if (!global.AdminLogged) {
      setState(() {
        _status = 'Mode admin requis pour gerer les sections.';
      });
      return;
    }

    final TextEditingController nameController = TextEditingController();
    final List<MaintenanceSection> tempSections =
        _sections.map((section) => section.copy()).toList();
    bool shouldApply = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Gestion des sections'),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tempSections.length,
                        itemBuilder: (BuildContext context, int index) {
                          final MaintenanceSection section =
                              tempSections[index];
                          final bool isMachine = _isMachineSection(section.id);
                          return ListTile(
                            dense: true,
                            title: Text(section.name),
                            subtitle: Text('id: ${section.id}'),
                            trailing: isMachine
                                ? const Tooltip(
                                    message:
                                        'Section par defaut, non supprimable',
                                    child: Icon(Icons.lock_outline, size: 18),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Supprimer section',
                                    onPressed: () {
                                      setDialogState(() {
                                        tempSections.removeAt(index);
                                      });
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nom nouvelle section',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final String name = nameController.text.trim();
                            if (name.isEmpty) {
                              return;
                            }
                            final bool existsByName = tempSections.any(
                              (section) =>
                                  section.name.toLowerCase() ==
                                  name.toLowerCase(),
                            );
                            if (existsByName) {
                              return;
                            }
                            setDialogState(() {
                              tempSections.add(
                                MaintenanceSection(
                                  id: _uniqueSectionId(name, tempSections),
                                  name: name,
                                ),
                              );
                              nameController.clear();
                            });
                          },
                          child: const Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    shouldApply = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Appliquer'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!shouldApply) {
      return;
    }

    setState(() {
      _sections = tempSections;
      if (!_sections.any((s) => s.id == MaintenanceConfig.machineSectionId)) {
        _sections.insert(
          0,
          MaintenanceSection(
            id: MaintenanceConfig.machineSectionId,
            name: MaintenanceConfig.machineSectionName,
          ),
        );
      }
      final Set<String> validIds = _sections.map((s) => s.id).toSet();
      for (final MaintenanceOperation operation in _operations) {
        if (!validIds.contains(operation.sectionId)) {
          operation.sectionId = MaintenanceConfig.machineSectionId;
        }
      }
      _ensureFilterIsValid();
      _status = 'Sections mises a jour. Pensez a enregistrer.';
    });
  }

  Future<void> _editOperationSection(int index) async {
    if (!global.AdminLogged) {
      setState(() {
        _status = 'Mode admin requis pour changer la section.';
      });
      return;
    }
    if (_sections.isEmpty) {
      setState(() {
        _status = 'Aucune section disponible.';
      });
      return;
    }

    final MaintenanceOperation operation = _operations[index];
    String selectedSectionId = operation.sectionId;
    bool shouldApply = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('Section - ${operation.name}'),
              content: DropdownButtonFormField<String>(
                initialValue: _sections.any((s) => s.id == selectedSectionId)
                    ? selectedSectionId
                    : MaintenanceConfig.machineSectionId,
                items: _sections
                    .map(
                      (section) => DropdownMenuItem<String>(
                        value: section.id,
                        child: Text(section.name),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  if (value == null) return;
                  setDialogState(() {
                    selectedSectionId = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Section',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    shouldApply = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Appliquer'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!shouldApply) {
      return;
    }

    setState(() {
      operation.sectionId = selectedSectionId;
      _status =
          'Section de "${operation.name}" mise a jour: ${_sectionNameFor(selectedSectionId)}.';
    });
  }

  Future<void> _addOperation() async {
    if (!global.AdminLogged) {
      setState(() {
        _status = 'Mode admin requis pour ajouter une operation.';
      });
      return;
    }
    if (_sections.isEmpty) {
      _sections.add(
        MaintenanceSection(
          id: MaintenanceConfig.machineSectionId,
          name: MaintenanceConfig.machineSectionName,
        ),
      );
    }

    final TextEditingController nameController = TextEditingController();
    final TextEditingController detailController = TextEditingController();
    final TextEditingController daysController =
        TextEditingController(text: '30');
    final TextEditingController hoursController =
        TextEditingController(text: '0');
    String selectedSectionId = _sections.any(
      (section) => section.id == MaintenanceConfig.machineSectionId,
    )
        ? MaintenanceConfig.machineSectionId
        : (_sections.isNotEmpty
            ? _sections.first.id
            : MaintenanceConfig.machineSectionId);
    String selectedCounterMode = MaintenanceOperation.modeMachineOn;
    bool shouldAdd = false;
    int frequencyDays = 30;
    int frequencyHours = 0;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Nouvelle operation'),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: detailController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Detail operation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue:
                          _sections.any((s) => s.id == selectedSectionId)
                              ? selectedSectionId
                              : MaintenanceConfig.machineSectionId,
                      decoration: const InputDecoration(
                        labelText: 'Section',
                        border: OutlineInputBorder(),
                      ),
                      items: _sections
                          .map(
                            (section) => DropdownMenuItem<String>(
                              value: section.id,
                              child: Text(section.name),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        if (value == null) return;
                        setDialogState(() {
                          selectedSectionId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCounterMode,
                      decoration: const InputDecoration(
                        labelText: 'Type de decompte',
                        border: OutlineInputBorder(),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: MaintenanceOperation.modeMachineOn,
                          child: Text('Machine allumee'),
                        ),
                        DropdownMenuItem<String>(
                          value: MaintenanceOperation.modeProcessing,
                          child: Text('Uniquement processing'),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == null) return;
                        setDialogState(() {
                          selectedCounterMode = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: daysController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Frequence (jours)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: hoursController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Frequence (heures)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final int? parsedDays =
                        int.tryParse(daysController.text.trim());
                    final int? parsedHours =
                        int.tryParse(hoursController.text.trim());
                    if (nameController.text.trim().isEmpty ||
                        detailController.text.trim().isEmpty ||
                        parsedDays == null ||
                        parsedHours == null ||
                        parsedDays < 0 ||
                        parsedHours < 0) {
                      return;
                    }
                    frequencyDays = parsedDays;
                    frequencyHours = parsedHours;
                    shouldAdd = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!shouldAdd) return;

    setState(() {
      _operations.add(
        MaintenanceOperation(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: nameController.text.trim(),
          description: detailController.text.trim(),
          sectionId: selectedSectionId,
          countdownMode: selectedCounterMode,
          countedSeconds: 0,
          frequencyDays: frequencyDays,
          frequencyHours: frequencyHours,
        ),
      );
      _status = 'Operation ajoutee. Pensez a enregistrer.';
    });
  }

  Future<void> _editFrequency(int index) async {
    if (!global.AdminLogged) {
      setState(() {
        _status = 'Mode admin requis pour modifier la frequence.';
      });
      return;
    }

    final MaintenanceOperation operation = _operations[index];
    final TextEditingController daysController =
        TextEditingController(text: operation.frequencyDays.toString());
    final TextEditingController hoursController =
        TextEditingController(text: operation.frequencyHours.toString());
    bool shouldApply = false;
    int frequencyDays = operation.frequencyDays;
    int frequencyHours = operation.frequencyHours;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Frequence - ${operation.name}'),
          content: SizedBox(
            width: 360,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jours',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Heures',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final int? parsedDays =
                    int.tryParse(daysController.text.trim());
                final int? parsedHours =
                    int.tryParse(hoursController.text.trim());
                if (parsedDays == null ||
                    parsedHours == null ||
                    parsedDays < 0 ||
                    parsedHours < 0) {
                  return;
                }
                frequencyDays = parsedDays;
                frequencyHours = parsedHours;
                shouldApply = true;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Appliquer'),
            ),
          ],
        );
      },
    );

    if (!shouldApply) return;

    setState(() {
      operation.frequencyDays = frequencyDays;
      operation.frequencyHours = frequencyHours;
      operation.normalizeFrequency();
      _status =
          'Frequence de "${operation.name}" mise a jour: ${_formatFrequency(operation)}.';
    });
  }

  Future<void> _editCounterMode(int index) async {
    if (!global.AdminLogged) {
      setState(() {
        _status = 'Mode admin requis pour modifier le type de decompte.';
      });
      return;
    }

    final MaintenanceOperation operation = _operations[index];
    String selectedMode = operation.countdownMode;
    bool shouldApply = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('Type de decompte - ${operation.name}'),
              content: DropdownButtonFormField<String>(
                initialValue: selectedMode,
                decoration: const InputDecoration(
                  labelText: 'Mode',
                  border: OutlineInputBorder(),
                ),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: MaintenanceOperation.modeMachineOn,
                    child: Text('Machine allumee'),
                  ),
                  DropdownMenuItem<String>(
                    value: MaintenanceOperation.modeProcessing,
                    child: Text('Uniquement processing'),
                  ),
                ],
                onChanged: (String? value) {
                  if (value == null) return;
                  setDialogState(() {
                    selectedMode = value;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    shouldApply = true;
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Appliquer'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!shouldApply) return;

    setState(() {
      operation.countdownMode = selectedMode;
      operation.countedSeconds = 0;
      operation.lastDoneAt = DateTime.now().toIso8601String();
      _setOperationLastDoneByCurrentUser(operation);
      _status =
          'Type de decompte de "${operation.name}" mis a jour: ${_counterModeLabel(operation)}.';
    });
  }

  Future<void> _deleteOperation(int index) async {
    if (!global.AdminLogged) {
      setState(() {
        _status = 'Mode admin requis pour supprimer une operation.';
      });
      return;
    }

    final String name = _operations[index].name;
    bool confirm = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer operation'),
          content: Text('Supprimer "$name" ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                confirm = true;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (!confirm) return;

    setState(() {
      _operations.removeAt(index);
      _status = 'Operation "$name" supprimee. Pensez a enregistrer.';
    });
  }

  Widget _buildOperationTile(MaintenanceOperation operation, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(
          operation.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Section: ${_sectionNameFor(operation.sectionId)}'),
            Text('Mode decompte: ${_counterModeLabel(operation)}'),
            Text('Frequence: ${_formatFrequency(operation)}'),
            Text('Derniere execution: ${_formatDate(operation.lastDoneAt)}'),
            Text('Dernier intervenant: ${_formatLastDoneBy(operation)}'),
            Text(
                'Temps restant: ${_formatDurationSeconds(_remainingSeconds(operation))}'),
            Text(
              'Prochaine intervention: ${_nextOperationDateText(operation)}',
              style: TextStyle(
                color: _isOverdue(operation)
                    ? const Color(0xFFC62828)
                    : const Color(0xFF1F8A76),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              tooltip: 'Mettre date/heure',
              icon: const Icon(Icons.event_available_rounded),
              onPressed: _isBusy ? null : () => _pickDoneDate(index),
            ),
            if (global.AdminLogged)
              IconButton(
                tooltip: 'Supprimer operation',
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: _isBusy ? null : () => _deleteOperation(index),
              ),
          ],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(operation.description),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _isBusy ? null : () => _markDoneNow(index),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Marquer effectuee maintenant'),
                ),
                OutlinedButton.icon(
                  onPressed: _isBusy ? null : () => _pickDoneDate(index),
                  icon: const Icon(Icons.schedule_rounded),
                  label: const Text('Choisir date/heure'),
                ),
                if (global.AdminLogged)
                  OutlinedButton.icon(
                    onPressed: _isBusy ? null : () => _editFrequency(index),
                    icon: const Icon(Icons.timer_outlined),
                    label: const Text('Modifier frequence'),
                  ),
                if (global.AdminLogged)
                  OutlinedButton.icon(
                    onPressed: _isBusy ? null : () => _editCounterMode(index),
                    icon: const Icon(Icons.hourglass_bottom_rounded),
                    label: const Text('Modifier decompte'),
                  ),
                if (global.AdminLogged)
                  OutlinedButton.icon(
                    onPressed:
                        _isBusy ? null : () => _editOperationSection(index),
                    icon: const Icon(Icons.category_outlined),
                    label: const Text('Changer section'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(MaintenanceSection section, int count) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE6EDF5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCAD6E3)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.folder_open_rounded,
              size: 18, color: Color(0xFF5C6675)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              section.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A5160),
              ),
            ),
          ),
          Text(
            '$count operation(s)',
            style: const TextStyle(
              color: Color(0xFF4A5160),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionedOperationsList(
      List<MaintenanceOperation> filteredOperations) {
    final List<Widget> children = <Widget>[];

    for (final MaintenanceSection section in _sections) {
      final List<MaintenanceOperation> sectionOperations = filteredOperations
          .where((operation) => operation.sectionId == section.id)
          .toList();

      if (sectionOperations.isEmpty) {
        continue;
      }

      children.add(_buildSectionHeader(section, sectionOperations.length));

      for (final MaintenanceOperation operation in sectionOperations) {
        final int sourceIndex = _operations.indexOf(operation);
        if (sourceIndex < 0) {
          continue;
        }
        children.add(_buildOperationTile(operation, sourceIndex));
      }
    }

    if (children.isEmpty) {
      return const Center(child: Text('Aucune operation de maintenance.'));
    }

    return ListView(children: children);
  }

  @override
  Widget build(BuildContext context) {
    final List<MaintenanceOperation> filteredOperations = _filteredOperations();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F3),
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: const Color(0xFFF0F0F3),
        actions: const <Widget>[
          AccountToolbarButton(),
        ],
        title: Row(
          children: <Widget>[
            const SizedBox(
              width: 70,
              child: Image(image: AssetImage('assets/iconnaxe.png')),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Maintenance machine',
                style: TextStyle(color: Color(0xFF707585)),
              ),
            ),
            Text(
              global.AdminLogged ? 'Mode Admin' : 'Mode User',
              style: const TextStyle(color: Color(0xFF707585), fontSize: 14),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Window(
                  title1: 'Operations',
                  title2: ' de maintenance',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: _isBusy ? null : _saveToMachine,
                            icon: const Icon(Icons.save_rounded),
                            label: const Text('Enregistrer dans /sys'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _isBusy ? null : _reloadFromMachine,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Recharger'),
                          ),
                          if (global.AdminLogged)
                            OutlinedButton.icon(
                              onPressed: _isBusy ? null : _addOperation,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Ajouter operation'),
                            ),
                          if (global.AdminLogged)
                            OutlinedButton.icon(
                              onPressed: _isBusy ? null : _manageSections,
                              icon: const Icon(Icons.view_list_outlined),
                              label: const Text('Gerer sections'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          const Text(
                            'Filtre section:',
                            style: TextStyle(
                              color: Color(0xFF707585),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: _sectionFilterId,
                            onChanged: _isBusy
                                ? null
                                : (String? value) {
                                    if (value == null) return;
                                    setState(() {
                                      _sectionFilterId = value;
                                      _ensureFilterIsValid();
                                    });
                                  },
                            items: <DropdownMenuItem<String>>[
                              const DropdownMenuItem<String>(
                                value: _allSectionsFilterId,
                                child: Text('Toutes'),
                              ),
                              ..._sections.map(
                                (section) => DropdownMenuItem<String>(
                                  value: section.id,
                                  child: Text(section.name),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        global.AdminLogged
                            ? 'Ajout/Suppression active (admin).'
                            : 'Ajout/Suppression reserve a l\'admin.',
                        style: const TextStyle(
                          color: Color(0xFF707585),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _status,
                        style: const TextStyle(
                          color: Color(0xFF4A5160),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filteredOperations.isEmpty
                            ? const Center(
                                child: Text('Aucune operation de maintenance.'),
                              )
                            : _buildSectionedOperationsList(filteredOperations),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
