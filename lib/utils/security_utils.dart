import 'dart:math';
import 'package:flutter/material.dart';
import 'wordlists.dart';

enum PasswordStrengthLevel { weak, fair, strong, veryStrong }

class PasswordStrengthResult {
  final double entropyBits;
  final PasswordStrengthLevel level;
  final String crackTimeEstimate;
  final Color color;
  final String label;

  PasswordStrengthResult({
    required this.entropyBits,
    required this.level,
    required this.crackTimeEstimate,
    required this.color,
    required this.label,
  });
}

class SecurityUtils {
  static final Random _secureRandom = Random.secure();

  static const String lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  static const String uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String numberChars = '0123456789';
  static const String symbolChars = r'!@#$%^&*()-_=+[]{}|;:,.<>?';
  static const String ambiguousChars = '0OoIl1|`~';

  /// Generates a cryptographically secure random password meeting all specified constraints
  static String generatePassword({
    required int length,
    required bool includeLowercase,
    required bool includeUppercase,
    required bool includeNumbers,
    required bool includeSymbols,
    bool excludeAmbiguous = false,
    String customExclude = '',
  }) {
    if (length <= 0) return '';

    var lower = includeLowercase ? lowercaseChars : '';
    var upper = includeUppercase ? uppercaseChars : '';
    var nums = includeNumbers ? numberChars : '';
    var syms = includeSymbols ? symbolChars : '';

    // Apply ambiguous exclusion
    if (excludeAmbiguous) {
      for (final char in ambiguousChars.split('')) {
        lower = lower.replaceAll(char, '');
        upper = upper.replaceAll(char, '');
        nums = nums.replaceAll(char, '');
        syms = syms.replaceAll(char, '');
      }
    }

    // Apply custom exclusions
    if (customExclude.isNotEmpty) {
      for (final char in customExclude.split('')) {
        lower = lower.replaceAll(char, '');
        upper = upper.replaceAll(char, '');
        nums = nums.replaceAll(char, '');
        syms = syms.replaceAll(char, '');
      }
    }

    final activeSets = <String>[];
    if (lower.isNotEmpty) activeSets.add(lower);
    if (upper.isNotEmpty) activeSets.add(upper);
    if (nums.isNotEmpty) activeSets.add(nums);
    if (syms.isNotEmpty) activeSets.add(syms);

    if (activeSets.isEmpty) {
      return '';
    }

    final fullPool = activeSets.join();
    final resultChars = <String>[];

    // Guarantee at least 1 character from each chosen character set
    for (final set in activeSets) {
      if (resultChars.length < length) {
        resultChars.add(set[_secureRandom.nextInt(set.length)]);
      }
    }

    // Fill the remainder of the length
    while (resultChars.length < length) {
      resultChars.add(fullPool[_secureRandom.nextInt(fullPool.length)]);
    }

    // Securely shuffle results using Fisher-Yates
    for (var i = resultChars.length - 1; i > 0; i--) {
      final n = _secureRandom.nextInt(i + 1);
      final temp = resultChars[i];
      resultChars[i] = resultChars[n];
      resultChars[n] = temp;
    }

    return resultChars.join();
  }

  /// Calculates information entropy and estimated crack time for a given password
  static PasswordStrengthResult evaluateStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrengthResult(
        entropyBits: 0,
        level: PasswordStrengthLevel.weak,
        crackTimeEstimate: 'Instant',
        color: Colors.red,
        label: 'Empty',
      );
    }

    var poolSize = 0;
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasDigits = RegExp(r'[0-9]').hasMatch(password);
    final hasSymbols = RegExp(r'[^a-zA-Z0-9]').hasMatch(password);

    if (hasLower) poolSize += 26;
    if (hasUpper) poolSize += 26;
    if (hasDigits) poolSize += 10;
    if (hasSymbols) poolSize += 32;

    if (poolSize == 0) poolSize = 1;

    // E = L * log2(poolSize)
    final entropy = password.length * (log(poolSize) / ln2);

    PasswordStrengthLevel level;
    Color color;
    String label;
    String crackTime;

    if (entropy < 35) {
      level = PasswordStrengthLevel.weak;
      color = Colors.redAccent;
      label = 'Weak';
      crackTime = '< a few seconds';
    } else if (entropy < 55) {
      level = PasswordStrengthLevel.fair;
      color = Colors.orangeAccent;
      label = 'Fair';
      crackTime = 'a few hours to days';
    } else if (entropy < 75) {
      level = PasswordStrengthLevel.strong;
      color = Colors.lightGreenAccent;
      label = 'Strong';
      crackTime = 'several months to years';
    } else {
      level = PasswordStrengthLevel.veryStrong;
      color = Colors.greenAccent;
      label = 'Very Strong';
      crackTime = 'centuries';
    }

    return PasswordStrengthResult(
      entropyBits: entropy,
      level: level,
      crackTimeEstimate: crackTime,
      color: color,
      label: label,
    );
  }

  /// Generates a passphrase from the wordlist with capitalization, separators, and optional numbers/symbols
  static String generatePassphrase({
    required int wordCount,
    required String separator,
    required bool capitalize,
    required bool includeNumber,
  }) {
    if (wordCount <= 0) return '';
    final list = WordLists.passphraseWords;
    final words = <String>[];

    for (var i = 0; i < wordCount; i++) {
      var word = list[_secureRandom.nextInt(list.length)];
      if (capitalize) {
        word = word[0].toUpperCase() + word.substring(1);
      }
      words.add(word);
    }

    if (includeNumber) {
      final randNum = _secureRandom.nextInt(100).toString();
      final insertIndex = _secureRandom.nextInt(words.length + 1);
      words.insert(insertIndex, randNum);
    }

    return words.join(separator);
  }

  /// Generates a cryptographically secure PIN of arbitrary length
  static String generatePin({
    required int length,
    bool alphanumeric = false,
    bool avoidPatterns = false,
  }) {
    if (length <= 0) return '';
    final pool = alphanumeric ? '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' : '0123456789';

    // Maximum 50 attempts to avoid weak sequences if avoidPatterns is enabled
    var attempts = 0;
    while (attempts < 50) {
      attempts++;
      final buffer = StringBuffer();
      for (var i = 0; i < length; i++) {
        buffer.write(pool[_secureRandom.nextInt(pool.length)]);
      }
      final candidate = buffer.toString();

      if (!avoidPatterns || !isWeakPin(candidate)) {
        return candidate;
      }
    }

    // Fallback if patterns could not be avoided within attempt limit
    final fallback = StringBuffer();
    for (var i = 0; i < length; i++) {
      fallback.write(pool[_secureRandom.nextInt(pool.length)]);
    }
    return fallback.toString();
  }

  /// Checks if a PIN has obvious weak patterns (repeated digits, ascending/descending sequences, or common PINs)
  static bool isWeakPin(String pin) {
    if (pin.length <= 2) return false;

    // Check all identical characters (e.g. 1111, 0000)
    final firstChar = pin[0];
    if (pin.split('').every((c) => c == firstChar)) {
      return true;
    }

    // Check strictly numeric ascending/descending sequences (e.g. 1234, 4321, 6789)
    if (RegExp(r'^\d+$').hasMatch(pin)) {
      var isAscending = true;
      var isDescending = true;
      for (var i = 0; i < pin.length - 1; i++) {
        final current = int.parse(pin[i]);
        final next = int.parse(pin[i + 1]);
        if (next != (current + 1) % 10) isAscending = false;
        if (next != (current - 1 + 10) % 10) isDescending = false;
      }
      if (isAscending || isDescending) return true;

      // Check alternating sequences like 1212, 6969
      if (pin.length == 4 && pin[0] == pin[2] && pin[1] == pin[3]) {
        return true;
      }

      // Check common 4-digit PINs & birth years (1950 - 2030)
      if (pin.length == 4) {
        const commonPins = {'1234', '0000', '1111', '1212', '7777', '1004', '2000', '4321', '2222', '1313'};
        if (commonPins.contains(pin)) return true;
        final year = int.tryParse(pin);
        if (year != null && year >= 1950 && year <= 2030) {
          return true;
        }
      }
    }

    return false;
  }

  /// Formats PIN into spaced or hyphenated chunks for readability (e.g. 123-456 or 1234-5678)
  static String formatPin(String pin, {int chunkSize = 3, String separator = '-'}) {
    if (pin.length <= chunkSize) return pin;
    final chunks = <String>[];
    for (var i = 0; i < pin.length; i += chunkSize) {
      final end = (i + chunkSize < pin.length) ? i + chunkSize : pin.length;
      chunks.add(pin.substring(i, end));
    }
    return chunks.join(separator);
  }
}
