import 'package:flutter/material.dart';
import '../utils/security_utils.dart';

/// Visual entropy bar and crack time estimation display
class EntropyStrengthMeter extends StatelessWidget {
  final String password;

  const EntropyStrengthMeter({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = SecurityUtils.evaluateStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Text(
          'Estimated crack time: ${strength.crackTimeEstimate}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}
