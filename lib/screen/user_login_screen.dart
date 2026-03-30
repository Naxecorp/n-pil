import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nweb/main.dart';
import 'package:nweb/service/API/API_Manager.dart';
import 'package:nweb/service/logging/action_logger.dart';

import '../globals_var.dart' as global;
import '../service/security/user_accounts_config.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  String? _selectedAccountId;
  String _pinInput = '';
  String _status = '';

  List<UserAccount> get _accounts => global.userAccountsConfig.accounts;

  @override
  void initState() {
    super.initState();
    if (_accounts.isNotEmpty) {
      _selectedAccountId = _accounts.first.id;
    }
    pageToShow = 0;
  }

  UserAccount? _selectedAccount() {
    if (_selectedAccountId == null) {
      return null;
    }
    return global.userAccountsConfig.accountById(_selectedAccountId!);
  }

  void _appendDigit(String digit) {
    if (_pinInput.length >= UserAccount.pinLength) {
      return;
    }
    setState(() {
      _pinInput = '$_pinInput$digit';
      _status = '';
    });
  }

  void _backspace() {
    if (_pinInput.isEmpty) {
      return;
    }
    setState(() {
      _pinInput = _pinInput.substring(0, _pinInput.length - 1);
      _status = '';
    });
  }

  void _clearPin() {
    setState(() {
      _pinInput = '';
      _status = '';
    });
  }

  Future<void> _persistUserAccountsConfig(UserAccountsConfig config) async {
    final String jsonContent = userAccountsConfigToJson(config);
    await API_Manager().upLoadAFile(
      "0:/sys/${UserAccountsConfig.fileName}",
      utf8.encode(jsonContent).length.toString(),
      Uint8List.fromList(utf8.encode(jsonContent)),
    );
  }

  Future<void> _updateLastMachineUse(UserAccount account) async {
    final UserAccountsConfig nextConfig = global.userAccountsConfig.copy();
    final UserAccount? mutableAccount = nextConfig.accountById(account.id);
    if (mutableAccount == null) {
      return;
    }

    final String nowIso = DateTime.now().toIso8601String();
    mutableAccount.lastMachineUseAt = nowIso;
    nextConfig.lastModification = nowIso;
    nextConfig.ensureConsistency();

    global.userAccountsConfig = nextConfig;
    global.pwd = nextConfig.adminAccount?.pin ?? global.pwd;

    try {
      await _persistUserAccountsConfig(nextConfig);
    } catch (_) {}
  }

  Future<void> _submitLogin() async {
    final UserAccount? account = _selectedAccount();
    if (account == null) {
      setState(() {
        _status = 'Aucun utilisateur selectionne.';
      });
      return;
    }
    if (_pinInput.length != UserAccount.pinLength) {
      setState(() {
        _status = 'Le mot de passe doit contenir 4 chiffres.';
      });
      return;
    }

    final String entered = UserAccount.sanitizePin(_pinInput);
    if (entered != UserAccount.sanitizePin(account.pin)) {
      setState(() {
        _status = 'Mot de passe incorrect.';
        _pinInput = '';
      });
      return;
    }

    await _updateLastMachineUse(account);

    final UserAccount activeAccount =
        global.userAccountsConfig.accountById(account.id) ?? account;
    global.currentUserId = activeAccount.id;
    global.currentUserName = activeAccount.displayName;
    global.AdminLogged = activeAccount.isAdmin;
    global.Title = activeAccount.isAdmin
        ? 'ADMIN MODE | ${global.version}'
        : global.DefaultTitle;

    await ActionLogger.log(
      category: 'auth',
      action: 'login',
      target: activeAccount.id,
      details: 'Connexion utilisateur',
      result: 'ok',
    );

    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  Widget _buildPinDots() {
    final List<Widget> dots = <Widget>[];
    for (int i = 0; i < UserAccount.pinLength; i++) {
      dots.add(
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F3),
            border: Border.all(color: const Color(0xFFCAD6E3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            i < _pinInput.length ? '*' : '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  Widget _keyButton({
    required String label,
    required VoidCallback onPressed,
    Color background = const Color(0xFFE6EDF5),
  }) {
    return SizedBox(
      width: 86,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: const Color(0xFF2D3440),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildVirtualKeypad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _keyButton(label: '1', onPressed: () => _appendDigit('1')),
            const SizedBox(width: 8),
            _keyButton(label: '2', onPressed: () => _appendDigit('2')),
            const SizedBox(width: 8),
            _keyButton(label: '3', onPressed: () => _appendDigit('3')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _keyButton(label: '4', onPressed: () => _appendDigit('4')),
            const SizedBox(width: 8),
            _keyButton(label: '5', onPressed: () => _appendDigit('5')),
            const SizedBox(width: 8),
            _keyButton(label: '6', onPressed: () => _appendDigit('6')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _keyButton(label: '7', onPressed: () => _appendDigit('7')),
            const SizedBox(width: 8),
            _keyButton(label: '8', onPressed: () => _appendDigit('8')),
            const SizedBox(width: 8),
            _keyButton(label: '9', onPressed: () => _appendDigit('9')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _keyButton(
              label: 'C',
              onPressed: _clearPin,
              background: const Color(0xFFFFE0B2),
            ),
            const SizedBox(width: 8),
            _keyButton(label: '0', onPressed: () => _appendDigit('0')),
            const SizedBox(width: 8),
            _keyButton(
              label: '<-',
              onPressed: _backspace,
              background: const Color(0xFFFFCDD2),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F3),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 560),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD7DEE8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Connexion utilisateur',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _selectedAccountId,
                  decoration: const InputDecoration(
                    labelText: 'Utilisateur',
                    border: OutlineInputBorder(),
                  ),
                  items: _accounts
                      .map(
                        (account) => DropdownMenuItem<String>(
                          value: account.id,
                          child: Text(account.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedAccountId = value;
                      _pinInput = '';
                      _status = '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Mot de passe (4 chiffres)'),
                const SizedBox(height: 8),
                _buildPinDots(),
                const SizedBox(height: 16),
                _buildVirtualKeypad(),
                const SizedBox(height: 14),
                if (_status.isNotEmpty)
                  Text(
                    _status,
                    style: const TextStyle(
                      color: Color(0xFFC62828),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitLogin,
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Se connecter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B879B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
