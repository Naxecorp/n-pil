import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nweb/globals_var.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/logging/action_log_config.dart';
import 'package:nweb/service/logging/action_logger.dart';
import 'package:nweb/service/nwc-settings/nwc-settings.dart';
import 'package:nweb/service/security/user_accounts_config.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:nweb/service/outils.dart';
import '../globals_var.dart' as global;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../menus/side_menu.dart';
import '../main.dart';
import '../widgetUtils/account_toolbar_button.dart';
import 'package:nweb/service/system/SystemsFilesElement.dart';

TextEditingController ManualGcodeComand = TextEditingController();

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen>
    with TickerProviderStateMixin {
  late AnimationController ProgressBarcontroller;
  bool _showAccountsTab = false;
  bool _showHistoryTab = false;
  bool isLoading = false;
  List<UserAccount> _accounts = <UserAccount>[];
  bool _accountsBusy = false;
  String _accountsStatus = "";
  bool _historyBusy = false;
  String _historyStatus = "";
  String _historyCategoryFilter = "all";
  final TextEditingController _historySearchController =
      TextEditingController();

  void downloadFile(String urlBase, String FileName) {
    // html.AnchorElement anchorElement =
    // html.AnchorElement(href: urlBase + FileName);
    // anchorElement.download = 'test.gcode';
    // anchorElement.click();
  }
  Future<String> SaveFileContent(String Content) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'program.g',
    );

    if (outputFile == null) {
      // User canceled the picker
      return "canceled";
    }

    final file = File(outputFile);
    var sink = file.openWrite();
    sink.write(Content);
    // _companies.forEach((_company) {
    //   sink.write('${_company.name};${_company.contactMail}\n');
    // });
    sink.close();
    return "Done";
  }

  void AdminModeLogger() {
    TextEditingController MDP = new TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Mot de passe"),
            content: Stack(
              //overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          controller: MDP,
                          onFieldSubmitted: (value) async {
                            if (MDP.text == global.pwd) {
                              global.AdminLogged = true;
                              global.Title = "ADMIN MODE | $version";
                              await API_Manager().sendGcodeCommand(
                                  "M581 T1 P-1"); // on desactive toutes les pauses
                              await API_Manager().sendGcodeCommand(
                                  'M98 P"alarmdriver.g"'); //Mais on garde celle des erreurs Driver
                              Navigator.pop(context, '/admin');
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Dashboard"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.black),
                          onPressed: () {
                            Navigator.pushNamed(context, '/dashboard');
                            pageToShow = 1;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    pageToShow = 7;
    _accounts = global.userAccountsConfig.copy().accounts;
    API_Manager()
        .getfileListSys()
        .then((value) => global.ListofSysFile = value);
    if (!global.AdminLogged) {
      Future.delayed(Duration(milliseconds: 500), () {
        AdminModeLogger();
      });
    }
    global.checkAndShowDialog(context);
    Future.delayed(const Duration(seconds: 2), () {
      if (global.MyMachineN02Config.HasFanOnEnclosure == 1)
        global.checkCaissonOpen(context);
    });
    ProgressBarcontroller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    ProgressBarcontroller.repeat(reverse: false);
    super.initState();
  }

  @override
  void dispose() {
    ProgressBarcontroller.dispose();
    _historySearchController.dispose();
    super.dispose();
  }

  var selectedFileIndex = 0;

  void _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result == null) {
      isLoading = false;
      return;
    }
    //Uint8List? fileBytes = result.files.first.bytes;
    setState(() {
      isLoading = true;
    });
    API_Manager()
        .upLoadAFile(
            "0:/sys/" + result.files.first.name.toString(),
            result.files.first.bytes!.length.toString(),
            result.files.first.bytes!)
        .then((uploadResult) {
      if (uploadResult == 'ok') {
        unawaited(
          ActionLogger.log(
            category: 'sys_files',
            action: 'upload_sys_file',
            target: result.files.first.name.toString(),
            details: 'Fichier charge depuis le PC vers /sys',
            result: 'ok',
          ),
        );
      }
      API_Manager()
          .getfileListSys()
          .then((value) => global.ListofSysFile = value);
      setState(() {
        isLoading = false;
      });
    });
  }

  bool containsSpecialCharacters(String text) {
    final RegExp specialCharacters = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(text);
  }

  List<UserAccount> _cloneAccounts(List<UserAccount> accounts) {
    return accounts.map((UserAccount account) => account.copy()).toList();
  }

  String _buildUniqueAccountId(String displayName) {
    final Set<String> usedIds = _accounts.map((UserAccount e) => e.id).toSet();
    final String normalized = displayName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final String seed = normalized.isEmpty ? 'user' : normalized;
    String candidate = seed;
    int suffix = 1;
    while (candidate == UserAccountsConfig.adminId ||
        usedIds.contains(candidate)) {
      candidate = '$seed-$suffix';
      suffix++;
    }
    return candidate;
  }

  Future<void> _uploadAccountsConfig(UserAccountsConfig config) async {
    final String jsonContent = userAccountsConfigToJson(config);
    final List<int> bytes = utf8.encode(jsonContent);
    await API_Manager().upLoadAFile(
      "0:/sys/${UserAccountsConfig.fileName}",
      bytes.length.toString(),
      Uint8List.fromList(bytes),
    );
  }

  Future<void> _reloadAccountsFromMachine() async {
    if (_accountsBusy) {
      return;
    }
    setState(() {
      _accountsBusy = true;
      _accountsStatus = "Chargement des comptes en cours...";
    });
    try {
      final String content =
          await API_Manager().downLoadAFile("sys", UserAccountsConfig.fileName);

      UserAccountsConfig config;
      String status = "Comptes recharges depuis la machine.";
      if (content.toLowerCase() == "nok") {
        config = UserAccountsConfig.defaults();
        await _uploadAccountsConfig(config);
        status = "Fichier absent. Un fichier par defaut a ete cree.";
      } else {
        try {
          final String sanitizedContent = content.replaceFirst('\uFEFF', '');
          config = userAccountsConfigFromJson(sanitizedContent);
        } catch (_) {
          config = UserAccountsConfig.defaults();
          await _uploadAccountsConfig(config);
          status =
              "Fichier JSON invalide. Le fichier par defaut a ete regenere.";
        }
      }

      config.ensureConsistency();
      global.userAccountsConfig = config;
      global.pwd = config.adminAccount?.pin ?? global.pwd;

      if (!mounted) {
        return;
      }
      setState(() {
        _accounts = _cloneAccounts(config.accounts);
        _accountsStatus = status;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _accountsStatus = "Erreur pendant le chargement des comptes: $error";
      });
    } finally {
      if (mounted) {
        setState(() {
          _accountsBusy = false;
        });
      }
    }
  }

  Future<void> _saveAccountsToMachine() async {
    if (_accountsBusy) {
      return;
    }
    setState(() {
      _accountsBusy = true;
      _accountsStatus = "Enregistrement des comptes...";
    });

    try {
      final UserAccountsConfig config = UserAccountsConfig(
        accounts: _cloneAccounts(_accounts),
        lastModification: DateTime.now().toIso8601String(),
      );
      config.ensureConsistency();

      await _uploadAccountsConfig(config);

      global.userAccountsConfig = config;
      global.pwd = config.adminAccount?.pin ?? global.pwd;
      await ActionLogger.log(
        category: 'accounts',
        action: 'save_accounts_config',
        target: UserAccountsConfig.fileName,
        details: 'Configuration des comptes enregistree',
        result: 'ok',
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _accounts = _cloneAccounts(config.accounts);
        _accountsStatus =
            "Comptes enregistres dans /sys/${UserAccountsConfig.fileName}.";
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _accountsStatus = "Erreur pendant la sauvegarde: $error";
      });
    } finally {
      if (mounted) {
        setState(() {
          _accountsBusy = false;
        });
      }
    }
  }

  Future<void> _openAccountDialog({UserAccount? account}) async {
    if (!global.AdminLogged) {
      setState(() {
        _accountsStatus = "Seul l'admin peut modifier les comptes.";
      });
      return;
    }

    final UserAccount? existingAccount = account;
    final bool isEdition = existingAccount != null;
    final bool isAdminAccount =
        existingAccount?.id == UserAccountsConfig.adminId;
    final TextEditingController nameController = TextEditingController(
      text: existingAccount?.displayName ?? "",
    );
    final TextEditingController pinController = TextEditingController(
      text: existingAccount != null
          ? UserAccount.sanitizePin(existingAccount.pin)
          : "",
    );
    String errorMessage = "";

    final UserAccount? result = await showDialog<UserAccount>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) setDialogState) {
            return AlertDialog(
              title: Text(isEdition ? "Modifier un compte" : "Nouveau compte"),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      enabled: !isAdminAccount,
                      decoration: const InputDecoration(
                        labelText: "Nom d'affichage",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      maxLength: UserAccount.pinLength,
                      decoration: const InputDecoration(
                        labelText: "Code PIN (4 chiffres)",
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                    ),
                    if (errorMessage.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          isAdminAccount
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color: const Color(0xFF2B879B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isAdminAccount
                              ? "Compte permanent admin"
                              : "Compte utilisateur",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String rawPin =
                        pinController.text.replaceAll(RegExp(r'[^0-9]'), '');
                    if (rawPin.length != UserAccount.pinLength) {
                      setDialogState(() {
                        errorMessage =
                            "Le code PIN doit contenir exactement 4 chiffres.";
                      });
                      return;
                    }

                    final String displayName = isAdminAccount
                        ? "admin"
                        : (nameController.text.trim().isEmpty
                            ? "Utilisateur"
                            : nameController.text.trim());
                    final String id = existingAccount?.id ??
                        _buildUniqueAccountId(displayName);
                    final UserAccount updated = UserAccount(
                      id: id,
                      displayName: displayName,
                      pin: UserAccount.sanitizePin(rawPin),
                      isAdmin: isAdminAccount,
                      isPermanent: isAdminAccount,
                      lastMachineUseAt: existingAccount?.lastMachineUseAt,
                    );

                    Navigator.pop(dialogContext, updated);
                  },
                  child: const Text("Valider"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (isEdition) {
        final int index = _accounts.indexWhere(
          (UserAccount e) => e.id == existingAccount.id,
        );
        if (index >= 0) {
          _accounts[index] = result;
        }
      } else {
        _accounts.add(result);
      }
      _accountsStatus = "Modification locale faite. Cliquez sur Enregistrer.";
    });
  }

  Future<void> _deleteAccount(UserAccount account) async {
    if (!global.AdminLogged) {
      setState(() {
        _accountsStatus = "Seul l'admin peut supprimer un compte.";
      });
      return;
    }
    if (account.id == UserAccountsConfig.adminId || account.isPermanent) {
      setState(() {
        _accountsStatus =
            "Le compte admin est permanent et ne peut pas etre supprime.";
      });
      return;
    }

    final bool shouldDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Supprimer le compte"),
              content: Text(
                "Supprimer le compte ${account.displayName} ?",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B2B2B),
                  ),
                  child: const Text(
                    "Supprimer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() {
      _accounts.removeWhere((UserAccount e) => e.id == account.id);
      _accountsStatus = "Compte supprime localement. Cliquez sur Enregistrer.";
    });
  }

  Widget _buildAdminTabButton({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selected ? const Color(0xFF2B879B) : const Color(0xFFD9E5EE),
          foregroundColor: selected ? Colors.white : const Color(0xFF2D3440),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildAccountsTab() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _accountsBusy ? null : _reloadAccountsFromMachine,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text("Recharger"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B879B),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: (_accountsBusy || !global.AdminLogged)
                      ? null
                      : () => _openAccountDialog(),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text("Ajouter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B879B),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: (_accountsBusy || !global.AdminLogged)
                      ? null
                      : _saveAccountsToMachine,
                  icon: const Icon(Icons.save_alt_rounded),
                  label: const Text("Enregistrer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B879B),
                    foregroundColor: Colors.white,
                  ),
                ),
                if (_accountsBusy)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          if (_accountsStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _accountsStatus,
                  style: TextStyle(
                    color: _accountsStatus.contains("Erreur")
                        ? const Color(0xFFC62828)
                        : const Color(0xFF2D3440),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (BuildContext context, int index) {
                final UserAccount account = _accounts[index];
                final bool isAdminAccount =
                    account.id == UserAccountsConfig.adminId || account.isAdmin;
                final bool canDelete = global.AdminLogged &&
                    !isAdminAccount &&
                    !account.isPermanent;
                final bool canEdit = global.AdminLogged;

                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      isAdminAccount
                          ? Icons.admin_panel_settings
                          : Icons.person_outline,
                      color: isAdminAccount
                          ? const Color(0xFF2B879B)
                          : const Color(0xFF4F5D70),
                    ),
                    title: Text(
                      account.displayName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "id: ${account.id} | PIN: ${'•' * UserAccount.pinLength}"
                      "${isAdminAccount ? " | permanent" : ""}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          tooltip: "Modifier",
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: canEdit
                              ? () => _openAccountDialog(account: account)
                              : null,
                        ),
                        IconButton(
                          tooltip: "Supprimer",
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed:
                              canDelete ? () => _deleteAccount(account) : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatLogDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return "Date inconnue";
    }
    final DateTime? parsed = DateTime.tryParse(isoDate);
    if (parsed == null) {
      return "Date invalide";
    }
    final String d = parsed.day.toString().padLeft(2, '0');
    final String m = parsed.month.toString().padLeft(2, '0');
    final String y = parsed.year.toString();
    final String hh = parsed.hour.toString().padLeft(2, '0');
    final String mm = parsed.minute.toString().padLeft(2, '0');
    final String ss = parsed.second.toString().padLeft(2, '0');
    return "$d/$m/$y $hh:$mm:$ss";
  }

  String _prettyToken(String raw) {
    return raw
        .replaceAll("_", " ")
        .split(" ")
        .where((String part) => part.trim().isNotEmpty)
        .map((String part) {
      if (part.length <= 1) {
        return part.toUpperCase();
      }
      return part[0].toUpperCase() + part.substring(1).toLowerCase();
    }).join(" ");
  }

  IconData _historyIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case "auth":
        return Icons.login_rounded;
      case "programme":
      case "programme_files":
        return Icons.play_circle_outline_rounded;
      case "maintenance":
        return Icons.build_circle_outlined;
      case "settings":
        return Icons.settings_suggest_outlined;
      case "sys_files":
        return Icons.folder_open_rounded;
      case "accounts":
        return Icons.manage_accounts_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  Future<void> _reloadActionHistoryFromMachine() async {
    if (_historyBusy) {
      return;
    }
    setState(() {
      _historyBusy = true;
      _historyStatus = "Chargement historique en cours...";
    });
    try {
      final String content =
          await API_Manager().downLoadAFile("sys", ActionLogConfig.fileName);

      if (content.toLowerCase() == "nok") {
        final ActionLogConfig fallback = ActionLogConfig.defaults();
        final String jsonContent = actionLogConfigToJson(fallback);
        await API_Manager().upLoadAFile(
          "0:/sys/${ActionLogConfig.fileName}",
          utf8.encode(jsonContent).length.toString(),
          Uint8List.fromList(utf8.encode(jsonContent)),
        );
        global.actionLogConfig = fallback;
        if (!mounted) {
          return;
        }
        setState(() {
          _historyStatus =
              "Fichier absent. Un historique vide a ete cree dans /sys.";
        });
        return;
      }

      final String sanitized = content.replaceFirst('\uFEFF', '');
      final ActionLogConfig parsed = actionLogConfigFromJson(sanitized);
      parsed.ensureConsistency();
      global.actionLogConfig = parsed;

      if (!mounted) {
        return;
      }
      setState(() {
        _historyStatus =
            "Historique recharge (${global.actionLogConfig.entries.length} lignes).";
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _historyStatus = "Erreur de chargement historique: $error";
      });
    } finally {
      if (mounted) {
        setState(() {
          _historyBusy = false;
        });
      }
    }
  }

  Future<void> _clearActionHistory() async {
    if (_historyBusy) {
      return;
    }
    if (!global.AdminLogged) {
      setState(() {
        _historyStatus = "Mode admin requis pour effacer l'historique.";
      });
      return;
    }

    final bool confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Effacer l'historique"),
              content: const Text(
                "Cette action supprime toutes les entrees du journal. Continuer ?",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B2B2B),
                  ),
                  child: const Text(
                    "Effacer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirm) {
      return;
    }

    setState(() {
      _historyBusy = true;
      _historyStatus = "Effacement en cours...";
    });

    try {
      final ActionLogConfig emptyConfig = ActionLogConfig.defaults();
      final String jsonContent = actionLogConfigToJson(emptyConfig);
      final String result = await API_Manager().upLoadAFile(
        "0:/sys/${ActionLogConfig.fileName}",
        utf8.encode(jsonContent).length.toString(),
        Uint8List.fromList(utf8.encode(jsonContent)),
      );

      if (!mounted) {
        return;
      }
      setState(() {
        if (result == "ok") {
          global.actionLogConfig = emptyConfig;
          _historyCategoryFilter = "all";
          _historySearchController.clear();
          _historyStatus = "Historique efface.";
        } else {
          _historyStatus = "Echec pendant l'effacement de l'historique.";
        }
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _historyStatus = "Erreur d'effacement historique: $error";
      });
    } finally {
      if (mounted) {
        setState(() {
          _historyBusy = false;
        });
      }
    }
  }

  List<String> _historyCategories() {
    final Set<String> categories = <String>{"all"};
    for (final ActionLogEntry entry in global.actionLogConfig.entries) {
      if (entry.category.trim().isNotEmpty) {
        categories.add(entry.category.trim().toLowerCase());
      }
    }
    return categories.toList()..sort();
  }

  List<ActionLogEntry> _filteredHistoryEntries() {
    final String query = _historySearchController.text.trim().toLowerCase();
    return global.actionLogConfig.entries.where((ActionLogEntry entry) {
      if (_historyCategoryFilter != "all" &&
          entry.category.toLowerCase() != _historyCategoryFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final String bucket = [
        entry.timestamp,
        entry.userId,
        entry.userName,
        entry.category,
        entry.action,
        entry.target ?? "",
        entry.details ?? "",
        entry.result,
      ].join(" ").toLowerCase();
      return bucket.contains(query);
    }).toList();
  }

  Widget _buildHistoryTab() {
    final List<String> categories = _historyCategories();
    if (!categories.contains(_historyCategoryFilter)) {
      _historyCategoryFilter = "all";
    }
    final List<ActionLogEntry> entries = _filteredHistoryEntries();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed:
                      _historyBusy ? null : _reloadActionHistoryFromMachine,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Recharger"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B879B),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _historyBusy ? null : _clearActionHistory,
                  icon: const Icon(Icons.delete_sweep_rounded),
                  label: const Text("Effacer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B2B2B),
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String>(
                    initialValue: _historyCategoryFilter,
                    decoration: const InputDecoration(
                      labelText: "Categorie",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: categories
                        .map(
                          (String cat) => DropdownMenuItem<String>(
                            value: cat,
                            child: Text(
                                cat == "all" ? "Toutes" : _prettyToken(cat)),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) return;
                      setState(() {
                        _historyCategoryFilter = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: TextField(
                    controller: _historySearchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      labelText: "Recherche",
                      hintText: "action, utilisateur, cible...",
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                if (_historyBusy)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                Text(
                  "${entries.length} entree(s)",
                  style: const TextStyle(
                    color: Color(0xFF4A5160),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (_historyStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _historyStatus,
                  style: TextStyle(
                    color: _historyStatus.toLowerCase().contains("erreur")
                        ? const Color(0xFFC62828)
                        : const Color(0xFF2D3440),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: entries.isEmpty
                ? const Center(
                    child: Text(
                      "Aucune entree d'historique.",
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  )
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ActionLogEntry entry = entries[index];
                      final bool isOk = entry.result.toLowerCase() == "ok";
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE7F0F7),
                            child: Icon(
                              _historyIconForCategory(entry.category),
                              color: const Color(0xFF2B879B),
                            ),
                          ),
                          title: Text(
                            _prettyToken(entry.action),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 4),
                              Text(
                                "${_formatLogDate(entry.timestamp)} | ${entry.userName} (${entry.userId})",
                              ),
                              Text(
                                  "Categorie: ${_prettyToken(entry.category)}"),
                              if ((entry.target ?? "").isNotEmpty)
                                Text("Cible: ${entry.target}"),
                              if ((entry.details ?? "").isNotEmpty)
                                Text("Detail: ${entry.details}"),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isOk
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isOk
                                    ? const Color(0xFF81C784)
                                    : const Color(0xFFE57373),
                              ),
                            ),
                            child: Text(
                              entry.result.toUpperCase(),
                              style: TextStyle(
                                color: isOk
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        onAnyTap: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF20917F)),
        backgroundColor: Color(0xFFF0F0F3),
        actions: const <Widget>[
          AccountToolbarButton(),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: Container(
                    child: Image(image: AssetImage("assets/iconnaxe.png")))),
            Flexible(
              flex: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    SizedBox(
                      width: 300,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: ManualGcodeComand,
                            decoration: InputDecoration(
                              hintText: "Gcode",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gapPadding: 5.0,
                              ),
                            ),
                            onSubmitted: (Commande) {
                              setState(() {
                                global.commandHistory.add(Commande);
                                ManualGcodeComand.clear();
                                API_Manager().sendGcodeCommand(Commande).then(
                                    (value) => API_Manager().sendrr_reply());
                              });
                            },
                          ),
                          PopupMenuButton<String>(
                            tooltip: "Historique",
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              setState(() {
                                ManualGcodeComand.text = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return global.commandHistory
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    NeumorphicButton(
                        style: const NeumorphicStyle(
                          color: Color(0xFFF0F0F3),
                        ),
                        onPressed: () {
                          setState(() {
                            global.commandHistory.add(ManualGcodeComand.text);
                            print(ManualGcodeComand.text);

                            API_Manager()
                                .sendGcodeCommand(ManualGcodeComand.text)
                                .then((value) => API_Manager().sendrr_reply());
                            ManualGcodeComand.clear();
                          });
                        },
                        child: const Icon(
                          Icons.send,
                          color: Color(0xFF20917F),
                        )),
                    Spacer(),
                    Text(
                      global.Title,
                      style: TextStyle(color: Color(0xFF707585)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Flexible(
              flex: 11,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  //color: Colors.redAccent.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const Text(
                              "Charger depuis PC",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () {
                              if (global.AdminLogged) {
                                isLoading = true;
                                _pickFile();
                              } else
                                null;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Diag backlash",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            icon: const Icon(
                              Icons.bug_report_outlined,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () {
                              if (global.AdminLogged) {
                                API_Manager()
                                    .sendGcodeCommand('M98 P"baclash_test.g"');
                              } else
                                null;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Upload to server",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              if (global.AdminLogged) {
                                await API_Manager().showUploadProgressDialog(
                                    files: (global.ListofSysFile ?? [])
                                        .whereType<SysFileElement>()
                                        .toList(),
                                    overwrite: true,
                                    serial: global.MyMachineN02Config.Serie ??
                                        "01902",
                                    context: context);
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Download from serv",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B879B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              await API_Manager().synchronizeFilesToMachine(
                                  context: context,
                                  serial: global.MyMachineN02Config.Serie ??
                                      "190222");
                              //await API_Manager().downloadFileFromServer("220216","config.g");
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Start log",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 43, 155, 112),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              await API_Manager().sendGcodeCommand("M929 S3");
                              await API_Manager().sendGcodeCommand("M929");
                              API_Manager().sendrr_reply();
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Stop log",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            icon: const Icon(
                              Icons.offline_bolt,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 189, 145, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              await API_Manager().sendGcodeCommand("M929 S0");
                              await API_Manager().sendGcodeCommand("M929");
                              API_Manager().sendrr_reply();
                            },
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 19,
                          child: Container(
                            height: double.infinity,
                          )),
                      Flexible(
                        flex: 5,
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ElevatedButton.icon(
                            label: const Text(
                              "Télécharger programme",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              if (global.AdminLogged) {
                                String FileContent =
                                    await API_Manager().downLoadAFile(
                                  "sys",
                                  ListofSysFile!
                                      .elementAt(selectedFileIndex)!
                                      .name
                                      .toString(),
                                );
                                await SaveFileContent(FileContent);
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton.icon(
                            label: const Text(
                              "Supprimer programme",
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9B2B2B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {});
                              if (global.AdminLogged) {
                                API_Manager()
                                    .deleteAFile(
                                        ListofSysFile!
                                            .elementAt(selectedFileIndex)!
                                            .name
                                            .toString(),
                                        "sys")
                                    .then((deleteResult) {
                                  if (deleteResult == 'ok') {
                                    unawaited(
                                      ActionLogger.log(
                                        category: 'sys_files',
                                        action: 'delete_sys_file',
                                        target: ListofSysFile!
                                            .elementAt(selectedFileIndex)!
                                            .name
                                            .toString(),
                                        details:
                                            'Suppression d\'un fichier /sys',
                                        result: 'ok',
                                      ),
                                    );
                                  }
                                  API_Manager().getfileListSys().then((value) {
                                    global.ListofSysFile = value;
                                    setState(() {});
                                  });
                                });
                              } else
                                null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Flexible(
              flex: 40,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Container(
                            height: double.infinity,
                            margin: EdgeInsets.all(20),
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text("Liste des fichiers systems: ")))),
                    Flexible(
                        flex: 1,
                        child: isLoading
                            ? Container(
                                height: double.infinity,
                                child: LinearProgressIndicator())
                            : Container(
                                height: double.infinity,
                              )),
                    Flexible(
                      flex: 45,
                      child: Container(
                        child: ListView.builder(
                          itemCount: ListofSysFile?.length,
                          itemBuilder: (BuildContext context, int index) {
                            ListofSysFile?.sort(
                                (a, b) => a!.name!.compareTo(b!.name!));

                            return Card(
                              elevation: 4,
                              child: ListTile(
                                tileColor: Colors.white,
                                selectedColor: Colors.orange,
                                selectedTileColor: Colors.black26,
                                selected: index == selectedFileIndex,
                                onTap: () {
                                  setState(() {
                                    selectedFileIndex = index;
                                    global.selectedFileSysIndex = index;
                                  });
                                  //return _onAnyTap!();
                                },
                                leading: Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.blue,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ListofSysFile!
                                          .elementAt(index)!
                                          .name
                                          .toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      (ListofSysFile!
                                              .elementAt(index)!
                                              .size
                                              .toString() +
                                          " Octets"),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Flexible(
            flex: 40,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: Row(
                    children: <Widget>[
                      _buildAdminTabButton(
                        label: "Systeme",
                        selected: !_showAccountsTab && !_showHistoryTab,
                        onPressed: () {
                          setState(() {
                            _showAccountsTab = false;
                            _showHistoryTab = false;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildAdminTabButton(
                        label: "Comptes",
                        selected: _showAccountsTab && !_showHistoryTab,
                        onPressed: () {
                          setState(() {
                            _showAccountsTab = true;
                            _showHistoryTab = false;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildAdminTabButton(
                        label: "Historique",
                        selected: _showHistoryTab,
                        onPressed: () {
                          setState(() {
                            _showHistoryTab = true;
                            _showAccountsTab = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _showAccountsTab
                      ? _buildAccountsTab()
                      : _showHistoryTab
                          ? _buildHistoryTab()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 80,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black26, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: ListView.builder(
                                      itemCount:
                                          global.ReplyListFiFo.items.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          elevation: 4,
                                          child: ListTile(
                                            tileColor: global
                                                    .ReplyListFiFo.items
                                                    .elementAt(index)
                                                    .contains("Error")
                                                ? Colors.redAccent
                                                : global.ReplyListFiFo.items
                                                        .elementAt(index)
                                                        .contains("Warning")
                                                    ? Colors.yellowAccent
                                                    : Colors.white,
                                            leading: Icon(
                                              Icons.arrow_right,
                                              color: Colors.blue,
                                            ),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Container(
                                                    width: 400,
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.visible,
                                                      global.ReplyListFiFo.items
                                                          .elementAt(index),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (global.AdminLogged) {
                                            setState(() {
                                              global.ReplyListFiFo.items
                                                  .clear();
                                            });
                                          } else
                                            null;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "clear",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (global.AdminLogged) {
                                            setState(() async {
                                              global.AdminLogged = false;
                                              global.Title =
                                                  global.DefaultTitle;
                                              await API_Manager().sendGcodeCommand(
                                                  'M98 P"caissoncrea.g"'); // reinitialiser les affectations du capteur de porte.
                                              Navigator.pushNamed(
                                                  context, '/admin');
                                            });
                                          } else
                                            null;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Logout",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (global.AdminLogged) {
                                            await API_Manager()
                                                .downLoadAFile(
                                                    'sys',
                                                    ListofSysFile!
                                                        .elementAt(
                                                            selectedFileIndex)!
                                                        .name
                                                        .toString())
                                                .then((value) =>
                                                    global.ContentofFileToEdit =
                                                        value);
                                            Navigator.pushNamed(
                                                context, '/editor');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: Text(
                                          "Visualiser",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (global.AdminLogged) {
                                            await API_Manager()
                                                .sendGcodeCommand(
                                                    'M98 P"config.g"')
                                                .then((_) {
                                              Timer(const Duration(seconds: 3),
                                                  () {
                                                Timer.periodic(
                                                    const Duration(
                                                        milliseconds: 200),
                                                    (timer) {
                                                  API_Manager().sendrr_reply();
                                                });
                                              });
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Run config.g",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (global.AdminLogged) {
                                            API_Manager().upLoadAFile(
                                                "0:/sys/nwc-settings.json",
                                                global.MyMachineN02ConfigDeflaut
                                                        .toJson()
                                                    .length
                                                    .toString(),
                                                Uint8List.fromList(
                                                    machineN02ConfigToJson(global
                                                            .MyMachineN02ConfigDeflaut)
                                                        .codeUnits));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: const Text(
                                          "Load Default Config",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (global.AdminLogged) {
                                            API_Manager().upLoadAFile(
                                              "0:/sys/outil-settings.json",
                                              global.magasinOutil
                                                  .toJson()
                                                  .length
                                                  .toString(),
                                              Uint8List.fromList(outilToJson(
                                                      global.magasinOutil)
                                                  .codeUnits),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: Text(
                                          "Load Tool",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        // Boutton qui execute les fichiers macro GCode
                                        onPressed: () async {
                                          if (global.AdminLogged) {
                                            API_Manager()
                                                .sendGcodeCommand(
                                                    'M98 P"${global.ListofSysFile?.elementAt(global.selectedFileSysIndex)?.name}"')
                                                .then((value) => API_Manager()
                                                    .sendrr_reply());
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: Text(
                                          "Execute macro",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Status Pin In :',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              8.0), // Espace entre le texte et les cercles
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: (global
                                                  .machineObjectModel
                                                  .result
                                                  ?.sensors
                                                  ?.gpIn
                                                  ?.length ??
                                              0),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            var value = global
                                                .machineObjectModel
                                                .result
                                                ?.sensors
                                                ?.gpIn?[index];

                                            Color color;
                                            if (value == null) {
                                              color = Colors.grey;
                                            } else if (value.value == 1) {
                                              color = Colors.green;
                                            } else if (value.value == 0) {
                                              color = Colors.blue;
                                            } else {
                                              color = Colors.purple;
                                            }

                                            return Container(
                                              margin: const EdgeInsets.all(4.0),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: color,
                                                    size: 24.0,
                                                  ),
                                                  Text(
                                                    '${index}', // Pour afficher 1 au lieu de 0
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Status Pin Out :',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: (global
                                                  .machineObjectModel
                                                  .result
                                                  ?.state
                                                  ?.gpOut
                                                  ?.length ??
                                              0),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            var value = global
                                                .machineObjectModel
                                                .result
                                                ?.state
                                                ?.gpOut?[index];

                                            Color color;
                                            if (value == null) {
                                              color = Colors.grey;
                                            } else if (value.pwm == 1) {
                                              color = Colors.green;
                                            } else if (value.pwm == 0) {
                                              color = Colors.blue;
                                            } else {
                                              color = Colors.grey;
                                            }

                                            return Container(
                                              margin: const EdgeInsets.all(4.0),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: color,
                                                    size: 24.0,
                                                  ),
                                                  Text(
                                                    '${index}', // Pour afficher 1 au lieu de 0
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                )
                              ],
                            ),
                ),
              ],
            ),
          ),
          Flexible(flex: 5, child: Container()),
        ],
      ),
    );
  }
}
