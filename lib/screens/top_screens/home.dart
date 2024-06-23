import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/widgets/bottle_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bottle.dart';
import '../../providers/bottles_provider.dart';
import '../../widgets/cellar_fillng.dart';
import '../add_bottle_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        title: const Text("Accueil"),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Settings(title: "Paramètres")),
                  ),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<BottlesProvider>(
              builder: (context, bottles, child) {
                return CellarFilling(bottleAmount: bottles.closedBottles.length);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<BottlesProvider>(builder: (context, bottles, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(label: Text("${bottles.redCount} Vin rouge")),
                  Chip(label: Text("${bottles.whiteCount} Vin blanc")),
                  Chip(label: Text("${bottles.pinkCount} Vin rosé")),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Dernières bouteilles enregistrées",
              style: TextStyle(fontSize: 20),
            ),
            Consumer<BottlesProvider>(
              builder: (context, bottles, child) {
                return bottles.lastBottles.isEmpty
                    ? const Center(
                        child: Text("Aucune bouteille enregistrée récemment"),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: bottles.lastBottles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BottleCard(
                                bottleId: bottles.lastBottles[index].id!);
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<Bottle>(
              fullscreenDialog: true,
              builder: (BuildContext context) => const AddBottleDialog()));
        },
        tooltip: "Insert new bottle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
