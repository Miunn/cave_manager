import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../models/bottle.dart';
import '../utils/bottle_db_interface.dart';

class BottlesProvider extends ChangeNotifier {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  List<Bottle> _bottles = [];
  UnmodifiableListView<Bottle> get bottles => UnmodifiableListView(_bottles);
  UnmodifiableListView<Bottle> get closedBottles => UnmodifiableListView(_bottles.where((bottle) => !(bottle.isOpen ?? false)));
  UnmodifiableListView<Bottle> get openedBottles => UnmodifiableListView(_bottles.where((bottle) => (bottle.isOpen ?? true)));
  Bottle getBottleById(int id) => _bottles.firstWhere((bottle) => bottle.id == id);

  BottlesProvider() {
    loadBottles();
  }

  Future<void> loadBottles() async {
    _bottles = await bottleDatabase.getAll();
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