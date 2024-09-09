import 'dart:collection';

import 'package:cave_manager/models/history.dart';
import 'package:cave_manager/utils/history_db_interface.dart';
import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryDatabaseInterface historyDatabase = HistoryDatabaseInterface.instance;

  List<History> _history = [];
  UnmodifiableListView<History> get history => UnmodifiableListView(_history);

  HistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    // Load history from database
    _history = await historyDatabase.getAll();
  }

}