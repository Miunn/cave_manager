import 'dart:collection';

import 'package:cave_manager/models/enum_wine_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../models/bottle.dart';
import '../utils/bottle_db_interface.dart';

class BottlesProvider extends ChangeNotifier {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  List<Bottle> _bottles = [];
  final Map<int, Map<int, List<Bottle>>> _bottlesByClusterIdByRow = {};
  UnmodifiableListView<Bottle> get bottles => UnmodifiableListView(_bottles);
  UnmodifiableListView<Bottle> get closedBottles => UnmodifiableListView(_bottles.where((bottle) => !(bottle.isOpen ?? false)));
  UnmodifiableListView<Bottle> get openedBottles => UnmodifiableListView(_bottles.where((bottle) => (bottle.isOpen ?? true)));
  UnmodifiableListView<Bottle> get lastBottles => UnmodifiableListView(closedBottles.take(5).toList().reversed);
  UnmodifiableMapView<int, Map<int, List<Bottle>>> get sortedBottlesByClusterByRow {
    Map<int, Map<int, List<Bottle>>> bottlesByClusterIdByRow = {};

    for (int clusterId in _bottlesByClusterIdByRow.keys) {
      bottlesByClusterIdByRow[clusterId] = {};

      for (int row in _bottlesByClusterIdByRow[clusterId]!.keys) {
        bottlesByClusterIdByRow[clusterId]![row] = _bottlesByClusterIdByRow[clusterId]![row]!;
      }
    }

    return UnmodifiableMapView(bottlesByClusterIdByRow);
  }

  int get bottleCount => _bottles.length;
  int get redCount => closedBottles.where((bottle) => bottle.color == WineColors.red.value).length;
  int get pinkCount => closedBottles.where((bottle) => bottle.color == WineColors.pink.value).length;
  int get whiteCount => closedBottles.where((bottle) => bottle.color == WineColors.white.value).length;
  int? get lowestYear => closedBottles.fold(null, (int? min, bottle) => (bottle.vintageYear == null) ? min : (min == null || bottle.vintageYear! < min ? bottle.vintageYear : min));
  int? get highestYear => closedBottles.fold(null, (int? max, bottle) => (bottle.vintageYear == null) ? max : (max == null || bottle.vintageYear! > max ? bottle.vintageYear : max));

  Bottle getBottleById(int id) => _bottles.firstWhere((bottle) => bottle.id == id, orElse: () => Bottle(null, null, null));

  BottlesProvider() {
    loadBottles();
  }

  Future<void> loadBottles() async {
    _bottles = await bottleDatabase.getAll();
    debugPrint("Bottles: $_bottles");
    _bottlesByClusterIdByRow.clear();
    for (Bottle bottle in closedBottles) {
      if (bottle.clusterId == null) {
        continue;
      }

      if (_bottlesByClusterIdByRow[bottle.clusterId!] == null) {
        _bottlesByClusterIdByRow[bottle.clusterId!] = {};
      }

      if (_bottlesByClusterIdByRow[bottle.clusterId!]![bottle.clusterY!] == null) {
        _bottlesByClusterIdByRow[bottle.clusterId!]![bottle.clusterY!] = [];
      }
      _bottlesByClusterIdByRow[bottle.clusterId!]![bottle.clusterY]!.add(bottle);
    }

    // Sorting bottles to displayed all of them correctly
    for (int clusterId in _bottlesByClusterIdByRow.keys) {
      for (int row in _bottlesByClusterIdByRow[clusterId]!.keys) {
        _bottlesByClusterIdByRow[clusterId]![row]!.sort((bottle1, bottle2) {
          if (bottle1.clusterY == bottle2.clusterY) {
            return bottle1.clusterX!.compareTo(bottle2.clusterX!);
          }

          return bottle1.clusterY!.compareTo(bottle2.clusterY!);
        });
      }
    }

    notifyListeners();
  }

  Future<void> addBottle(Bottle bottle) async {
    await bottleDatabase.insert(bottle);
    loadBottles();
  }

  Future<void> updateBottle(Bottle bottle) async {
    await bottleDatabase.update(bottle);
    loadBottles();
  }

  Future<void> deleteBottle(Bottle bottle) async {
    if (bottle.id == null) {
      return;
    }

    await bottleDatabase.delete(bottle.id!);
    loadBottles();
  }

  Future<void> openBottle(Bottle bottle) async {
    bottle.isOpen = true;
    await updateBottle(bottle);
  }

  List<Bottle> searchBottles(String query) {
    return _bottles.where((bottle) => bottle.name!.toLowerCase().contains(query.toLowerCase())).toList();
  }

  Future<void> wipeClusterAssociations() async {
    for (Bottle bottle in _bottles) {
      bottle.clusterId = null;
      bottle.clusterX = null;
      bottle.clusterY = null;
      bottle.isInCellar = false;
      bottle.registeredInCellarAt = null;
      await updateBottle(bottle);
    }
  }
}