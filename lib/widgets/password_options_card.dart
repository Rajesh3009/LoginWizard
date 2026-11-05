import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

/// Form controls for standard character-based password generation
class PasswordOptionsCard extends StatelessWidget {
  final int length;
  final TextEditingController lengthController;
  final Map<String, bool> checkboxValues;
  final TextEditingController customExcludeController;
  final ValueChanged<int> onLengthChanged;
  final Function(String key, bool value) onCheckboxChanged;
  final VoidCallback onValuesChanged;

  const PasswordOptionsCard({
    super.key,
    required this.length,
    required this.lengthController,
    required this.checkboxValues,
    required this.customExcludeController,
    required this.onLengthChanged,
    required this.onCheckboxChanged,
    required this.onValuesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Length Slider & Input
        Row(
          children: [
            Expanded(
              child: Text(
                'Password Length: $length',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 60,
              child: TextField(
                controller: lengthController,
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
                    onLengthChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: length.toDouble(),
          min: 4,
          max: 128,
          divisions: 124,
          label: '$length',
          onChanged: (val) => onLengthChanged(val.toInt()),
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
          value: checkboxValues[excludeAmbiguousKey] ?? false,
          onChanged: (val) => onCheckboxChanged(excludeAmbiguousKey, val ?? false),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: customExcludeController,
          decoration: const InputDecoration(
            labelText: 'Custom Characters to Exclude',
            hintText: r'e.g. "\ / ` ~',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => onValuesChanged(),
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
