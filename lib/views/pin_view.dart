import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/pin_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/clipboard_service.dart';
import '../utils/conts.dart';
import '../utils/security_utils.dart';
import 'pin_history_view.dart';

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
            // Result Display Card
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            formattedPin.isEmpty ? 'Tap Generate to create PIN' : formattedPin,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: formattedPin.isEmpty ? Colors.grey : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy PIN',
                          onPressed: pin.isEmpty
                              ? null
                              : () => ClipboardService.copyToClipboard(
                                    context,
                                    formattedPin,
                                    itemType: 'PIN',
                                  ),
                        ),
                      ],
                    ),
                    if (pin.isNotEmpty) ...[
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Length: ${pin.length} digits',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (_chunkFormat && formattedPin != pin)
                            TextButton.icon(
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
                        ],
                      ),
                    ],
                  ],
                ),
              ),
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
                setState(() {
                  _pinLength = val.toInt();
                });
                _saveValues();
              },
            ),
            const SizedBox(height: 10),

            // Toggles
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Avoid Weak Patterns'),
                      subtitle: const Text('Rejects repeating digits (0000), sequences (1234), and common PINs'),
                      value: _avoidPatterns,
                      onChanged: (val) {
                        setState(() => _avoidPatterns = val);
                        _saveValues();
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Alphanumeric PIN'),
                      subtitle: const Text('Include uppercase letters (A-Z) in addition to digits'),
                      value: _alphanumeric,
                      onChanged: (val) {
                        setState(() => _alphanumeric = val);
                        _saveValues();
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Chunk Formatting'),
                      subtitle: Text('Group digits with hyphens (e.g. ${_chunkSize == 3 ? "123-456" : "1234-5678"})'),
                      value: _chunkFormat,
                      onChanged: (val) {
                        setState(() => _chunkFormat = val);
                        _saveValues();
                      },
                    ),
                    if (_chunkFormat) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 6,
                          children: [
                            const Text('Chunk size:'),
                            ChoiceChip(
                              label: const Text('3 digits'),
                              selected: _chunkSize == 3,
                              onSelected: (val) {
                                if (val) setState(() => _chunkSize = 3);
                              },
                            ),
                            ChoiceChip(
                              label: const Text('4 digits'),
                              selected: _chunkSize == 4,
                              onSelected: (val) {
                                if (val) setState(() => _chunkSize = 4);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Generate PIN', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _generate,
            ),
            const SizedBox(height: 8),
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
