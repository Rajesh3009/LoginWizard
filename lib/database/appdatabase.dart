import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'appdatabase.g.dart';

class UsernameTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [UsernameTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getTemporaryDirectory();
      final file = File(p.join(dbFolder.path, 'loginwiz.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  Future<void> deleteAll() async {
    await delete(usernameTable).go();
  }

  Future<void> deleteEntry(int id) async {
    await managers.usernameTable
        .filter((table) => table.id.equals(id))
        .delete();
  }
}

final databaseProvider = Provider((ref) => AppDatabase());
