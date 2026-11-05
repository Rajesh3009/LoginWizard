import 'package:flutter/material.dart';
import '../provider/username_provider.dart';

/// Container displaying active username pattern blocks with deletion chips
class PatternBlocksCard extends StatelessWidget {
  final List<PatternToken> tokens;
  final ValueChanged<int> onRemoveToken;
  final VoidCallback onClearAll;

  const PatternBlocksCard({
    super.key,
    required this.tokens,
    required this.onRemoveToken,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(120),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pattern Blocks Sequence:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (tokens.isNotEmpty)
                  TextButton(
                    onPressed: onClearAll,
                    child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (tokens.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No blocks added. Tap chips below to build pattern.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(tokens.length, (index) {
                  final token = tokens[index];
                  Color chipColor;
                  switch (token.type) {
                    case PatternTokenType.adjective:
                      chipColor = Colors.teal.withAlpha(60);
                      break;
                    case PatternTokenType.noun:
                      chipColor = Colors.indigo.withAlpha(60);
                      break;
                    case PatternTokenType.number:
                      chipColor = Colors.amber.withAlpha(60);
                      break;
                    case PatternTokenType.year:
                      chipColor = Colors.deepOrange.withAlpha(60);
                      break;
                    case PatternTokenType.separator:
                      chipColor = Colors.purple.withAlpha(60);
                      break;
                  }

                  return Chip(
                    backgroundColor: chipColor,
                    label: Text(token.label),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => onRemoveToken(index),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
