import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/pin_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/clipboard_service.dart';
import '../utils/constants.dart';
import '../utils/security_utils.dart';
import '../widgets/credential_display_card.dart';
import '../widgets/pin_options_card.dart';
import 'pin_history_view.dart';

/// Screen for generating arbitrary-length numeric and alphanumeric PINs
class PinView extends ConsumerStatefulWidget {
  const PinView({super.key});

  @override
  ConsumerState<PinView> createState() => _PinViewState();
}

class _PinViewState extends ConsumerState<PinView> {
  int _pinLength = 6;
  bool _alphanumeric = false;
  bool _avoidPatterns = true;
  bool _chunkFormat = true;
  int _chunkSize = 3;
  late SharedPreferencesAsync _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferencesAsync();
    _loadSavedValues();
  }

  Future<void> _loadSavedValues() async {
    final len = await _prefs.getInt(pinLengthKey) ?? 6;
    final alpha = await _prefs.getBool(pinAlphanumericKey) ?? false;
    final avoid = await _prefs.getBool(pinAvoidPatternsKey) ?? true;
    final chunk = await _prefs.getBool(pinChunkFormatKey) ?? true;

    if (mounted) {
      setState(() {
        _pinLength = len;
        _alphanumeric = alpha;
        _avoidPatterns = avoid;
        _chunkFormat = chunk;
      });
    }
  }

  Future<void> _saveValues() async {
    await _prefs.setInt(pinLengthKey, _pinLength);
    await _prefs.setBool(pinAlphanumericKey, _alphanumeric);
    await _prefs.setBool(pinAvoidPatternsKey, _avoidPatterns);
    await _prefs.setBool(pinChunkFormatKey, _chunkFormat);
  }

  void _generate() {
    _saveValues();
    ref.read(pinProvider.notifier).generatePin(
          length: _pinLength,
          alphanumeric: _alphanumeric,
          avoidPatterns: _avoidPatterns,
        );
  }

  @override
  Widget build(BuildContext context) {
    final pin = ref.watch(pinProvider);
    final formattedPin = _chunkFormat
        ? SecurityUtils.formatPin(pin, chunkSize: _chunkSize)
        : pin;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generated Result Display Card
            CredentialDisplayCard(
              text: formattedPin,
              itemType: 'PIN',
              hintText: 'Tap Generate to create PIN',
              letterSpacing: 3.0,
              fontSize: 22.0,
              bottomWidget: (_chunkFormat && formattedPin != pin)
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                        icon: const Icon(Icons.content_copy, size: 14),
                        label: const Text('Copy Unformatted', style: TextStyle(fontSize: 12)),
                        onPressed: () => ClipboardService.copyToClipboard(
                          context,
                          pin,
                          itemType: 'Raw PIN',
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 10),

            // Main Generate Action Button
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Generate PIN', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _generate,
            ),
            const SizedBox(height: 14),

            // PIN Length Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('PIN Length:', style: TextStyle(fontWeight: FontWeight.w600)),
                Text('$_pinLength digits', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: _pinLength.toDouble(),
              min: 3,
              max: 32,
              divisions: 29,
              label: '$_pinLength',
              onChanged: (val) {
                setState(() => _pinLength = val.toInt());
                _saveValues();
              },
            ),
            const SizedBox(height: 10),

            // PIN Options Card
            PinOptionsCard(
              avoidPatterns: _avoidPatterns,
              alphanumeric: _alphanumeric,
              chunkFormat: _chunkFormat,
              chunkSize: _chunkSize,
              onAvoidPatternsChanged: (val) {
                setState(() => _avoidPatterns = val);
                _saveValues();
              },
              onAlphanumericChanged: (val) {
                setState(() => _alphanumeric = val);
                _saveValues();
              },
              onChunkFormatChanged: (val) {
                setState(() => _chunkFormat = val);
                _saveValues();
              },
              onChunkSizeChanged: (val) {
                setState(() => _chunkSize = val);
              },
            ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('View PIN History'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PinHistoryView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
