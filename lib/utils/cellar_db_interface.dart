import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bottle.dart';
import '../models/cluster.dart';

class CellarDatabaseInterface {
  static final CellarDatabaseInterface instance = CellarDatabaseInterface._internal();

  static Database? _database;
  CellarDatabaseInterface._internal();

  static const String databaseName = "cellar_database.db";

  static const int versionNumber = 2;

  static const String tableCluster = 'Clusters';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colWidth = 'width';
  static const String colHeight = 'height';

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    var db = await openDatabase(
      path,
      version: versionNumber,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCluster (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
        $colWidth INTEGER,
        $colHeight INTEGER
      )
    ''');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $tableCluster');
    _onCreate(db, newVersion);
  }

  Future<List<CellarCluster>> getClusters() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(tableCluster, orderBy: '$colId ASC');
    return result.map((json) => CellarCluster.fromMap(json)).toList();
  }

  Future<int> insertCluster(CellarCluster cluster) async {
    final Database db = await database;
    return await db.insert(tableCluster, cluster.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Object?>> insertAll(List<CellarCluster> clusters) async {
    final Database db = await database;
    Batch batch = db.batch();
    for (CellarCluster cluster in clusters) {
      batch.insert(tableCluster, cluster.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return await batch.commit(noResult: true);
  }

  Future<int> updateCluster(CellarCluster cluster) async {
    final Database db = await database;
    return await db.update(
      tableCluster,
      cluster.toMap(),
      where: '$colId = ?',
      whereArgs: [cluster.id],
    );
  }

  Future<int> deleteCluster(int id) async {
    final Database db = await database;
    return await db.delete(
      tableCluster,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<CellarCluster?> getBottleCluster(Bottle bottle) async {
    final Database db = await database;
    if (bottle.clusterId == null) {
      return null;
    }

    final Map<String, dynamic> result = (await db.query(tableCluster, where: '$colId = ?', whereArgs: [bottle.clusterId])).first;

    return CellarCluster.fromMap(result);
  }
}