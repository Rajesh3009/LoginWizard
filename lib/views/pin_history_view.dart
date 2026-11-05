import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/appdatabase.dart';
import '../provider/pin_provider.dart';
import '../widgets/base_history_view.dart';

/// Screen displaying the history of generated PINs
class PinHistoryView extends ConsumerWidget {
  const PinHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseProvider);

    return BaseHistoryView<PinTableData>(
      title: 'PIN History',
      clearDialogTitle: 'Clear PIN History',
      clearDialogMessage: 'Are you sure you want to delete all saved PINs?',
      emptyMessage: 'No PIN history yet',
      emptyStarredMessage: 'No starred PINs yet',
      historyProvider: pinHistoryProvider,
      invalidateTarget: pinHistoryProvider,
      getText: (item) => item.pin,
      getCreatedAt: (item) => item.createdAt,
      getId: (item) => item.id,
      getIsFavorite: (item) => item.isFavorite,
      onDelete: (id) => database.deletePin(id),
      onToggleFavorite: (id, current) => database.toggleFavoritePin(id, current),
      onClearAll: () => database.deleteAllPin(),
    );
  }
}
