import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/database/appdatabase.dart';
import 'package:loginwizard/provider/password_provider.dart';
import 'package:loginwizard/widgets/history_list_tile.dart';

class PasswordHistoryView extends ConsumerStatefulWidget {
  const PasswordHistoryView({super.key});

  @override
  ConsumerState<PasswordHistoryView> createState() => _PasswordHistoryViewState();
}

class _PasswordHistoryViewState extends ConsumerState<PasswordHistoryView> {
  bool _onlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(passwordHistoryProvider);
    final database = ref.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password History'),
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
            tooltip: 'Clear All Passwords',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Password History'),
                  content: const Text('Are you sure you want to delete all saved passwords?'),
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
                await database.deleteAllPassword();
                ref.invalidate(passwordHistoryProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password history cleared')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: data.when(
        data: (items) {
          final filtered = _onlyFavorites
              ? items.where((i) => i.isFavorite).toList()
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
                    _onlyFavorites
                        ? 'No starred passwords yet'
                        : 'No password history yet',
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
                text: item.password,
                createdAt: item.createdAt,
                id: item.id,
                isFavorite: item.isFavorite,
                ref: ref,
                provider: passwordHistoryProvider,
                deleteItemAction: (id) => database.deletePassword(id),
                toggleFavoriteAction: (id, current) =>
                    database.toggleFavoritePassword(id, current),
              );
            },
          );
        },
        error: (error, stack) => Center(
          child: SelectableText('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
