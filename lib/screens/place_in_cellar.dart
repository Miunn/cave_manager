import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bottle.dart';
import '../models/cellar_type_enum.dart';
import '../models/cluster.dart';
import '../utils/bottle_db_interface.dart';
import '../utils/cellar_db_interface.dart';
import '../widgets/cellar_layout.dart';

class PlaceInCellar extends StatefulWidget {
  const PlaceInCellar({super.key, required this.bottle});

  final Bottle bottle;

  @override
  State<StatefulWidget> createState() => _PlaceInCellarState();
}

class _PlaceInCellarState extends State<PlaceInCellar> {
  CellarDatabaseInterface cellarDatabase = CellarDatabaseInterface.instance;
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  bool isCellarBeingConfigured = false;
  CellarType cellarType = CellarType.none;
  int clusters = 0;
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
    Map<int, List<Bottle>> bottleList = await bottleDatabase.getByClusters();

    setState(() {
      cellarType = CellarType.values.firstWhere(
              (e) => e.value == prefs.getString("cellarType"),
          orElse: () => CellarType.none);
      cellarConfiguration = clusters;
      bottles = bottleList;
    });
  }

  bool isCellarConfigured() {
    return cellarType != CellarType.none;
  }

  Widget getCellarLayout() {
    if (isCellarConfigured()) {
      return CellarLayout(
          cellarType: cellarType,
          cellarConfiguration: cellarConfiguration,
          bottles: bottles,
        onTapEmptyCallback: (int clusterId, int row, int column) {
            //widget.bottle.cellarPosition = index;
          widget.bottle.clusterId = clusterId;
          widget.bottle.clusterY = row;
          widget.bottle.clusterX = column;
            Navigator.of(context).pop(widget.bottle);
        },
      );
    } else {
      return const Column(children: <Widget>[
        Center(child: CircularProgressIndicator()),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle bouteille"),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(widget.bottle);
            }),
      ),
      body: getCellarLayout(),
    );
  }
}
