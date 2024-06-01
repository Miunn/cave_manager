import 'dart:convert';

import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/utils/bottle_db_interface.dart';
import 'package:cave_manager/utils/cellar_db_interface.dart';
import 'package:cave_manager/widgets/cellar_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bottle.dart';
import '../models/cellar_type_enum.dart';
import '../models/cluster.dart';
import '../widgets/cellar_configuration.dart';
import 'add_bottle_dialog.dart';

class Cellar extends StatefulWidget {
  const Cellar({super.key, required this.title});

  final String title;

  @override
  State<Cellar> createState() => _CellarState();
}

class _CellarState extends State<Cellar> {
  CellarDatabaseInterface cellarDatabase = CellarDatabaseInterface.instance;
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  bool isCellarBeingConfigured = false;
  CellarType cellarType = CellarType.none;
  List<CellarCluster> cellarConfiguration = [];
  Map<int, List<Bottle>> bottles = {};

  @override
  void initState() {
    super.initState();
    loadCellar();
  }

  Future<void> loadCellar() async {
    final prefs = await SharedPreferences.getInstance();

    List<CellarCluster> clusters = await cellarDatabase.getClusters();
    Map<int, List<Bottle>> bottleMap = await bottleDatabase.getByClusters();

    for (int clusterId in bottleMap.keys) {
      List<Bottle> clusterBottles = bottleMap[clusterId]!;
      clusterBottles.sort((a, b) {
        return (a.clusterY! * clusters[clusterId].width! + a.clusterX!)
            .compareTo(b.clusterY! * clusters[clusterId].width! + b.clusterX!);
      });
    }

    debugPrint("Clusters: $clusters");
    debugPrint("Bottles: $bottleMap");
    setState(() {
      cellarType = CellarType.values.firstWhere(
          (e) => e.value == prefs.getString("cellarType"),
          orElse: () => CellarType.none);
      cellarConfiguration = clusters;
      bottles = bottleMap;
    });
  }

  Future<void> setCellarConfiguration(CellarType cellarType, int clusters, List<CellarCluster> cellarConfiguration) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("cellarType", cellarType.value);

    cellarDatabase.insertAll(cellarConfiguration);

    loadCellar();
  }

  bool isCellarConfigured() {
    return cellarType != CellarType.none && cellarConfiguration.isNotEmpty;
  }

  Widget getCellarLayout() {
    if (isCellarConfigured()) {
      return CellarLayout(
        cellarType: cellarType,
        cellarConfiguration: cellarConfiguration,
        bottles: bottles,
        onTapEmptyCallback: (int clusterId, int row, int col) {},
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: isCellarConfigured()
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                visible: !isCellarBeingConfigured,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCellarBeingConfigured = true;
                    });
                  },
                  child: const Text("Configurer votre cave"),
                ),
              ),
              Visibility(
                visible: isCellarBeingConfigured,
                child: CellarConfiguration(
                  submitCallback: setCellarConfiguration,
                ),
              )
            ]),
      ),
    );
  }

  List<Widget> getActionsList() {
    List<Widget> actions = <Widget>[];

    if (isCellarConfigured()) {
      actions.add(IconButton(
        onPressed: () => {},
        icon: const Icon(Icons.tune),
      ));
    }
    actions.add(IconButton(
        onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Settings(title: "Paramètres")),
            ),
        icon: const Icon(Icons.settings)));

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Cave"),
        actions: getActionsList(),
      ),
      body: getCellarLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Bottle? newBottle = await Navigator.of(context).push(
              MaterialPageRoute<Bottle>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => const AddBottleDialog()));

          if (newBottle == null) {
            return;
          }

          await bottleDatabase.insert(newBottle);
          loadCellar();
        },
        tooltip: "Insert new bottle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
