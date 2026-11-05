import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/appdatabase.dart';
import '../utils/constants.dart';
import '../utils/wordlists.dart';
import 'username_history_provider.dart';

enum UsernameCasing { lowercase, titleCase, uppercase }

enum PatternTokenType {
  adjective,
  noun,
  number,
  year,
  separator,
}

class PatternToken {
  final String id;
  final PatternTokenType type;
  final String value; // separator char, digit length, etc.

  PatternToken({
    required this.id,
    required this.type,
    this.value = '',
  });

  String get label {
    switch (type) {
      case PatternTokenType.adjective:
        return 'Adjective';
      case PatternTokenType.noun:
        return 'Noun';
      case PatternTokenType.number:
        return value.isNotEmpty ? 'Number ($value)' : 'Number';
      case PatternTokenType.year:
        return 'Year';
      case PatternTokenType.separator:
        return 'Sep (${value.isEmpty ? '_' : value})';
    }
  }
}

final usernameProvider = StateNotifierProvider<UsernameProvider, String>((ref) {
  return UsernameProvider(ref);
});

class UsernameProvider extends StateNotifier<String> {
  final Ref ref;
  final Random _random = Random.secure();
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  UsernameProvider(this.ref) : super('');

  Future<void> generateFromTokens(
    List<PatternToken> tokens, {
    UsernameCasing casing = UsernameCasing.lowercase,
  }) async {
    if (tokens.isEmpty) {
      state = '';
      return;
    }

    final buffer = StringBuffer();

    for (final token in tokens) {
      String segment = '';
      switch (token.type) {
        case PatternTokenType.adjective:
          segment = WordLists.adjectives[_random.nextInt(WordLists.adjectives.length)];
          break;
        case PatternTokenType.noun:
          segment = WordLists.nouns[_random.nextInt(WordLists.nouns.length)];
          break;
        case PatternTokenType.number:
          final len = int.tryParse(token.value) ?? 2;
          for (var i = 0; i < len; i++) {
            segment += _random.nextInt(10).toString();
          }
          break;
        case PatternTokenType.year:
          final startYear = 1990;
          final currentYear = DateTime.now().year;
          final year = startYear + _random.nextInt(currentYear - startYear + 1);
          segment = year.toString();
          break;
        case PatternTokenType.separator:
          segment = token.value.isEmpty ? '_' : token.value;
          break;
      }

      // Apply casing to word segments
      if (token.type == PatternTokenType.adjective || token.type == PatternTokenType.noun) {
        if (casing == UsernameCasing.titleCase) {
          segment = segment[0].toUpperCase() + segment.substring(1).toLowerCase();
        } else if (casing == UsernameCasing.uppercase) {
          segment = segment.toUpperCase();
        } else {
          segment = segment.toLowerCase();
        }
      }

      buffer.write(segment);
    }

    final generated = buffer.toString();
    state = generated;

    if (generated.isNotEmpty) {
      final autoSave = await _prefs.getBool(autoSaveHistoryKey) ?? true;
      if (autoSave) {
        final database = ref.read(databaseProvider);
        await database.into(database.usernameTable).insert(
              UsernameTableCompanion.insert(
                username: generated,
                createdAt: Value(DateTime.now()),
                isFavorite: const Value(false),
              ),
            );
        ref.invalidate(usernameHistoryProvider);
      }
    }
  }

  // Backward compatibility with legacy format strings
  Future<void> generateUsername(String format, int numLen) async {
    final formats = format.split(':');
    final tokens = <PatternToken>[];
    for (var i = 0; i < formats.length; i++) {
      final f = formats[i];
      if (f == 'w' || f == 'W') {
        tokens.add(PatternToken(
            id: 'legacy_$i',
            type: PatternTokenType.noun));
      } else if (f == 'n') {
        tokens.add(PatternToken(
            id: 'legacy_$i',
            type: PatternTokenType.number,
            value: numLen.toString()));
      } else {
        tokens.add(PatternToken(
            id: 'legacy_$i',
            type: PatternTokenType.separator,
            value: f));
      }
    }
    await generateFromTokens(tokens);
  }
}
