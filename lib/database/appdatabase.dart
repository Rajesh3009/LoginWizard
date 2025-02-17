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
}

class PasswordTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get password => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class PinTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pin => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DriftDatabase(tables: [UsernameTable, PasswordTable,PinTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Create all tables on database creation
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 1) {
            // Create tables if upgrading from a version before 1
            await m.createAll();
          }
        },
        beforeOpen: (details) async {
          // Ensure tables exist before opening database
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

  Future<void> deleteAllUsername() async {
    await delete(usernameTable).go();
  }

  Future<void> deleteUsername(int id) async {
    await (delete(usernameTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllPassword() async {
    await delete(passwordTable).go();
  }

  Future<void> deletePassword(int id) async {
    await (delete(passwordTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllPin() async {
    await delete(pinTable).go();
  }
  Future<void> deletePin(int id) async {
    await (delete(pinTable)..where((t) => t.id.equals(id))).go();
  }
}

final databaseProvider = Provider((ref) => AppDatabase());
