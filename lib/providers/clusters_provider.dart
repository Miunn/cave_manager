
import 'package:cave_manager/models/enum_cellar_type.dart';
import 'package:cave_manager/models/cluster.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/cellar_db_interface.dart';
import 'bottles_provider.dart';

class ClustersProvider extends ChangeNotifier {
  CellarDatabaseInterface cellarDatabase = CellarDatabaseInterface.instance;
  CellarType _cellarType = CellarType.none;
  List<CellarCluster> _clusters = [];
  Map<int, List<int>> _clustersRowConfiguration = {};

  CellarType get cellarType => _cellarType;
  Map<int, List<int>> get clustersRowConfiguration => _clustersRowConfiguration;


  UnmodifiableListView<CellarCluster> get clusters =>
      UnmodifiableListView(_clusters);

  bool get isCellarConfigured =>
      _cellarType != CellarType.none && clusters.isNotEmpty;

  ClustersProvider() {
    loadCellar();
  }

  Future<void> loadClusters() async {
    _clusters = await cellarDatabase.getClusters();
    notifyListeners();
  }

  Future<void> loadClustersRowConfiguration() async {
    _clustersRowConfiguration = await cellarDatabase.getClustersRowConfiguration();
    notifyListeners();
  }

  Future<void> loadCellar() async {
    final prefs = await SharedPreferences.getInstance();
    _cellarType = CellarType.values.firstWhere(
      (e) => e.value == prefs.getString("cellarType"),
      orElse: () => CellarType.none,
    );
    loadClusters();
    loadClustersRowConfiguration();
  }

  Future<void> addCluster(CellarCluster cluster) async {
    await cellarDatabase.insertCluster(cluster);
    loadClusters();
  }

  Future<void> updateCluster(CellarCluster cluster) async {
    await cellarDatabase.updateCluster(cluster);
    loadClusters();
  }

  Future<void> deleteCluster(CellarCluster cluster) async {
    if (cluster.id == null) {
      return;
    }

    await cellarDatabase.deleteCluster(cluster.id!);
    loadClusters();
  }

  Future<void> setCellarType(CellarType cellarType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cellarType", cellarType.value);
    _cellarType = cellarType;
    notifyListeners();
  }

  Future<void> setCellarConfiguration(
      List<CellarCluster> cellarConfiguration) async {
    cellarDatabase.insertAll(cellarConfiguration);
    loadClusters();
  }

  CellarCluster? getClusterById(int id) =>
      _clusters.firstWhereOrNull((cluster) => cluster.id == id);

  void updateClustersRowConfiguration(int clusterId, int row, int customWidth) {
    cellarDatabase.updateClusterRowConfiguration(clusterId, row, customWidth);
    loadClustersRowConfiguration();
  }

  Future<void> wipe(BuildContext context) async {
    // Remove bottles cluster associations
    await Provider.of<BottlesProvider>(context, listen: false).wipeClusterAssociations();

    // Wipe clusters
    await cellarDatabase.wipe();

    // Reload empty configuration
    loadClusters();
    loadClustersRowConfiguration();
  }
}
