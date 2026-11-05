import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

/// Form controls for Diceware passphrase generation
class PassphraseOptionsCard extends StatelessWidget {
  final int length;
  final TextEditingController lengthController;
  final TextEditingController separatorController;
  final Map<String, bool> checkboxValues;
  final ValueChanged<int> onLengthChanged;
  final Function(String key, bool value) onCheckboxChanged;
  final VoidCallback onValuesChanged;

  const PassphraseOptionsCard({
    super.key,
    required this.length,
    required this.lengthController,
    required this.separatorController,
    required this.checkboxValues,
    required this.onLengthChanged,
    required this.onCheckboxChanged,
    required this.onValuesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Word Count: $length',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                controller: lengthController,
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
                    onLengthChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: length.toDouble(),
          min: 2,
          max: 10,
          divisions: 8,
          label: '$length',
          onChanged: (val) => onLengthChanged(val.toInt()),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: separatorController,
          decoration: const InputDecoration(
            labelText: 'Word Separator',
            hintText: 'e.g. - or _ or .',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => onValuesChanged(),
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
          value: checkboxValues[key] ?? false,
          onChanged: (val) => onCheckboxChanged(key, val ?? false),
        ),
        Text(label),
      ],
    );
  }
}
