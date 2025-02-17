import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_generator/word_generator.dart';

import '../database/appdatabase.dart';

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
  PasswordProvider(this.ref) : super('');

  void generatePassword(int length, bool includeLowercase,
      bool includeUppercase, bool includeNumbers, bool includeSymbols) {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = r'!@#\$%^&*()-_=+[]{}|;:,.<>?';

    String chars = '';
    if (includeLowercase) chars += lowercase;
    if (includeUppercase) chars += uppercase;
    if (includeNumbers) chars += numbers;
    if (includeSymbols) chars += symbols;

    if (chars.isEmpty) {
      state = '';
      return;
    }

    final ran = Random();
    var password =
        List.generate(length, (index) => chars[ran.nextInt(chars.length)])
            .join();

    state = password;
    ref
        .read(databaseProvider)
        .into(ref.read(databaseProvider).passwordTable)
        .insert(PasswordTableCompanion.insert(
            password: state, createdAt: Value(DateTime.now())));
  }

  void generatePassphrase(
      int length, String separator, bool capitalize, bool includeNumber) {
    final wordGenerator = WordGenerator();
    List<String> words = wordGenerator.randomNouns(length);

    if (capitalize) {
      words = words
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .toList();
    }

    if (includeNumber) {
      final ran = Random();
      words.add(ran.nextInt(100).toString());
    }

    words.shuffle();
    state = words.join(separator);
    ref
        .read(databaseProvider)
        .into(ref.read(databaseProvider).passwordTable)
        .insert(PasswordTableCompanion.insert(
            password: state, createdAt: Value(DateTime.now())));
  }
}
