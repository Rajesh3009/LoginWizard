import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/appdatabase.dart';
import '../utils/conts.dart';
import '../utils/security_utils.dart';

final passwordProvider = StateNotifierProvider<PasswordProvider, String>((ref) {
  return PasswordProvider(ref);
});

final passwordHistoryProvider =
    FutureProvider.autoDispose<List<PasswordTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  final data = await database
      .select(database.passwordTable)
      .get()
      .then((value) => value.reversed.toList());
  return data;
});

class PasswordProvider extends StateNotifier<String> {
  final Ref ref;
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  PasswordProvider(this.ref) : super('');

  Future<void> generatePassword({
    required int length,
    required bool includeLowercase,
    required bool includeUppercase,
    required bool includeNumbers,
    required bool includeSymbols,
    bool excludeAmbiguous = false,
    String customExclude = '',
  }) async {
    final password = SecurityUtils.generatePassword(
      length: length,
      includeLowercase: includeLowercase,
      includeUppercase: includeUppercase,
      includeNumbers: includeNumbers,
      includeSymbols: includeSymbols,
      excludeAmbiguous: excludeAmbiguous,
      customExclude: customExclude,
    );

    state = password;

    if (password.isNotEmpty) {
      await _checkAndSave(password);
    }
  }

  Future<void> generatePassphrase({
    required int length,
    required String separator,
    required bool capitalize,
    required bool includeNumber,
  }) async {
    final passphrase = SecurityUtils.generatePassphrase(
      wordCount: length,
      separator: separator,
      capitalize: capitalize,
      includeNumber: includeNumber,
    );

    state = passphrase;

    if (passphrase.isNotEmpty) {
      await _checkAndSave(passphrase);
    }
  }

  Future<void> _checkAndSave(String value) async {
    final autoSave = await _prefs.getBool(autoSaveHistoryKey) ?? true;
    if (autoSave) {
      final db = ref.read(databaseProvider);
      await db.into(db.passwordTable).insert(
            PasswordTableCompanion.insert(
              password: value,
              createdAt: Value(DateTime.now()),
              isFavorite: const Value(false),
            ),
          );
      ref.invalidate(passwordHistoryProvider);
    }
  }
}
