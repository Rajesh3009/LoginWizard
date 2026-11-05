import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/password_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../widgets/credential_display_card.dart';
import '../widgets/entropy_strength_meter.dart';
import '../widgets/passphrase_options_card.dart';
import '../widgets/password_options_card.dart';
import 'password_history_view.dart';

/// Screen for generating secure character passwords and Diceware passphrases
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

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generated Result Display Card
            CredentialDisplayCard(
              text: password,
              itemType: 'Password',
              hintText: 'Tap Generate to create password',
              bottomWidget: EntropyStrengthMeter(password: password),
            ),
            const SizedBox(height: 10),

            // Main Generate Action Button
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

            // Tab Switcher (Password vs Passphrase)
            TabBar(
              controller: _tabController,
              onTap: (_) => setState(() {}),
              tabs: const [
                Tab(icon: Icon(Icons.password), text: 'Password'),
                Tab(icon: Icon(Icons.short_text), text: 'Passphrase'),
              ],
            ),
            const SizedBox(height: 12),

            // Active Tab Form Options
            if (_tabController.index == 0)
              PasswordOptionsCard(
                length: _passwordLength,
                lengthController: _passwordLengthController,
                checkboxValues: _checkboxValues,
                customExcludeController: _customExcludeController,
                onLengthChanged: (val) {
                  setState(() {
                    _passwordLength = val;
                    _passwordLengthController.text = '$val';
                  });
                  _saveValues();
                },
                onCheckboxChanged: (key, val) {
                  setState(() => _checkboxValues[key] = val);
                  _saveValues();
                },
                onValuesChanged: _saveValues,
              )
            else
              PassphraseOptionsCard(
                length: _passphraseLength,
                lengthController: _passphraseLengthController,
                separatorController: _separatorController,
                checkboxValues: _checkboxValues,
                onLengthChanged: (val) {
                  setState(() {
                    _passphraseLength = val;
                    _passphraseLengthController.text = '$val';
                  });
                  _saveValues();
                },
                onCheckboxChanged: (key, val) {
                  setState(() => _checkboxValues[key] = val);
                  _saveValues();
                },
                onValuesChanged: _saveValues,
              ),

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
}
