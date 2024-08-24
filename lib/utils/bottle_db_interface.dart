import 'package:cave_manager/models/cluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bottle.dart';

class BottleDatabaseInterface {
  static final BottleDatabaseInterface instance = BottleDatabaseInterface._internal();

  static Database? _database;
  BottleDatabaseInterface._internal();

  static const String databaseName = "bottles_database.db";

  static const int versionNumber = 22;

  static const String tableBottles = 'Bottles';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colSignature = 'signature';
  static const String colVintageYear = 'vintageYear';
  static const String colColor = 'color';
  static const String colAlcoholLevel = 'alcoholLevel';
  static const String colGrapeVariety = 'grapeVariety';
  static const String colCountry = 'country';
  static const String colArea = 'area';
  static const String colSubArea = 'subArea';
  static const String colImageUri = 'imageUri';
  static const String colIsInCellar = 'isInCellar';
  static const String colIsOpen = "isOpen";
  static const String colClusterId = "clusterId";
  static const String colClusterY = "clusterY";
  static const String colClusterSubY = "clusterSubY";
  static const String colClusterX = "clusterX";
  static const String colCreatedAt = "createdAt";
  static const String colRegisteredInCellarAt = "registeredInCellarAt";
  static const String colOpenedAt = "openedAt";
  static const String colTastingNote = "tastingNote";

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  _initDatabase() async {
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    String path = join((await getApplicationDocumentsDirectory()).path, 'databases', databaseName);
    // When the database is first created, create a table to store Notes.
    debugPrint(path);
    var db = await openDatabase(
      path,
      version: versionNumber,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE IF NOT EXISTS $tableBottles ("
        " $colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $colName TEXT NOT NULL, "
        " $colSignature TEXT, "
        " $colVintageYear INTEGER, "
        " $colColor TEXT, "
        " $colAlcoholLevel REAL, "
        " $colGrapeVariety TEXT, "
        " $colCountry TEXT, "
        " $colArea TEXT, "
        " $colSubArea TEXT, "
        " $colImageUri TEXT, "
        " $colIsInCellar INTEGER DEFAULT TRUE, "
        " $colIsOpen INTEGER DEFAULT FALSE, "
        " $colClusterId INTEGER, "
        " $colClusterY INTEGER, "
        " $colClusterSubY INTEGER DEFAULT 0, "
        " $colClusterX REAL, "
        " $colCreatedAt INTEGER, "
        " $colRegisteredInCellarAt INTEGER, "
        " $colOpenedAt INTEGER, "
        " $colTastingNote TEXT "
        ")");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS $tableBottles");
    _onCreate(db, newVersion);
    //await db.setVersion(1);
  }

  Future<List<Bottle>> getAll() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all Bottles. {SELECT * FROM Bottles ORDER BY Id ASC}
    final result = await db.query(tableBottles, orderBy: '$colId ASC');

    // Convert the List<Map<String, dynamic> into a List<Bottle>.
    return result.map((json) => Bottle.fromMap(json)).toList();
  }

  Future<Map<int, List<Bottle>>> getByClusters() async {
    final db = await database;

    final result = await db.query(
        tableBottles,
        where: '$colIsOpen = FALSE AND $colClusterId IS NOT NULL',
        orderBy: '$colId ASC'
    );

    List<Bottle> rawList = result.map((json) => Bottle.fromMap(json)).toList();

    Map<int, List<Bottle>> bottleMap = {};
    for (Bottle bottle in rawList) {
      if (!bottleMap.containsKey(bottle.clusterId)) {
        bottleMap[bottle.clusterId!] = [];
      }
      bottleMap[bottle.clusterId]!.add(bottle);
    }
    return bottleMap;
  }

  Future<List<Bottle>> getInCluster(CellarCluster cluster) async {
    final db = await database;

    final result = await db.query(
        tableBottles,
        where: '$colClusterId = ?',
        whereArgs: [cluster.id],
        orderBy: '$colId ASC'
    );

    return result.map((json) => Bottle.fromMap(json)).toList();
  }

  Future<List<Bottle>> getClosed() async {
    final db = await database;

    final result = await db.query(
        tableBottles,
        where: '$colIsOpen = FALSE',
        orderBy: '$colId ASC'
    );

    return result.map((json) => Bottle.fromMap(json)).toList();
  }

  Future<List<Bottle>> getOpened() async {
    final db = await database;

    final result = await db.query(
        tableBottles,
        where: '$colIsOpen = TRUE',
        orderBy: '$colId ASC'
    );

    return result.map((json) => Bottle.fromMap(json)).toList();
  }

  Future<Bottle> read(int id) async {
    final db = await database;
    final maps = await db.query(
      tableBottles,
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Bottle.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> insert(Bottle bottle) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    return await db.insert(tableBottles, bottle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Define a function to update a note
  Future<int> update(Bottle bottle) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Note.
    var res = await db.update(tableBottles, bottle.toMap(),
        // Ensure that the Note has a matching id.
        where: '$colId = ?',
        // Pass the Note's id as a whereArg to prevent SQL injection.
        whereArgs: [bottle.id]);
    return res;
  }

  // Define a function to delete a note
  Future<void> delete(int id) async {
    // Get a reference to the database.
    final db = await database;
    try {
      // Remove the Note from the database.
      await db.delete(tableBottles,
          // Use a `where` clause to delete a specific Note.
          where: "$colId = ?",
          // Pass the Dog's id as a whereArg to prevent SQL injection.
          whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  Future<int> getCount() async {
    final db = await database;
    final maps = await db.query(tableBottles);

    return maps.length;
  }

  Future<int> getInCellarCount() async {
    final db = await database;
    final maps = await db.query(tableBottles, where: '$colIsOpen = FALSE');

    return maps.length;
  }

  Future<int> getOpenedCount() async {
    final db = await database;
    final maps = await db.query(tableBottles, where: '$colIsOpen = TRUE');

    return maps.length;
  }

  Future<int> getRedCount() async {
    final db = await database;
    final maps = await db.query(
        tableBottles,
        where: "$colColor = 'red'"
    );

    return maps.length;
  }

  Future<int> getPinkCount() async {
    final db = await database;
    final maps = await db.query(
        tableBottles,
        where: "$colColor = 'pink'"
    );

    return maps.length;
  }

  Future<int> getWhiteCount() async {
    final db = await database;
    final maps = await db.query(
        tableBottles,
        where: "$colColor = 'white'"
    );

    return maps.length;
  }

  Future<List<Bottle>> getLastBottles() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all Bottles. {SELECT * FROM Bottles ORDER BY Id ASC}
    final result = await db.query(
        tableBottles,
        where: '$colIsOpen = false',
        orderBy: '$colId DESC',
        limit: 5
    );

    // Convert the List<Map<String, dynamic> into a List<Bottle>.
    return result.map((json) => Bottle.fromMap(json)).toList();
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}