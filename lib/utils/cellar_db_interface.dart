import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bottle.dart';
import '../models/cluster.dart';

class CellarDatabaseInterface {
  static final CellarDatabaseInterface instance = CellarDatabaseInterface._internal();

  static Database? _database;
  CellarDatabaseInterface._internal();

  static const String databaseName = "cellar_database.db";

  static const int versionNumber = 8;

  static const String tableCluster = 'Clusters';
  static const String tableRowConfiguration = 'RowConfiguration';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colWidth = 'width';
  static const String colHeight = 'height';

  static const String colClusterId = 'clusterId';
  static const String colRow = 'row';
  static const String colCustomWidth = 'customWidth';

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
    //await db.execute('''PRAGMA foreign_keys = ON''');
    debugPrint("Create database");
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCluster (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT,
        $colWidth INTEGER,
        $colHeight INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableRowConfiguration (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colClusterId INTEGER,
        $colRow INTEGER,
        $colCustomWidth INTEGER
      )
    ''');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS $tableCluster');
    await db.execute('DROP TABLE IF EXISTS $tableRowConfiguration');
    _onCreate(db, newVersion);
  }

  Future<List<CellarCluster>> getClusters() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(tableCluster, orderBy: '$colId ASC');
    return result.map((json) => CellarCluster.fromMap(json)).toList();
  }

  Future<void> insertCluster(CellarCluster cluster) async {
    final Database db = await database;

    await db.insert(tableCluster, cluster.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // For all rows, insert a row configuration
    for (int i = 0; i < cluster.height!; i++) {
      await db.insert(tableRowConfiguration, {
        colClusterId: cluster.id,
        colRow: i,
        colCustomWidth: cluster.width,
      });
    }
  }

  Future<List<Object?>> insertAll(List<CellarCluster> clusters) async {
    final Database db = await database;
    Batch batch = db.batch();
    for (CellarCluster cluster in clusters) {
      batch.insert(tableCluster, cluster.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

      // For all rows, insert a row configuration
      for (int i = 0; i < cluster.height!; i++) {
        batch.insert(tableRowConfiguration, {
          colClusterId: cluster.id,
          colRow: i,
          colCustomWidth: cluster.width,
        });
      }
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

  Future<Map<int, List<int>>> getClustersRowConfiguration() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(tableRowConfiguration);
    Map<int, List<int>> configuration = {};

    for (Map<String, dynamic> row in result) {
      if (!configuration.containsKey(row[colClusterId])) {
        configuration[row[colClusterId]] = [];
      }

      configuration[row[colClusterId]]!.add(row[colCustomWidth]);
    }

    return configuration;
  }

  Future<void> updateClusterRowConfiguration(int clusterId, int row, int customWidth) async {
    final Database db = await database;
    await db.update(
      tableRowConfiguration,
      {colCustomWidth: customWidth},
      where: '$colClusterId = ? AND $colRow = ?',
      whereArgs: [clusterId, row],
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

  Future<void> wipe() async {
    final Database db = await database;
    await db.delete(tableCluster);
    await db.delete(tableRowConfiguration);
  }
}