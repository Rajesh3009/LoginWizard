import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/utils/conts.dart';

import '../provider/sharedpref_provider.dart';
import '../provider/username_provider.dart';
import 'username_history_view.dart';

class UsernameView extends ConsumerStatefulWidget {
  const UsernameView({super.key});

  @override
  ConsumerState<UsernameView> createState() => _UsernameViewState();
}

class _UsernameViewState extends ConsumerState<UsernameView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _formatController = TextEditingController();
  var numLen = 1;
  final List<int> _numbers = List.generate(10, (index) => index + 1);

  @override
  void dispose() {
    _formatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref
        .read(sharedPreferencesProvider)
        .getString(usernameFormatKey)
        .then((value) => _formatController.text = value);

    ref.read(sharedPreferencesProvider).getInt(numberLengthKey).then((value) {
      numLen = value ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(usernameProvider);
    final prefs = ref.watch(sharedPreferencesProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: SelectableText(username,textAlign: TextAlign.center,)),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Specify the format of the username'),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _formatController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a format';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'w:w:n',
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('W=Word, w = word, n = number'),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Length of the number: '),
                DropdownButton<int>(
                  value: numLen,
                  onChanged: (int? newValue) {
                    setState(() {
                      numLen = newValue ?? 1;
                    });
                    prefs.addInt(numberLengthKey, newValue!);
                  },
                  items: _numbers.map((int number) {
                    return DropdownMenuItem<int>(
                      value: number,
                      child: Text(number.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() != null) {
                  prefs.addString('username_format', _formatController.text);
                  ref
                      .read(usernameProvider.notifier)
                      .generateUsername(_formatController.text,numLen);
                }
              },
              child: const Text('Generate'),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UsernameHistory()));
            }, child: Text('History')),
          ],
        ),
      ),
    );
  }
}
