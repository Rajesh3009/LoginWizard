import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/appdatabase.dart';

final usernameHistoryProvider =
    FutureProvider.autoDispose<List<UsernameTableData>>((ref) async {
  final database = ref.watch(databaseProvider);
  final data = await database
      .select(database.usernameTable)
      .get()
      .then((value) => value.reversed.toList());
  return data;
});
