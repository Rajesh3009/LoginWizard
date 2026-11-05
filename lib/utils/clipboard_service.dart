import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ClipboardService {
  static Timer? _clearTimer;
  static String? _lastCopiedText;

  static Future<void> copyToClipboard(
    BuildContext context,
    String text, {
    String itemType = 'Text',
  }) async {
    if (text.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));
    _lastCopiedText = text;

    final prefs = SharedPreferencesAsync();
    final clearSeconds = await prefs.getInt(clipboardAutoClearSecondsKey) ?? 0;

    _clearTimer?.cancel();

    if (clearSeconds > 0) {
      _clearTimer = Timer(Duration(seconds: clearSeconds), () async {
        final currentData = await Clipboard.getData(Clipboard.kTextPlain);
        if (currentData?.text == _lastCopiedText) {
          await Clipboard.setData(const ClipboardData(text: ''));
        }
      });
    }

    if (context.mounted) {
      final msg = clearSeconds > 0
          ? '$itemType copied! Auto-clears in $clearSeconds seconds.'
          : '$itemType copied to clipboard';
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
