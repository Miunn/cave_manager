import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../models/bottle.dart';
import '../utils/bottle_db_interface.dart';

class BottleProvider extends ChangeNotifier {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  List<Bottle> _bottles = [];
  UnmodifiableListView<Bottle> get bottles => UnmodifiableListView(_bottles);

  BottleProvider() {
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
}