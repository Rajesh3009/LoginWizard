import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_list_tile.dart';

/// Generic scaffold view for history screens (Password, Username, PIN)
class BaseHistoryView<T> extends ConsumerStatefulWidget {
  final String title;
  final String clearDialogTitle;
  final String clearDialogMessage;
  final String emptyMessage;
  final String emptyStarredMessage;
  final ProviderListenable<AsyncValue<List<T>>> historyProvider;
  final ProviderOrFamily invalidateTarget;
  final String Function(T item) getText;
  final DateTime? Function(T item) getCreatedAt;
  final int Function(T item) getId;
  final bool Function(T item) getIsFavorite;
  final Future<void> Function(int id) onDelete;
  final Future<void> Function(int id, bool currentFavorite) onToggleFavorite;
  final Future<void> Function() onClearAll;

  const BaseHistoryView({
    super.key,
    required this.title,
    required this.clearDialogTitle,
    required this.clearDialogMessage,
    required this.emptyMessage,
    required this.emptyStarredMessage,
    required this.historyProvider,
    required this.invalidateTarget,
    required this.getText,
    required this.getCreatedAt,
    required this.getId,
    required this.getIsFavorite,
    required this.onDelete,
    required this.onToggleFavorite,
    required this.onClearAll,
  });

  @override
  ConsumerState<BaseHistoryView<T>> createState() => _BaseHistoryViewState<T>();
}

class _BaseHistoryViewState<T> extends ConsumerState<BaseHistoryView<T>> {
  bool _onlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(widget.historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              _onlyFavorites ? Icons.star : Icons.star_border,
              color: _onlyFavorites ? Colors.amber : null,
            ),
            tooltip: _onlyFavorites ? 'Show All' : 'Show Starred Only',
            onPressed: () {
              setState(() {
                _onlyFavorites = !_onlyFavorites;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear All',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(widget.clearDialogTitle),
                  content: Text(widget.clearDialogMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await widget.onClearAll();
                ref.invalidate(widget.invalidateTarget);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.title} cleared')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: asyncData.when(
        data: (items) {
          final filtered = _onlyFavorites
              ? items.where((i) => widget.getIsFavorite(i)).toList()
              : items;

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _onlyFavorites ? Icons.star_outline : Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _onlyFavorites ? widget.emptyStarredMessage : widget.emptyMessage,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return HistoryListTile(
                text: widget.getText(item),
                createdAt: widget.getCreatedAt(item),
                id: widget.getId(item),
                isFavorite: widget.getIsFavorite(item),
                ref: ref,
                provider: widget.invalidateTarget,
                deleteItemAction: (id) => widget.onDelete(id),
                toggleFavoriteAction: (id, current) =>
                    widget.onToggleFavorite(id, current),
              );
            },
          );
        },
        error: (error, _) => Center(
          child: SelectableText('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
