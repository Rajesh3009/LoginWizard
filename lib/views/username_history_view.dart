import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/appdatabase.dart';
import '../provider/username_history_provider.dart';
import '../widgets/base_history_view.dart';

/// Screen displaying the history of generated usernames
class UsernameHistory extends ConsumerWidget {
  const UsernameHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);

    return BaseHistoryView<UsernameTableData>(
      title: 'Username History',
      clearDialogTitle: 'Clear Username History',
      clearDialogMessage: 'Are you sure you want to delete all saved usernames?',
      emptyMessage: 'No username history yet',
      emptyStarredMessage: 'No starred usernames yet',
      historyProvider: usernameHistoryProvider,
      invalidateTarget: usernameHistoryProvider,
      getText: (item) => item.username,
      getCreatedAt: (item) => item.createdAt,
      getId: (item) => item.id,
      getIsFavorite: (item) => item.isFavorite,
      onDelete: (id) => database.deleteUsername(id),
      onToggleFavorite: (id, current) => database.toggleFavoriteUsername(id, current),
      onClearAll: () => database.deleteAllUsername(),
    );
  }
}
