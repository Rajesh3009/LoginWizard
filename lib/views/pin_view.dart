
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/provider/pin_provider.dart';
import 'package:loginwizard/provider/sharedpref_provider.dart';
import 'package:loginwizard/utils/conts.dart';

import 'pin_history_view.dart';

class PinView extends ConsumerStatefulWidget {
  const PinView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinViewState();
}

class _PinViewState extends ConsumerState<PinView> {
  int _pinLength = 3;

  @override
  initState() {
    super.initState();
    ref
        .read(sharedPreferencesProvider)
        .getInt(pinLengthKey)
        .then((value) => setState(() {
              _pinLength = (value ?? 3);
            }));
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: SelectableText(
                        ref.watch(pinProvider),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                         Clipboard.setData(
                            ClipboardData(text: ref.read(pinProvider)));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Copied to clipboard"),
                        ));
                       
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Length of the PIN: "),
                DropdownButton<int>(
                  value: _pinLength,
                  items: List.generate(8, (index) => index + 3)
                      .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _pinLength = value ?? 3;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  ref.read(pinProvider.notifier).generatePin(_pinLength);
                  ref
                      .read(sharedPreferencesProvider)
                      .addInt(pinLengthKey, _pinLength);
                },
                child: Text("Generate PIN")),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PinHistoryView()));
                },
                child: Text("History")),
          ],
        ),
      ),
    );
  }
}
