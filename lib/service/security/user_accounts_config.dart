import 'dart:convert';

UserAccountsConfig userAccountsConfigFromJson(String source) {
  return UserAccountsConfig.fromJson(
    json.decode(source) as Map<String, dynamic>,
  );
}

String userAccountsConfigToJson(UserAccountsConfig data) {
  return json.encode(data.toJson());
}

class UserAccount {
  UserAccount({
    required this.id,
    required this.displayName,
    required this.pin,
    this.isAdmin = false,
    this.isPermanent = false,
    this.lastMachineUseAt,
  }) {
    pin = sanitizePin(pin);
  }

  static const int pinLength = 4;

  String id;
  String displayName;
  String pin;
  bool isAdmin;
  bool isPermanent;
  String? lastMachineUseAt;

  static String sanitizePin(String input) {
    final String digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length >= pinLength) {
      return digitsOnly.substring(0, pinLength);
    }
    return digitsOnly.padRight(pinLength, '0');
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      displayName: json['displayName']?.toString() ?? 'Utilisateur',
      pin: sanitizePin(json['pin']?.toString() ?? '0000'),
      isAdmin: json['isAdmin'] == true,
      isPermanent: json['isPermanent'] == true,
      lastMachineUseAt: json['lastMachineUseAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'pin': sanitizePin(pin),
      'isAdmin': isAdmin,
      'isPermanent': isPermanent,
      'lastMachineUseAt': lastMachineUseAt,
    };
  }

  UserAccount copy() {
    return UserAccount(
      id: id,
      displayName: displayName,
      pin: pin,
      isAdmin: isAdmin,
      isPermanent: isPermanent,
      lastMachineUseAt: lastMachineUseAt,
    );
  }
}

class UserAccountsConfig {
  UserAccountsConfig({
    required this.accounts,
    this.lastModification,
  }) {
    ensureConsistency();
  }

  static const String fileName = 'user-accounts.json';
  static const String adminId = 'admin';

  List<UserAccount> accounts;
  String? lastModification;

  factory UserAccountsConfig.fromJson(Map<String, dynamic> json) {
    final dynamic rawAccounts = json['accounts'];
    final List<UserAccount> parsedAccounts = rawAccounts is List
        ? rawAccounts
            .whereType<Map<String, dynamic>>()
            .map(UserAccount.fromJson)
            .toList()
        : <UserAccount>[];

    return UserAccountsConfig(
      accounts: parsedAccounts,
      lastModification: json['lastModification']?.toString(),
    );
  }

  void ensureConsistency() {
    final Set<String> usedIds = <String>{};
    for (final UserAccount account in accounts) {
      account.pin = UserAccount.sanitizePin(account.pin);
      String candidateId = account.id.trim().isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : account.id.trim();
      int i = 1;
      while (usedIds.contains(candidateId)) {
        candidateId = '${account.id}-$i';
        i++;
      }
      account.id = candidateId;
      usedIds.add(account.id);
    }

    UserAccount? admin = adminAccount;
    if (admin == null) {
      accounts.insert(
        0,
        UserAccount(
          id: adminId,
          displayName: 'admin',
          pin: '0000',
          isAdmin: true,
          isPermanent: true,
        ),
      );
      admin = accounts.first;
    }

    admin.id = adminId;
    admin.displayName = 'admin';
    admin.isAdmin = true;
    admin.isPermanent = true;
    admin.pin = UserAccount.sanitizePin(admin.pin);

    for (final UserAccount account in accounts) {
      if (account.id != adminId) {
        account.displayName = account.displayName.trim().isEmpty
            ? 'Utilisateur'
            : account.displayName.trim();
      }
    }
  }

  UserAccount? get adminAccount {
    for (final UserAccount account in accounts) {
      if (account.id == adminId) {
        return account;
      }
    }
    return null;
  }

  UserAccount? accountById(String id) {
    for (final UserAccount account in accounts) {
      if (account.id == id) {
        return account;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'lastModification': lastModification,
      'accounts': accounts.map((account) => account.toJson()).toList(),
    };
  }

  UserAccountsConfig copy() {
    return UserAccountsConfig(
      accounts: accounts.map((account) => account.copy()).toList(),
      lastModification: lastModification,
    );
  }

  static UserAccountsConfig defaults() {
    return UserAccountsConfig(
      lastModification: DateTime.now().toIso8601String(),
      accounts: <UserAccount>[
        UserAccount(
          id: adminId,
          displayName: 'admin',
          pin: '0000',
          isAdmin: true,
          isPermanent: true,
        ),
      ],
    );
  }
}
