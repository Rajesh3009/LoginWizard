import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/database/appdatabase.dart';

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

  void generatePin(int length) {
    final pin = Random()
        .nextInt(pow(10, length).toInt())
        .toString()
        .padLeft(length, '0');
    state = pin;
    ref.read(databaseProvider).into(ref.read(databaseProvider).pinTable).insert(
        PinTableCompanion.insert(pin: pin, createdAt: Value(DateTime.now())));
  }
}
