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

class $PasswordTableTable extends PasswordTable
    with TableInfo<$PasswordTableTable, PasswordTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PasswordTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, password, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'password_table';
  @override
  VerificationContext validateIntegrity(Insertable<PasswordTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
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
  PasswordTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PasswordTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $PasswordTableTable createAlias(String alias) {
    return $PasswordTableTable(attachedDatabase, alias);
  }
}

class PasswordTableData extends DataClass
    implements Insertable<PasswordTableData> {
  final int id;
  final String password;
  final DateTime? createdAt;
  const PasswordTableData(
      {required this.id, required this.password, this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  PasswordTableCompanion toCompanion(bool nullToAbsent) {
    return PasswordTableCompanion(
      id: Value(id),
      password: Value(password),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory PasswordTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PasswordTableData(
      id: serializer.fromJson<int>(json['id']),
      password: serializer.fromJson<String>(json['password']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'password': serializer.toJson<String>(password),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  PasswordTableData copyWith(
          {int? id,
          String? password,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      PasswordTableData(
        id: id ?? this.id,
        password: password ?? this.password,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  PasswordTableData copyWithCompanion(PasswordTableCompanion data) {
    return PasswordTableData(
      id: data.id.present ? data.id.value : this.id,
      password: data.password.present ? data.password.value : this.password,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PasswordTableData(')
          ..write('id: $id, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, password, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PasswordTableData &&
          other.id == this.id &&
          other.password == this.password &&
          other.createdAt == this.createdAt);
}

class PasswordTableCompanion extends UpdateCompanion<PasswordTableData> {
  final Value<int> id;
  final Value<String> password;
  final Value<DateTime?> createdAt;
  const PasswordTableCompanion({
    this.id = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PasswordTableCompanion.insert({
    this.id = const Value.absent(),
    required String password,
    this.createdAt = const Value.absent(),
  }) : password = Value(password);
  static Insertable<PasswordTableData> custom({
    Expression<int>? id,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PasswordTableCompanion copyWith(
      {Value<int>? id, Value<String>? password, Value<DateTime?>? createdAt}) {
    return PasswordTableCompanion(
      id: id ?? this.id,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordTableCompanion(')
          ..write('id: $id, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PinTableTable extends PinTable
    with TableInfo<$PinTableTable, PinTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String> pin = GeneratedColumn<String>(
      'pin', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, pin, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pin_table';
  @override
  VerificationContext validateIntegrity(Insertable<PinTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pin')) {
      context.handle(
          _pinMeta, pin.isAcceptableOrUnknown(data['pin']!, _pinMeta));
    } else if (isInserting) {
      context.missing(_pinMeta);
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
  PinTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $PinTableTable createAlias(String alias) {
    return $PinTableTable(attachedDatabase, alias);
  }
}

class PinTableData extends DataClass implements Insertable<PinTableData> {
  final int id;
  final String pin;
  final DateTime? createdAt;
  const PinTableData({required this.id, required this.pin, this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pin'] = Variable<String>(pin);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  PinTableCompanion toCompanion(bool nullToAbsent) {
    return PinTableCompanion(
      id: Value(id),
      pin: Value(pin),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory PinTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinTableData(
      id: serializer.fromJson<int>(json['id']),
      pin: serializer.fromJson<String>(json['pin']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pin': serializer.toJson<String>(pin),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  PinTableData copyWith(
          {int? id,
          String? pin,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      PinTableData(
        id: id ?? this.id,
        pin: pin ?? this.pin,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  PinTableData copyWithCompanion(PinTableCompanion data) {
    return PinTableData(
      id: data.id.present ? data.id.value : this.id,
      pin: data.pin.present ? data.pin.value : this.pin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinTableData(')
          ..write('id: $id, ')
          ..write('pin: $pin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pin, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinTableData &&
          other.id == this.id &&
          other.pin == this.pin &&
          other.createdAt == this.createdAt);
}

class PinTableCompanion extends UpdateCompanion<PinTableData> {
  final Value<int> id;
  final Value<String> pin;
  final Value<DateTime?> createdAt;
  const PinTableCompanion({
    this.id = const Value.absent(),
    this.pin = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PinTableCompanion.insert({
    this.id = const Value.absent(),
    required String pin,
    this.createdAt = const Value.absent(),
  }) : pin = Value(pin);
  static Insertable<PinTableData> custom({
    Expression<int>? id,
    Expression<String>? pin,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pin != null) 'pin': pin,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PinTableCompanion copyWith(
      {Value<int>? id, Value<String>? pin, Value<DateTime?>? createdAt}) {
    return PinTableCompanion(
      id: id ?? this.id,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinTableCompanion(')
          ..write('id: $id, ')
          ..write('pin: $pin, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsernameTableTable usernameTable = $UsernameTableTable(this);
  late final $PasswordTableTable passwordTable = $PasswordTableTable(this);
  late final $PinTableTable pinTable = $PinTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [usernameTable, passwordTable, pinTable];
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
typedef $$PasswordTableTableCreateCompanionBuilder = PasswordTableCompanion
    Function({
  Value<int> id,
  required String password,
  Value<DateTime?> createdAt,
});
typedef $$PasswordTableTableUpdateCompanionBuilder = PasswordTableCompanion
    Function({
  Value<int> id,
  Value<String> password,
  Value<DateTime?> createdAt,
});

class $$PasswordTableTableFilterComposer
    extends Composer<_$AppDatabase, $PasswordTableTable> {
  $$PasswordTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PasswordTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PasswordTableTable> {
  $$PasswordTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PasswordTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PasswordTableTable> {
  $$PasswordTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PasswordTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PasswordTableTable,
    PasswordTableData,
    $$PasswordTableTableFilterComposer,
    $$PasswordTableTableOrderingComposer,
    $$PasswordTableTableAnnotationComposer,
    $$PasswordTableTableCreateCompanionBuilder,
    $$PasswordTableTableUpdateCompanionBuilder,
    (
      PasswordTableData,
      BaseReferences<_$AppDatabase, $PasswordTableTable, PasswordTableData>
    ),
    PasswordTableData,
    PrefetchHooks Function()> {
  $$PasswordTableTableTableManager(_$AppDatabase db, $PasswordTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PasswordTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PasswordTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PasswordTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              PasswordTableCompanion(
            id: id,
            password: password,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String password,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              PasswordTableCompanion.insert(
            id: id,
            password: password,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PasswordTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PasswordTableTable,
    PasswordTableData,
    $$PasswordTableTableFilterComposer,
    $$PasswordTableTableOrderingComposer,
    $$PasswordTableTableAnnotationComposer,
    $$PasswordTableTableCreateCompanionBuilder,
    $$PasswordTableTableUpdateCompanionBuilder,
    (
      PasswordTableData,
      BaseReferences<_$AppDatabase, $PasswordTableTable, PasswordTableData>
    ),
    PasswordTableData,
    PrefetchHooks Function()>;
typedef $$PinTableTableCreateCompanionBuilder = PinTableCompanion Function({
  Value<int> id,
  required String pin,
  Value<DateTime?> createdAt,
});
typedef $$PinTableTableUpdateCompanionBuilder = PinTableCompanion Function({
  Value<int> id,
  Value<String> pin,
  Value<DateTime?> createdAt,
});

class $$PinTableTableFilterComposer
    extends Composer<_$AppDatabase, $PinTableTable> {
  $$PinTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pin => $composableBuilder(
      column: $table.pin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PinTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PinTableTable> {
  $$PinTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pin => $composableBuilder(
      column: $table.pin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PinTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PinTableTable> {
  $$PinTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pin =>
      $composableBuilder(column: $table.pin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PinTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PinTableTable,
    PinTableData,
    $$PinTableTableFilterComposer,
    $$PinTableTableOrderingComposer,
    $$PinTableTableAnnotationComposer,
    $$PinTableTableCreateCompanionBuilder,
    $$PinTableTableUpdateCompanionBuilder,
    (PinTableData, BaseReferences<_$AppDatabase, $PinTableTable, PinTableData>),
    PinTableData,
    PrefetchHooks Function()> {
  $$PinTableTableTableManager(_$AppDatabase db, $PinTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pin = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              PinTableCompanion(
            id: id,
            pin: pin,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pin,
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              PinTableCompanion.insert(
            id: id,
            pin: pin,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PinTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PinTableTable,
    PinTableData,
    $$PinTableTableFilterComposer,
    $$PinTableTableOrderingComposer,
    $$PinTableTableAnnotationComposer,
    $$PinTableTableCreateCompanionBuilder,
    $$PinTableTableUpdateCompanionBuilder,
    (PinTableData, BaseReferences<_$AppDatabase, $PinTableTable, PinTableData>),
    PinTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsernameTableTableTableManager get usernameTable =>
      $$UsernameTableTableTableManager(_db, _db.usernameTable);
  $$PasswordTableTableTableManager get passwordTable =>
      $$PasswordTableTableTableManager(_db, _db.passwordTable);
  $$PinTableTableTableManager get pinTable =>
      $$PinTableTableTableManager(_db, _db.pinTable);
}
