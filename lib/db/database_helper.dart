import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/contact.dart';

/// DatabaseHelper class managing SQLite database creation, query, insert, and delete operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Initialize FFI for Windows/Linux/macOS desktop platforms
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT,
        last_name TEXT,
        phone_number TEXT,
        email TEXT
      )
    ''');
  }

  /// 1. Inserts a new Contact into the database using predefined INSERT SQL statement function
  Future<int> insertContact(Contact contact) async {
    final db = await instance.database;
    // Predefined INSERT SQL statement
    return await db.rawInsert(
      'INSERT INTO contacts (first_name, last_name, phone_number, email) VALUES (?, ?, ?, ?)',
      [
        contact.firstName,
        contact.lastName,
        contact.phoneNumber,
        contact.email,
      ],
    );
  }

  /// 2. Retrieves all stored Contact items from the database when application restarts
  Future<List<Contact>> getContacts() async {
    final db = await instance.database;
    // Predefined SELECT SQL statement
    final maps = await db.rawQuery('SELECT * FROM contacts ORDER BY id DESC');
    return maps.map((map) => Contact.fromMap(map)).toList();
  }

  /// 3. Deletes a Contact item from the database using its primary key ID
  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    // Predefined DELETE SQL statement
    return await db.rawDelete('DELETE FROM contacts WHERE id = ?', [id]);
  }
}
