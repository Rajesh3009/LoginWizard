import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  ConsumerState<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      'Password',
                      textAlign: TextAlign.center,
                    )),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: 'username'));
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
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Password'),
                Tab(text: 'Passphrase'),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _passwordBuilder(),
                  ),
                  const Text('Passphrase Page', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Generate')),
          ],
        ),
      ),
    );
  }

  Widget _passwordBuilder() {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3), // Limit to 3 digits
          ],
          decoration: InputDecoration(
            labelText: 'Length (4-128)',
            hintText: 'Enter the length of the password',
            errorText: _validateLength(),
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
            customCheckBox('A-Z', false, (bool value) {}),
            customCheckBox('a-z', false, (bool value) {}),
            customCheckBox('0-9', false, (bool value) {}),
            customCheckBox(r'!@#$*', false, (bool value) {}),
          ],
        )
      ],
    );
  }

  Widget customCheckBox(String text, bool value, Function(bool) onChanged) {
    return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox.adaptive(value: value, onChanged: onChanged(value)),
              Text(text),
            ],
          );
  }

  String? _validateLength() {
    return _errorText;
  }
}
