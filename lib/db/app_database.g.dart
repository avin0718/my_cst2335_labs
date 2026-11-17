// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class ContactTable extends Table with TableInfo<ContactTable, ContactData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ContactTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    phoneNumber,
    email,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ContactTable';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContactData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContactData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContactData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
    );
  }

  @override
  ContactTable createAlias(String alias) {
    return ContactTable(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ContactData extends DataClass implements Insertable<ContactData> {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  const ContactData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['email'] = Variable<String>(email);
    return map;
  }

  ContactTableCompanion toCompanion(bool nullToAbsent) {
    return ContactTableCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      phoneNumber: Value(phoneNumber),
      email: Value(email),
    );
  }

  factory ContactData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContactData(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['first_name']),
      lastName: serializer.fromJson<String>(json['last_name']),
      phoneNumber: serializer.fromJson<String>(json['phone_number']),
      email: serializer.fromJson<String>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'first_name': serializer.toJson<String>(firstName),
      'last_name': serializer.toJson<String>(lastName),
      'phone_number': serializer.toJson<String>(phoneNumber),
      'email': serializer.toJson<String>(email),
    };
  }

  ContactData copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
  }) => ContactData(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
  );
  ContactData copyWithCompanion(ContactTableCompanion data) {
    return ContactData(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContactData(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, firstName, lastName, phoneNumber, email);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContactData &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email);
}

class ContactTableCompanion extends UpdateCompanion<ContactData> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> phoneNumber;
  final Value<String> email;
  const ContactTableCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
  });
  ContactTableCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       phoneNumber = Value(phoneNumber),
       email = Value(email);
  static Insertable<ContactData> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? phoneNumber,
    Expression<String>? email,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
    });
  }

  ContactTableCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? phoneNumber,
    Value<String>? email,
  }) {
    return ContactTableCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactTableCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final ContactTable contactTable = ContactTable(this);
  Future<int> saveContact(
    String firstName,
    String lastName,
    String phoneNumber,
    String email,
  ) {
    return customInsert(
      'INSERT INTO ContactTable (first_name, last_name, phone_number, email) VALUES (?1, ?2, ?3, ?4)',
      variables: [
        Variable<String>(firstName),
        Variable<String>(lastName),
        Variable<String>(phoneNumber),
        Variable<String>(email),
      ],
      updates: {this.contactTable},
    );
  }

  Selectable<ContactData> getAllContacts() {
    return customSelect(
      'SELECT * FROM ContactTable ORDER BY id DESC',
      variables: [],
      readsFrom: {this.contactTable},
    ).asyncMap(this.contactTable.mapFromRow);
  }

  Selectable<ContactData> getContactById(int id) {
    return customSelect(
      'SELECT * FROM ContactTable WHERE id = ?1',
      variables: [Variable<int>(id)],
      readsFrom: {this.contactTable},
    ).asyncMap(this.contactTable.mapFromRow);
  }

  Future<int> deleteContact(int id) {
    return customUpdate(
      'DELETE FROM ContactTable WHERE id = ?1',
      variables: [Variable<int>(id)],
      updates: {this.contactTable},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [contactTable];
}

typedef $ContactTableCreateCompanionBuilder = ContactTableCompanion Function({
  Value<int> id,
  required String firstName,
  required String lastName,
  required String phoneNumber,
  required String email,
});
typedef $ContactTableUpdateCompanionBuilder = ContactTableCompanion Function({
  Value<int> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<String> phoneNumber,
  Value<String> email,
});

class $ContactTableFilterComposer
    extends Composer<_$AppDatabase, ContactTable> {
  $ContactTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );
}

class $ContactTableOrderingComposer
    extends Composer<_$AppDatabase, ContactTable> {
  $ContactTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ContactTableAnnotationComposer
    extends Composer<_$AppDatabase, ContactTable> {
  $ContactTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);
}

class $ContactTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ContactTable,
          ContactData,
          $ContactTableFilterComposer,
          $ContactTableOrderingComposer,
          $ContactTableAnnotationComposer,
          $ContactTableCreateCompanionBuilder,
          $ContactTableUpdateCompanionBuilder,
          (
            ContactData,
            BaseReferences<_$AppDatabase, ContactTable, ContactData>,
          ),
          ContactData,
          PrefetchHooks Function()
        > {
  $ContactTableTableManager(_$AppDatabase db, ContactTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ContactTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ContactTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ContactTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> email = const Value.absent(),
              }) => ContactTableCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                email: email,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String lastName,
                required String phoneNumber,
                required String email,
              }) => ContactTableCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                email: email,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ContactTable, ContactData>(table),
                  BaseReferences<_$AppDatabase, ContactTable, ContactData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $ContactTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ContactTable,
      ContactData,
      $ContactTableFilterComposer,
      $ContactTableOrderingComposer,
      $ContactTableAnnotationComposer,
      $ContactTableCreateCompanionBuilder,
      $ContactTableUpdateCompanionBuilder,
      (ContactData, BaseReferences<_$AppDatabase, ContactTable, ContactData>),
      ContactData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $ContactTableTableManager get contactTable =>
      $ContactTableTableManager(_db, _db.contactTable);
}
