import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_generator/word_generator.dart';

import '../database/appdatabase.dart';

final usernameProvider = StateNotifierProvider<UsernameProvider, String>((ref) {
  return UsernameProvider(ref);
});

class UsernameProvider extends StateNotifier<String> {
  final Ref ref;
  UsernameProvider(this.ref) : super('');

  void generateUsername(String format, int numLen) {
    final database = ref.read(databaseProvider);

    final ran = Random();
    final formats = format.split(':');
    var username = '';
    for (var f in formats) {
      if (f == 'w') {
        username += WordGenerator().randomNoun();
      } else if (f == 'n') {
        for (int i = 0; i < numLen; i++) {
          username += ran.nextInt(10).toString();
        }
      } else if (f == 'W') {
        final word = WordGenerator().randomNoun();
        username += word[0].toUpperCase() + word.substring(1);
      } else {
        username += f;
      }
    }
    state = username;
    database.into(database.usernameTable).insert(UsernameTableCompanion.insert(
        username: username, createdAt: Value(DateTime.now())));
  }
}
