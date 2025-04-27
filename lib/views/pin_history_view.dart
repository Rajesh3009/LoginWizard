
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/database/appdatabase.dart';
import 'package:loginwizard/provider/pin_provider.dart';
import 'package:loginwizard/widgets/history_list_tile.dart';

class PinHistoryView extends ConsumerWidget {
  const PinHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(pinHistoryProvider);
    final database = ref.read(databaseProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                database.deleteAllPin(); // Fix: Call deleteAllPin
                ref.invalidate(pinHistoryProvider);
              },
            )
          ],
        ),
        body: data.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return HistoryListTile(
                password: item.pin, // Use pin for password parameter
                createdAt: item.createdAt!,
                id: item.id,
                ref: ref,
                provider: pinHistoryProvider, // Pass the provider object
                deleteItemAction: (id) { // Pass the delete action
                  database.deletePin(id); // Fix: Call deletePin
                },
              );
            },
          );
        }, error: (error, stack) {
          return Center(
            child: SelectableText('Error: $error'),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
