import 'dart:collection';

import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/widgets/bottle_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cluster.dart';
import '../../providers/bottles_provider.dart';
import '../../widgets/cellar_fillng.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/cellar_layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return CellarLayout(
      clusters: UnmodifiableListView([
        CellarCluster(
            id: 0,
            width: 10,
            height: 10,
            name: "Cluster 1"
        ),
        CellarCluster(
            id: 1,
            width: 8,
            height: 9,
            name: "Cluster 2"
        )
      ]),
      bottlesByClusterByRow: UnmodifiableMapView({
        0: {
          0: [],
          1: [],
          2: [],
          3: [],
          4: [],
          5: [],
          6: [],
          7: [],
          8: [],
          9: [],
        },
        1: {
          0: [],
          1: [],
          2: [],
          3: [],
          4: [],
          5: [],
          6: [],
          7: [],
          8: [],
          9: [],
        }
      }),
      clustersRowConfiguration: const {
        0: [10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
        1: [8, 8, 8, 8, 8, 8, 8, 8, 8, 8],
      },
      startingClusterId: 1,
    );
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(AppLocalizations.of(context)!.home),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(
                            title: AppLocalizations.of(context)!.settings)),
                  ),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Consumer<BottlesProvider>(
          builder:
              (BuildContext context, BottlesProvider bottles, Widget? child) =>
                  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CellarFilling(bottleAmount: bottles.closedBottles.length),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(
                      label: Text(
                          "${bottles.redCount} ${AppLocalizations.of(context)!.redWine}")),
                  Chip(
                      label: Text(
                          "${bottles.whiteCount} ${AppLocalizations.of(context)!.whiteWine}")),
                  Chip(
                      label: Text(
                          "${bottles.pinkCount} ${AppLocalizations.of(context)!.pinkWine}")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(AppLocalizations.of(context)!.lastRegisteredBottles,
                  style: const TextStyle(fontSize: 20)),
              bottles.lastBottles.isEmpty
                  ? Center(
                      child: Text(AppLocalizations.of(context)!
                          .noLastRegisteredBottles),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: bottles.lastBottles.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BottleCard(bottle: bottles.lastBottles[index]);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
