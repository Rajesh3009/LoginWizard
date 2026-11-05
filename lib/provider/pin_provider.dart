import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/database/appdatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/conts.dart';
import '../utils/security_utils.dart';

final pinProvider = StateNotifierProvider<PinNotifier, String>((ref) {
  return PinNotifier(ref);
});

final pinHistoryProvider =
    FutureProvider.autoDispose<List<PinTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  final data = await database
      .select(database.pinTable)
      .get()
      .then((value) => value.reversed.toList());
  return data;
});

class PinNotifier extends StateNotifier<String> {
  PinNotifier(this.ref) : super('');
  final Ref ref;
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<void> generatePin({
    required int length,
    bool alphanumeric = false,
    bool avoidPatterns = false,
  }) async {
    final pin = SecurityUtils.generatePin(
      length: length,
      alphanumeric: alphanumeric,
      avoidPatterns: avoidPatterns,
    );

    state = pin;

    if (pin.isNotEmpty) {
      final autoSave = await _prefs.getBool(autoSaveHistoryKey) ?? true;
      if (autoSave) {
        final db = ref.read(databaseProvider);
        await db.into(db.pinTable).insert(
              PinTableCompanion.insert(
                pin: pin,
                createdAt: Value(DateTime.now()),
                isFavorite: const Value(false),
              ),
            );
        ref.invalidate(pinHistoryProvider);
      }
    }
  }
}
