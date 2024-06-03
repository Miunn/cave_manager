import 'dart:collection';

import 'package:cave_manager/models/wine_colors_enum.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../utils/bottle_db_interface.dart';

class BottlesProvider extends ChangeNotifier {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  List<Bottle> _bottles = [];
  Map<int, List<Bottle>> bottlesByClusterId = {};
  UnmodifiableListView<Bottle> get bottles => UnmodifiableListView(_bottles);
  UnmodifiableListView<Bottle> get closedBottles => UnmodifiableListView(_bottles.where((bottle) => !(bottle.isOpen ?? false)));
  UnmodifiableListView<Bottle> get openedBottles => UnmodifiableListView(_bottles.where((bottle) => (bottle.isOpen ?? true)));
  UnmodifiableListView<Bottle> get lastBottles => UnmodifiableListView(closedBottles.take(5));
  UnmodifiableMapView<int, UnmodifiableListView<Bottle>> get sortedBottlesByCluster {
    Map<int, UnmodifiableListView<Bottle>> unmodifiableBottlesByClusterId = {};

    for (int clusterId in bottlesByClusterId.keys) {
      unmodifiableBottlesByClusterId[clusterId] = UnmodifiableListView(bottlesByClusterId[clusterId]!);
    }

    return UnmodifiableMapView(unmodifiableBottlesByClusterId);
  }

  int get bottleCount => _bottles.length;
  int get redCount => closedBottles.where((bottle) => bottle.color == WineColors.red.value).length;
  int get pinkCount => closedBottles.where((bottle) => bottle.color == WineColors.pink.value).length;
  int get whiteCount => closedBottles.where((bottle) => bottle.color == WineColors.white.value).length;

  Bottle getBottleById(int id) => _bottles.firstWhere((bottle) => bottle.id == id, orElse: () => Bottle(null, null, null));

  BottlesProvider() {
    loadBottles();
  }

  Future<void> loadBottles() async {
    _bottles = await bottleDatabase.getAll();
    for (Bottle bottle in closedBottles) {
      if (bottle.clusterId == null) {
        continue;
      }

      if (bottlesByClusterId[bottle.clusterId!] == null) {
        bottlesByClusterId[bottle.clusterId!] = [];
      }

      bottlesByClusterId[bottle.clusterId!]!.add(bottle);
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
}