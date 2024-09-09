import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../models/history.dart';

class HistoryDatabaseInterface {
  static final HistoryDatabaseInterface instance = HistoryDatabaseInterface._internal();

  static Database? _database;
  HistoryDatabaseInterface._internal();

  static const String databaseName = "bottles_database.db";

  static const int versionNumber = 1;

  static const String tableHistory = 'History';

  static const String colId = 'id';
  static const String colBottleId = 'bottleId';
  static const String colIsIncoming = 'isIncoming';
  static const String colCreatedAt = 'createdAt';

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  _initDatabase() async {
    String path = join((await getApplicationDocumentsDirectory()).path, 'databases', databaseName);
    var db = await openDatabase(
      path,
      version: versionNumber,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    //await db.execute('''PRAGMA foreign_keys = ON''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableHistory (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colBottleId INTEGER,
        $colIsIncoming INTEGER DEFAULT 1,
        $colCreatedAt INTEGER
      )
    ''');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $tableHistory');
    _onCreate(db, newVersion);
  }

  Future<List<History>> getAll() async {
    final Database db = await database;

    final List<Map<String, Object?>> maps = await db.query(tableHistory);

    return maps.map((json) => History.fromMap(json)).toList();
  }
}