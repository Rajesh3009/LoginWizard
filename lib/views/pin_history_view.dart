
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loginwizard/database/appdatabase.dart';
import 'package:loginwizard/provider/pin_provider.dart';

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
                database.deleteAllPassword();
                ref.invalidate(pinHistoryProvider);
              },
            )
          ],
        ),
        body: data.when(data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].pin),
                subtitle: Text(data[index].createdAt.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    database.deletePassword(data[index].id);
                    ref.invalidate(pinHistoryProvider);
                  },
                ),
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