import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/password_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/clipboard_service.dart';
import '../utils/conts.dart';
import '../utils/security_utils.dart';
import 'password_history_view.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  ConsumerState<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _passwordLengthController = TextEditingController();
  final _passphraseLengthController = TextEditingController();
  final _separatorController = TextEditingController(text: '-');
  final _customExcludeController = TextEditingController();

  int _passwordLength = 16;
  int _passphraseLength = 4;
  late SharedPreferencesAsync _prefs;

  Map<String, bool> _checkboxValues = {
    smallAlfaKey: true,
    capAlfaKey: true,
    numberskey: true,
    specialCharsKey: true,
    excludeAmbiguousKey: false,
    passphraseCapitalizeKey: true,
    passphraseNumbersKey: false,
  };

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferencesAsync();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _passwordLengthController.text = '16';
    _passphraseLengthController.text = '4';
    _loadSavedValues();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _saveValues();
    _passwordLengthController.dispose();
    _passphraseLengthController.dispose();
    _separatorController.dispose();
    _customExcludeController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedValues() async {
    final lower = await _prefs.getBool(smallAlfaKey) ?? true;
    final upper = await _prefs.getBool(capAlfaKey) ?? true;
    final num = await _prefs.getBool(numberskey) ?? true;
    final sym = await _prefs.getBool(specialCharsKey) ?? true;
    final ambig = await _prefs.getBool(excludeAmbiguousKey) ?? false;
    final customEx = await _prefs.getString(customExcludeCharsKey) ?? '';
    final passLenStr = await _prefs.getString(passwordLengthKey) ?? '16';
    final phraseLenStr = await _prefs.getString(passphraseLengthKey) ?? '4';
    final sep = await _prefs.getString(passphraseSeparatorKey) ?? '-';
    final cap = await _prefs.getBool(passphraseCapitalizeKey) ?? true;
    final phraseNum = await _prefs.getBool(passphraseNumbersKey) ?? false;

    if (mounted) {
      setState(() {
        _checkboxValues = {
          smallAlfaKey: lower,
          capAlfaKey: upper,
          numberskey: num,
          specialCharsKey: sym,
          excludeAmbiguousKey: ambig,
          passphraseCapitalizeKey: cap,
          passphraseNumbersKey: phraseNum,
        };
        _customExcludeController.text = customEx;
        _passwordLength = int.tryParse(passLenStr) ?? 16;
        _passwordLengthController.text = _passwordLength.toString();
        _passphraseLength = int.tryParse(phraseLenStr) ?? 4;
        _passphraseLengthController.text = _passphraseLength.toString();
        _separatorController.text = sep;
      });
    }
  }

  Future<void> _saveValues() async {
    await _prefs.setBool(smallAlfaKey, _checkboxValues[smallAlfaKey] ?? true);
    await _prefs.setBool(capAlfaKey, _checkboxValues[capAlfaKey] ?? true);
    await _prefs.setBool(numberskey, _checkboxValues[numberskey] ?? true);
    await _prefs.setBool(specialCharsKey, _checkboxValues[specialCharsKey] ?? true);
    await _prefs.setBool(excludeAmbiguousKey, _checkboxValues[excludeAmbiguousKey] ?? false);
    await _prefs.setString(customExcludeCharsKey, _customExcludeController.text);
    await _prefs.setString(passwordLengthKey, _passwordLength.toString());
    await _prefs.setString(passphraseLengthKey, _passphraseLength.toString());
    await _prefs.setString(passphraseSeparatorKey, _separatorController.text);
    await _prefs.setBool(passphraseCapitalizeKey, _checkboxValues[passphraseCapitalizeKey] ?? true);
    await _prefs.setBool(passphraseNumbersKey, _checkboxValues[passphraseNumbersKey] ?? false);
  }

  void _generate() {
    _saveValues();
    if (_tabController.index == 0) {
      ref.read(passwordProvider.notifier).generatePassword(
            length: _passwordLength,
            includeLowercase: _checkboxValues[smallAlfaKey] ?? true,
            includeUppercase: _checkboxValues[capAlfaKey] ?? true,
            includeNumbers: _checkboxValues[numberskey] ?? true,
            includeSymbols: _checkboxValues[specialCharsKey] ?? true,
            excludeAmbiguous: _checkboxValues[excludeAmbiguousKey] ?? false,
            customExclude: _customExcludeController.text,
          );
    } else {
      ref.read(passwordProvider.notifier).generatePassphrase(
            length: _passphraseLength,
            separator: _separatorController.text,
            capitalize: _checkboxValues[passphraseCapitalizeKey] ?? true,
            includeNumber: _checkboxValues[passphraseNumbersKey] ?? false,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = ref.watch(passwordProvider);
    final strength = SecurityUtils.evaluateStrength(password);

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
                            password.isEmpty ? 'Tap Generate to create password' : password,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: password.isEmpty ? 0 : 1.2,
                              fontWeight: FontWeight.bold,
                              color: password.isEmpty ? Colors.grey : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy to clipboard',
                          onPressed: password.isEmpty
                              ? null
                              : () => ClipboardService.copyToClipboard(
                                    context,
                                    password,
                                    itemType: 'Password',
                                  ),
                        ),
                      ],
                    ),
                    if (password.isNotEmpty) ...[
                      const Divider(height: 16),
                      // Strength & Entropy Meter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Strength: ${strength.label}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: strength.color,
                            ),
                          ),
                          Text(
                            '${strength.entropyBits.toStringAsFixed(1)} bits (${password.length} chars)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (strength.entropyBits / 100).clamp(0.05, 1.0),
                          backgroundColor: Colors.grey.withAlpha(50),
                          valueColor: AlwaysStoppedAnimation<Color>(strength.color),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Estimated crack time: ${strength.crackTimeEstimate}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(
                _tabController.index == 0 ? 'Generate Password' : 'Generate Passphrase',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _generate,
            ),
            const SizedBox(height: 14),

            // Tabs for Password vs Passphrase
            TabBar(
              controller: _tabController,
              onTap: (_) => setState(() {}),
              tabs: const [
                Tab(icon: Icon(Icons.password), text: 'Password'),
                Tab(icon: Icon(Icons.short_text), text: 'Passphrase'),
              ],
            ),
            const SizedBox(height: 12),

            // Tab Content
            if (_tabController.index == 0) _passwordBuilder() else _passphraseBuilder(),

            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.history),
              label: const Text('View Password History'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PasswordHistoryView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Length Slider & Input
        Row(
          children: [
            Expanded(
              child: Text(
                'Password Length: $_passwordLength',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 60,
              child: TextField(
                controller: _passwordLengthController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed >= 4 && parsed <= 128) {
                    setState(() {
                      _passwordLength = parsed;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: _passwordLength.toDouble(),
          min: 4,
          max: 128,
          divisions: 124,
          label: '$_passwordLength',
          onChanged: (val) {
            setState(() {
              _passwordLength = val.toInt();
              _passwordLengthController.text = '$_passwordLength';
            });
          },
        ),

        const SizedBox(height: 8),
        const Text('Character Sets:', style: TextStyle(fontWeight: FontWeight.w600)),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildCheckbox('A-Z', capAlfaKey),
            _buildCheckbox('a-z', smallAlfaKey),
            _buildCheckbox('0-9', numberskey),
            _buildCheckbox(r'!@#$%^&*', specialCharsKey),
          ],
        ),

        const SizedBox(height: 8),
        const Text('Exclusions & Filters:', style: TextStyle(fontWeight: FontWeight.w600)),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text('Exclude Ambiguous Characters (0, O, o, 1, l, I, |)'),
          value: _checkboxValues[excludeAmbiguousKey] ?? false,
          onChanged: (val) {
            setState(() {
              _checkboxValues[excludeAmbiguousKey] = val ?? false;
            });
            _saveValues();
          },
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _customExcludeController,
          decoration: const InputDecoration(
            labelText: 'Custom Characters to Exclude',
            hintText: r'e.g. "\ / ` ~',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveValues(),
        ),
      ],
    );
  }

  Widget _passphraseBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Word Count: $_passphraseLength',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                controller: _passphraseLengthController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val);
                  if (parsed != null && parsed >= 2 && parsed <= 12) {
                    setState(() {
                      _passphraseLength = parsed;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: _passphraseLength.toDouble(),
          min: 2,
          max: 10,
          divisions: 8,
          label: '$_passphraseLength',
          onChanged: (val) {
            setState(() {
              _passphraseLength = val.toInt();
              _passphraseLengthController.text = '$_passphraseLength';
            });
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _separatorController,
          decoration: const InputDecoration(
            labelText: 'Word Separator',
            hintText: 'e.g. - or _ or .',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => _saveValues(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            _buildCheckbox('Capitalize Words', passphraseCapitalizeKey),
            _buildCheckbox('Include Random Number', passphraseNumbersKey),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, String key) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _checkboxValues[key] ?? false,
          onChanged: (val) {
            setState(() {
              _checkboxValues[key] = val ?? false;
            });
            _saveValues();
          },
        ),
        Flexible(child: Text(label)),
      ],
    );
  }
}
