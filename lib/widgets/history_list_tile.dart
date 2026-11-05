import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/clipboard_service.dart';

class HistoryListTile extends StatelessWidget {
  final String text;
  final DateTime? createdAt;
  final int id;
  final bool isFavorite;
  final WidgetRef ref;
  final ProviderOrFamily provider;
  final Function(int id) deleteItemAction;
  final Function(int id, bool current) toggleFavoriteAction;

  const HistoryListTile({
    super.key,
    required this.text,
    required this.createdAt,
    required this.id,
    this.isFavorite = false,
    required this.ref,
    required this.provider,
    required this.deleteItemAction,
    required this.toggleFavoriteAction,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}-$month-$day $hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: SelectableText(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: createdAt != null ? Text(_formatDate(createdAt)) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
              onPressed: () {
                toggleFavoriteAction(id, isFavorite);
                ref.invalidate(provider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy',
              onPressed: () {
                ClipboardService.copyToClipboard(context, text);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () {
                deleteItemAction(id);
                ref.invalidate(provider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item deleted'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
