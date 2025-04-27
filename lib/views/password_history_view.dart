
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/database/appdatabase.dart';
import 'package:loginwizard/provider/password_provider.dart';
import 'package:loginwizard/widgets/history_list_tile.dart';

class PasswordHistoryView extends ConsumerWidget {
  const PasswordHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(passwordHistoryProvider);
    final database = ref.read(databaseProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                database.deleteAllPassword();
                ref.invalidate(passwordHistoryProvider);
              },
            )
          ],
        ),
        body: data.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              // return ListTile(
              //   title: Text(data[index].password),
              //   subtitle: Text(data[index].createdAt.toString()),
              //   trailing: IconButton(
              //     icon: const Icon(Icons.delete),
              //     onPressed: () {
              //       database.deletePassword(data[index].id);
              //       ref.invalidate(passwordHistoryProvider);
              //     },
              //   ),
              // );
              final item = data[index];
              return HistoryListTile(
                password: item.password,
                createdAt: item.createdAt!,
                id: item.id,
                ref: ref,
                provider: passwordHistoryProvider, // Pass the provider object
                deleteItemAction: (id) { // Pass the delete action
                  database.deletePassword(id);
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
