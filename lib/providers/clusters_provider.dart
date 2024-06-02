import 'dart:collection';

import 'package:cave_manager/models/cluster.dart';
import 'package:flutter/cupertino.dart';

import '../utils/cellar_db_interface.dart';

class ClustersProvider extends ChangeNotifier {
  CellarDatabaseInterface cellarDatabase = CellarDatabaseInterface.instance;
  List<CellarCluster> _cellars = [];
  UnmodifiableListView<CellarCluster> get cellars => UnmodifiableListView(_cellars);

  ClustersProvider() {
    loadCellars();
  }

  Future<void> loadCellars() async {
    _cellars = await cellarDatabase.getClusters();
    notifyListeners();
  }

  Future<void> addCellar(CellarCluster cluster) async {
    await cellarDatabase.insertCluster(cluster);
    loadCellars();
  }

  Future<void> updateCellar(CellarCluster cluster) async {
    await cellarDatabase.updateCluster(cluster);
    loadCellars();
  }

  Future<void> deleteCellar(CellarCluster cluster) async {
    if (cluster.id == null) {
      return;
    }

    await cellarDatabase.deleteCluster(cluster.id!);
    loadCellars();
  }
}