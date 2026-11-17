import 'connection.dart'
if (dart.library.js_util) 'web.dart'
if (dart.library.io) 'native.dart';

import 'package:drift/drift.dart';

part 'app_database.g.dart';

@DriftDatabase(
  include: {'Contact.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        await migrator.createAll();
      },
      beforeOpen: (details) async {},
    );
  }
}
