import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/widgets/history_list_tile.dart';

import '../database/appdatabase.dart';
import '../provider/username_history_provider.dart';

class UsernameHistory extends ConsumerWidget {
  const UsernameHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(usernameHistoryProvider);
    final database = ref.read(databaseProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                database.deleteAllUsername();
                ref.invalidate(usernameHistoryProvider);
              },
            )
          ],
        ),
        body: data.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              // return ListTile(
              //   title: Text(data[index].username),
              //   subtitle: Text(data[index].createdAt.toString()),
              //   trailing: IconButton(
              //     icon: const Icon(Icons.delete),
              //     onPressed: () {
              //       database.deleteUsername(data[index].id);
              //       ref.invalidate(usernameHistoryProvider);
              //     },
              //   ),
              // );
              final item = data[index];
              return HistoryListTile(
                password: item.username,
                createdAt: item.createdAt!,
                id: item.id,
                ref: ref,
                provider: usernameHistoryProvider, // Pass the provider object
                deleteItemAction: (id) { // Pass the delete action
                  database.deleteUsername(id);
                },
              );
            },
          );
        }, error: (error, stack) {
          return Center(
            child: Text('Error: $error'),
          );
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
