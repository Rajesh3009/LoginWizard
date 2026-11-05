import 'package:flutter/material.dart';
import '../utils/clipboard_service.dart';

/// Reusable display card for generated credentials (Password, Username, PIN)
class CredentialDisplayCard extends StatelessWidget {
  final String text;
  final String hintText;
  final String itemType;
  final double letterSpacing;
  final double fontSize;
  final Widget? bottomWidget;
  final Widget? trailingAction;

  const CredentialDisplayCard({
    super.key,
    required this.text,
    this.hintText = 'Tap Generate to create',
    required this.itemType,
    this.letterSpacing = 1.0,
    this.fontSize = 18.0,
    this.bottomWidget,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = text.isEmpty;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SelectableText(
                    isEmpty ? hintText : text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      letterSpacing: isEmpty ? 0 : letterSpacing,
                      fontWeight: FontWeight.bold,
                      color: isEmpty ? Colors.grey : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy to clipboard',
                  onPressed: isEmpty
                      ? null
                      : () => ClipboardService.copyToClipboard(
                            context,
                            text,
                            itemType: itemType,
                          ),
                ),
                if (trailingAction != null) trailingAction!,
              ],
            ),
            if (!isEmpty) ...[
              const Divider(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Length: ${text.length} characters',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (bottomWidget != null) ...[
                const SizedBox(height: 6),
                bottomWidget!,
              ],
            ],
          ],
        ),
      ),
    );
  }
}
