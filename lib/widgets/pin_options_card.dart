import 'package:flutter/material.dart';

/// Form options for PIN generation (avoid patterns, alphanumeric, chunking)
class PinOptionsCard extends StatelessWidget {
  final bool avoidPatterns;
  final bool alphanumeric;
  final bool chunkFormat;
  final int chunkSize;
  final ValueChanged<bool> onAvoidPatternsChanged;
  final ValueChanged<bool> onAlphanumericChanged;
  final ValueChanged<bool> onChunkFormatChanged;
  final ValueChanged<int> onChunkSizeChanged;

  const PinOptionsCard({
    super.key,
    required this.avoidPatterns,
    required this.alphanumeric,
    required this.chunkFormat,
    required this.chunkSize,
    required this.onAvoidPatternsChanged,
    required this.onAlphanumericChanged,
    required this.onChunkFormatChanged,
    required this.onChunkSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Avoid Weak Patterns'),
              subtitle: const Text('Rejects repeating digits (0000), sequences (1234), and common PINs'),
              value: avoidPatterns,
              onChanged: onAvoidPatternsChanged,
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('Alphanumeric PIN'),
              subtitle: const Text('Include uppercase letters (A-Z) in addition to digits'),
              value: alphanumeric,
              onChanged: onAlphanumericChanged,
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('Chunk Formatting'),
              subtitle: Text('Group digits with hyphens (e.g. ${chunkSize == 3 ? "123-456" : "1234-5678"})'),
              value: chunkFormat,
              onChanged: onChunkFormatChanged,
            ),
            if (chunkFormat) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    const Text('Chunk size:'),
                    ChoiceChip(
                      label: const Text('3 digits'),
                      selected: chunkSize == 3,
                      onSelected: (val) {
                        if (val) onChunkSizeChanged(3);
                      },
                    ),
                    ChoiceChip(
                      label: const Text('4 digits'),
                      selected: chunkSize == 4,
                      onSelected: (val) {
                        if (val) onChunkSizeChanged(4);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
