import 'package:flutter/material.dart';
import '../provider/username_provider.dart';

/// Palette of clickable chips to append new tokens to the username pattern
class TokenPalette extends StatelessWidget {
  final Function(PatternTokenType type, [String value]) onAddToken;

  const TokenPalette({super.key, required this.onAddToken});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add Pattern Blocks:', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Adjective'),
              onPressed: () => onAddToken(PatternTokenType.adjective),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Noun'),
              onPressed: () => onAddToken(PatternTokenType.noun),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('2-Digit Num'),
              onPressed: () => onAddToken(PatternTokenType.number, '2'),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('3-Digit Num'),
              onPressed: () => onAddToken(PatternTokenType.number, '3'),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Year'),
              onPressed: () => onAddToken(PatternTokenType.year),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Separator (_)'),
              onPressed: () => onAddToken(PatternTokenType.separator, '_'),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Separator (.)'),
              onPressed: () => onAddToken(PatternTokenType.separator, '.'),
            ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Separator (-)'),
              onPressed: () => onAddToken(PatternTokenType.separator, '-'),
            ),
          ],
        ),
      ],
    );
  }
}
