// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appdatabase.dart';

// ignore_for_file: type=lint
class $UsernameTableTable extends UsernameTable
    with TableInfo<$UsernameTableTable, UsernameTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsernameTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, username, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'username_table';
  @override
  VerificationContext validateIntegrity(Insertable<UsernameTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsernameTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsernameTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $UsernameTableTable createAlias(String alias) {
    return $UsernameTableTable(attachedDatabase, alias);
  }
}

class UsernameTableData extends DataClass
    implements Insertable<UsernameTableData> {
  final int id;
  final String username;
  final DateTime? createdAt;
  const UsernameTableData(
      {required this.id, required this.username, this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  UsernameTableCompanion toCompanion(bool nullToAbsent) {
    return UsernameTableCompanion(
      id: Value(id),
      username: Value(username),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory UsernameTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsernameTableData(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  UsernameTableData copyWith(
          {int? id,
          String? username,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      UsernameTableData(
        id: id ?? this.id,
        username: username ?? this.username,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  UsernameTableData copyWithCompanion(UsernameTableCompanion data) {
    return UsernameTableData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsernameTableData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsernameTableData &&
          other.id == this.id &&
          other.username == this.username &&
          other.createdAt == this.createdAt);
}

class UsernameTableCompanion extends UpdateCompanion<UsernameTableData> {
  final Value<int> id;
  final Value<String> username;
  final Value<DateTime?> createdAt;
  const UsernameTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsernameTableCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    this.createdAt = const Value.absent(),
  }) : username = Value(username);
  static Insertable<UsernameTableData> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsernameTableCompanion copyWith(
      {Value<int>? id, Value<String>? username, Value<DateTime?>? createdAt}) {
    return UsernameTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsernameTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsernameTableTable usernameTable = $UsernameTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [usernameTable];
}

typedef $$UsernameTableTableCreateCompanionBuilder = UsernameTableCompanion
    Function({
  Value<int> id,
  required String username,
  Value<DateTime?> createdAt,
});
typedef $$UsernameTableTableUpdateCompanionBuilder = UsernameTableCompanion
    Function({
  Value<int> id,
  Value<String> username,
  Value<DateTime?> createdAt,
});

class $$UsernameTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsernameTableTable> {
  $$UsernameTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$UsernameTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsernameTableTable> {
  $$UsernameTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsernameTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsernameTableTable> {
  $$UsernameTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsernameTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsernameTableTable,
    UsernameTableData,
    $$UsernameTableTableFilterComposer,
    $$UsernameTableTableOrderingComposer,
    $$UsernameTableTableAnnotationComposer,
    $$UsernameTableTableCreateCompanionBuilder,
    $$UsernameTableTableUpdateCompanionBuilder,
    (
      UsernameTableData,
      BaseReferences<_$AppDatabase, $UsernameTableTable, UsernameTableData>
    ),
    UsernameTableData,
    PrefetchHooks Function()> {
  $$UsernameTableTableTableManager(_$AppDatabase db, $UsernameTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsernameTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsernameTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsernameTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              UsernameTableCompanion(
            id: id,
            username: username,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              UsernameTableCompanion.insert(
            id: id,
            username: username,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsernameTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsernameTableTable,
    UsernameTableData,
    $$UsernameTableTableFilterComposer,
    $$UsernameTableTableOrderingComposer,
    $$UsernameTableTableAnnotationComposer,
    $$UsernameTableTableCreateCompanionBuilder,
    $$UsernameTableTableUpdateCompanionBuilder,
    (
      UsernameTableData,
      BaseReferences<_$AppDatabase, $UsernameTableTable, UsernameTableData>
    ),
    UsernameTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsernameTableTableTableManager get usernameTable =>
      $$UsernameTableTableTableManager(_db, _db.usernameTable);
}
