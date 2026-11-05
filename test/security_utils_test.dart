import 'package:flutter_test/flutter_test.dart';
import 'package:loginwizard/utils/security_utils.dart';

void main() {
  group('SecurityUtils - Password Generation', () {
    test('generates password of requested length', () {
      final pwd = SecurityUtils.generatePassword(
        length: 20,
        includeLowercase: true,
        includeUppercase: true,
        includeNumbers: true,
        includeSymbols: true,
      );
      expect(pwd.length, equals(20));
    });

    test('guarantees inclusion from each active set', () {
      final pwd = SecurityUtils.generatePassword(
        length: 12,
        includeLowercase: true,
        includeUppercase: true,
        includeNumbers: true,
        includeSymbols: true,
      );
      expect(RegExp(r'[a-z]').hasMatch(pwd), isTrue);
      expect(RegExp(r'[A-Z]').hasMatch(pwd), isTrue);
      expect(RegExp(r'[0-9]').hasMatch(pwd), isTrue);
      expect(RegExp(r'[^a-zA-Z0-9]').hasMatch(pwd), isTrue);
    });

    test('excludes ambiguous characters when enabled', () {
      for (var i = 0; i < 20; i++) {
        final pwd = SecurityUtils.generatePassword(
          length: 30,
          includeLowercase: true,
          includeUppercase: true,
          includeNumbers: true,
          includeSymbols: true,
          excludeAmbiguous: true,
        );
        for (final ambig in SecurityUtils.ambiguousChars.split('')) {
          expect(pwd.contains(ambig), isFalse, reason: 'Found ambiguous char $ambig');
        }
      }
    });

    test('excludes custom characters', () {
      final pwd = SecurityUtils.generatePassword(
        length: 25,
        includeLowercase: true,
        includeUppercase: true,
        includeNumbers: true,
        includeSymbols: true,
        customExclude: r'@#$%^&*()',
      );
      for (final char in r'@#$%^&*()'.split('')) {
        expect(pwd.contains(char), isFalse, reason: 'Found custom excluded char $char');
      }
    });
  });

  group('SecurityUtils - Entropy & Strength Evaluation', () {
    test('evaluates weak passwords', () {
      final res = SecurityUtils.evaluateStrength('1234');
      expect(res.level, equals(PasswordStrengthLevel.weak));
    });

    test('evaluates strong diverse passwords', () {
      final res = SecurityUtils.evaluateStrength('p@\$\$w0rd_V3ry_Str0ng!#99');
      expect(res.entropyBits, greaterThan(70));
      expect(
        res.level == PasswordStrengthLevel.strong ||
            res.level == PasswordStrengthLevel.veryStrong,
        isTrue,
      );
    });
  });

  group('SecurityUtils - Passphrase Generation', () {
    test('generates passphrase with correct word count and separator', () {
      final phrase = SecurityUtils.generatePassphrase(
        wordCount: 4,
        separator: '-',
        capitalize: false,
        includeNumber: false,
      );
      final words = phrase.split('-');
      expect(words.length, equals(4));
    });

    test('capitalizes passphrase words when requested', () {
      final phrase = SecurityUtils.generatePassphrase(
        wordCount: 3,
        separator: '.',
        capitalize: true,
        includeNumber: false,
      );
      final words = phrase.split('.');
      for (final word in words) {
        expect(word[0], equals(word[0].toUpperCase()));
      }
    });
  });

  group('SecurityUtils - PIN Generation', () {
    test('safely generates arbitrary lengths without overflow crash', () {
      for (final len in [4, 8, 12, 16, 24, 32]) {
        final pin = SecurityUtils.generatePin(length: len);
        expect(pin.length, equals(len));
        expect(RegExp(r'^\d+$').hasMatch(pin), isTrue);
      }
    });

    test('detects weak patterns', () {
      expect(SecurityUtils.isWeakPin('1111'), isTrue);
      expect(SecurityUtils.isWeakPin('0000'), isTrue);
      expect(SecurityUtils.isWeakPin('1234'), isTrue);
      expect(SecurityUtils.isWeakPin('4321'), isTrue);
      expect(SecurityUtils.isWeakPin('1212'), isTrue);
      expect(SecurityUtils.isWeakPin('1998'), isTrue); // Birth year
    });

    test('formats PIN with chunks', () {
      expect(SecurityUtils.formatPin('123456', chunkSize: 3), equals('123-456'));
      expect(SecurityUtils.formatPin('12345678', chunkSize: 4), equals('1234-5678'));
    });

    test('generates alphanumeric PINs when requested', () {
      final pin = SecurityUtils.generatePin(length: 20, alphanumeric: true);
      expect(pin.length, equals(20));
      expect(RegExp(r'^[0-9A-Z]+$').hasMatch(pin), isTrue);
    });
  });
}
