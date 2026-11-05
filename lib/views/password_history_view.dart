import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/appdatabase.dart';
import '../provider/password_provider.dart';
import '../widgets/base_history_view.dart';

/// Screen displaying the history of generated passwords
class PasswordHistoryView extends ConsumerWidget {
  const PasswordHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);

    return BaseHistoryView<PasswordTableData>(
      title: 'Password History',
      clearDialogTitle: 'Clear Password History',
      clearDialogMessage: 'Are you sure you want to delete all saved passwords?',
      emptyMessage: 'No password history yet',
      emptyStarredMessage: 'No starred passwords yet',
      historyProvider: passwordHistoryProvider,
      invalidateTarget: passwordHistoryProvider,
      getText: (item) => item.password,
      getCreatedAt: (item) => item.createdAt,
      getId: (item) => item.id,
      getIsFavorite: (item) => item.isFavorite,
      onDelete: (id) => database.deletePassword(id),
      onToggleFavorite: (id, current) => database.toggleFavoritePassword(id, current),
      onClearAll: () => database.deleteAllPassword(),
    );
  }
}
