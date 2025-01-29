import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_generator/word_generator.dart';

final usernameProvider = StateNotifierProvider<UsernameProvider, String>((ref) {
  return UsernameProvider();
});

class UsernameProvider extends StateNotifier<String> {
  UsernameProvider() : super('');

  generateUsername(String format, int numLen) {
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
  }
}
