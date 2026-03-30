import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/logging/action_logger.dart';

import '../globals_var.dart' as global;
import '../service/security/user_accounts_config.dart';

class AccountToolbarButton extends StatelessWidget {
  const AccountToolbarButton({super.key});

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return 'Jamais';
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

  Future<void> _logout(BuildContext context) async {
    await ActionLogger.log(
      category: 'auth',
      action: 'logout',
      target: global.currentUserId,
      details: 'Deconnexion utilisateur',
      result: 'ok',
    );

    try {
      if (global.AdminLogged) {
        await API_Manager().sendGcodeCommand('M98 P"caissoncrea.g"');
      }
    } catch (_) {}

    global.AdminLogged = false;
    global.Title = global.DefaultTitle;
    global.currentUserId = '';
    global.currentUserName = '';
    pageToShow = 0;

    if (!context.mounted) {
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, '/userLogin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    UserAccount? account = global.userAccountsConfig.accountById(
      global.currentUserId,
    );
    account ??= global.userAccountsConfig.adminAccount;

    final String displayName = global.currentUserName.isNotEmpty
        ? global.currentUserName
        : (account?.displayName ?? 'inconnu');
    final String userId = global.currentUserId.isNotEmpty
        ? global.currentUserId
        : (account?.id ?? 'inconnu');
    final String lastUseText = _formatDate(account?.lastMachineUseAt);

    return IconButton(
      tooltip: 'Gestion compte',
      icon: const Icon(
        Icons.account_circle_outlined,
        color: Color(0xFF20917F),
      ),
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Compte utilisateur'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Nom: $displayName'),
                  const SizedBox(height: 6),
                  Text('Identifiant: $userId'),
                  const SizedBox(height: 6),
                  Text('Derniere utilisation: $lastUseText'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Fermer'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    await _logout(context);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Se deconnecter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B879B),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
