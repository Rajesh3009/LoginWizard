import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/password_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/conts.dart';
import 'password_history_view.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  ConsumerState<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _passwordLengthController = TextEditingController();
  final _passphraseLengthController = TextEditingController();
  final _separatorController = TextEditingController();
  String? _errorText;
  late SharedPreferences _prefs;
  Map<String, bool> _checkboxValues = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSavedValues();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _saveValues();
    _passphraseLengthController.dispose();
    _separatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final password = ref.watch(passwordProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: SelectableText(
                      password,
                      textAlign: TextAlign.center,
                    )),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: password));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            ),
            if (password.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Length: ${password.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Password'),
                Tab(text: 'Passphrase'),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _passwordBuilder(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _passphraseBuilder(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  if (_tabController.index == 0) {
                    ref.read(passwordProvider.notifier).generatePassword(
                        int.parse(_passwordLengthController.text),
                        _checkboxValues[smallAlfaKey]!,
                        _checkboxValues[capAlfaKey]!,
                        _checkboxValues[numberskey]!,
                        _checkboxValues[specialCharsKey]!);
                  } else {
                    ref.read(passwordProvider.notifier).generatePassphrase(
                        int.parse(_passphraseLengthController.text),
                        _separatorController.text,
                        _checkboxValues[passphraseCapitalizeKey]!,
                        _checkboxValues[passphraseNumbersKey]!);
                  }
                },
                child: Text('Generate')),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordHistoryView()));
                },
                child: Text('Password History')),
          ],
        ),
      ),
    );
  }

  Widget _passwordBuilder() {
    return Column(
      children: [
        TextField(
          controller: _passwordLengthController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3), // Limit to 3 digits
          ],
          decoration: InputDecoration(
            labelText: 'Length (4-128)',
            hintText: 'Enter the length of the password',
            errorText: _errorText,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              int length = int.parse(value);
              if (length < 4) {
                setState(() => _errorText = 'Minimum length is 4');
              } else if (length > 128) {
                setState(() => _errorText = 'Maximum length is 128');
              } else {
                setState(() => _errorText = null);
              }
            }
          },
        ),
        SizedBox(height: 10),
        Text('Select the options to include'),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: [
            customCheckBox('A-Z', _checkboxValues[capAlfaKey] ?? false,
                (bool value) {
              setState(() {
                _checkboxValues[capAlfaKey] = value;
              });
            }),
            customCheckBox('a-z', _checkboxValues[smallAlfaKey] ?? false,
                (bool value) {
              setState(() {
                _checkboxValues[smallAlfaKey] = value;
              });
            }),
            customCheckBox('0-9', _checkboxValues[numberskey] ?? false,
                (bool value) {
              setState(() {
                _checkboxValues[numberskey] = value;
              });
            }),
            customCheckBox(r'!@#$*', _checkboxValues[specialCharsKey] ?? false,
                (bool value) {
              setState(() {
                _checkboxValues[specialCharsKey] = value;
              });
            }),
          ],
        )
      ],
    );
  }

  Widget _passphraseBuilder() {
    return Column(
      children: [
        TextField(
          controller: _passphraseLengthController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: InputDecoration(
            labelText: 'Length (2-10)',
            hintText: 'Enter the number of words',
            errorText: _errorText,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              int length = int.parse(value);
              if (length < 2) {
                setState(() => _errorText = 'Minimum length is 2');
              } else if (length > 10) {
                setState(() => _errorText = 'Maximum length is 10');
              } else {
                setState(() => _errorText = null);
              }
            }
          },
        ),
        TextField(
          controller: _separatorController,
          decoration: InputDecoration(
            labelText: 'Separator',
            hintText: 'Enter the separator',
          ),
        ),
        Wrap(
          children: [
            customCheckBox(
                'Capitalise', _checkboxValues[passphraseCapitalizeKey] ?? false,
                (bool value) {
              setState(() {
                _checkboxValues[passphraseCapitalizeKey] = value;
              });
            }),
            customCheckBox('Include number',
                _checkboxValues[passphraseNumbersKey] ?? false, (bool value) {
              setState(() {
                _checkboxValues[passphraseNumbersKey] = value;
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget customCheckBox(String text, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
        Text(text),
      ],
    );
  }

  // String? _validateLength() {
  //   return _errorText;
  // }

  Future<void> _loadSavedValues() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _checkboxValues = {
        smallAlfaKey: _prefs.getBool(smallAlfaKey) ?? false,
        capAlfaKey: _prefs.getBool(capAlfaKey) ?? false,
        numberskey: _prefs.getBool(numberskey) ?? false,
        specialCharsKey: _prefs.getBool(specialCharsKey) ?? false,
        passphraseCapitalizeKey:
            _prefs.getBool(passphraseCapitalizeKey) ?? false,
        passphraseNumbersKey: _prefs.getBool(passphraseNumbersKey) ?? false,
      };
      _passwordLengthController.text =
          _prefs.getString(passwordLengthKey) ?? '4';

      _passphraseLengthController.text =
          _prefs.getString(passphraseLengthKey) ?? '2';
      _separatorController.text =
          _prefs.getString(passphraseSeparatorKey) ?? '';
    });
  }

  Future<void> _saveValues() async {
    //Password
    await _prefs.setBool(smallAlfaKey, _checkboxValues[smallAlfaKey]!);
    await _prefs.setBool(capAlfaKey, _checkboxValues[capAlfaKey]!);
    await _prefs.setBool(numberskey, _checkboxValues[numberskey]!);
    await _prefs.setBool(specialCharsKey, _checkboxValues[specialCharsKey]!);
    await _prefs.setString(passwordLengthKey, _passwordLengthController.text);
    //Passphrase
    await _prefs.setBool(
        passphraseCapitalizeKey, _checkboxValues[passphraseCapitalizeKey]!);
    await _prefs.setBool(
        passphraseNumbersKey, _checkboxValues[passphraseNumbersKey]!);
    await _prefs.setString(
        passphraseLengthKey, _passphraseLengthController.text);
    await _prefs.setString(passphraseSeparatorKey, _separatorController.text);
  }
}
