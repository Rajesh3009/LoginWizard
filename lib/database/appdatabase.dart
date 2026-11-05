// ignore_for_file: depend_on_referenced_packages

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
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

class PasswordTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

class PinTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pin => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [UsernameTable, PasswordTable, PinTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 1) {
            await m.createAll();
          }
          if (from < 3) {
            await m.addColumn(usernameTable, usernameTable.isFavorite);
            await m.addColumn(passwordTable, passwordTable.isFavorite);
            await m.addColumn(pinTable, pinTable.isFavorite);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            await customStatement('PRAGMA foreign_keys = ON');
          }
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'LoginWizard/loginwiz.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  // --- Username Operations ---
  Future<void> deleteAllUsername() async {
    await delete(usernameTable).go();
  }

  Future<void> deleteUsername(int id) async {
    await (delete(usernameTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> toggleFavoriteUsername(int id, bool current) async {
    await (update(usernameTable)..where((t) => t.id.equals(id)))
        .write(UsernameTableCompanion(isFavorite: Value(!current)));
  }

  // --- Password Operations ---
  Future<void> deleteAllPassword() async {
    await delete(passwordTable).go();
  }

  Future<void> deletePassword(int id) async {
    await (delete(passwordTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> toggleFavoritePassword(int id, bool current) async {
    await (update(passwordTable)..where((t) => t.id.equals(id)))
        .write(PasswordTableCompanion(isFavorite: Value(!current)));
  }

  // --- PIN Operations ---
  Future<void> deleteAllPin() async {
    await delete(pinTable).go();
  }

  Future<void> deletePin(int id) async {
    await (delete(pinTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> toggleFavoritePin(int id, bool current) async {
    await (update(pinTable)..where((t) => t.id.equals(id)))
        .write(PinTableCompanion(isFavorite: Value(!current)));
  }

  // --- Bulk Purge Actions ---
  Future<int> purgeHistoryOlderThan(Duration duration) async {
    final cutoff = DateTime.now().subtract(duration);
    var count = 0;
    count += await (delete(usernameTable)
          ..where((t) => t.isFavorite.equals(false) & t.createdAt.isSmallerThanValue(cutoff)))
        .go();
    count += await (delete(passwordTable)
          ..where((t) => t.isFavorite.equals(false) & t.createdAt.isSmallerThanValue(cutoff)))
        .go();
    count += await (delete(pinTable)
          ..where((t) => t.isFavorite.equals(false) & t.createdAt.isSmallerThanValue(cutoff)))
        .go();
    return count;
  }
}

final databaseProvider = Provider((ref) => AppDatabase());
