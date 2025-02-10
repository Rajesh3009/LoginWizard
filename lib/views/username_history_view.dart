import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                database.deleteAll();
                ref.invalidate(usernameHistoryProvider);
              },
            )
          ],
        ),
        body: data.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].username),
                subtitle: Text(data[index].createdAt.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    database.deleteEntry(data[index].id);
                    ref.invalidate(usernameHistoryProvider);
                  },
                ),
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
