import 'package:cave_manager/screens/add_bottle_dialog.dart';
import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/utils/bottle_db_interface.dart';
import 'package:cave_manager/widgets/bottle_list_card.dart';
import 'package:flutter/material.dart';

import '../models/bottle.dart';

class Bottles extends StatefulWidget {
  const Bottles({super.key, required this.title});

  final String title;

  @override
  State<Bottles> createState() => _BottlesState();
}

class _BottlesState extends State<Bottles> {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  List<Bottle> closedBottles = [];
  List<Bottle> openedBottles = [];

  @override
  void initState() {
    refreshBottles();
    super.initState();
  }

  refreshBottles() async {
    closedBottles = await bottleDatabase.getClosed();
    openedBottles = await bottleDatabase.getOpened();
    setState(() {
      closedBottles = closedBottles;
      openedBottles = openedBottles;
    });
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
        title: const Text("Bouteilles"),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings(title: "Paramètres")),
              ),
              icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (closedBottles.length > 1)
                  ? Text(
                      "${closedBottles.length} Bouteilles en cave",
                      style: const TextStyle(fontSize: 15),
                    )
                  : Text(
                      "${closedBottles.length} Bouteille en cave",
                      style: const TextStyle(fontSize: 15),
                    ),
              Visibility(
                visible: closedBottles.isEmpty,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Aucune bouteille en cave",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: closedBottles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BottleListCard(bottle: closedBottles[index]);
                  }),
              const SizedBox(
                height: 20,
              ),
              (openedBottles.length > 1)
                  ? Text(
                      "${openedBottles.length} Bouteilles ouvertes",
                      style: const TextStyle(fontSize: 15),
                    )
                  : Text(
                      "${openedBottles.length} Bouteille ouverte",
                      style: const TextStyle(fontSize: 15),
                    ),
              Visibility(
                visible: openedBottles.isEmpty,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Aucune bouteille ouverte",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: openedBottles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BottleListCard(bottle: openedBottles[index]);
                  }),
            ],
          ),
        ),
      ),
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
          refreshBottles();
        },
        tooltip: "Insert new bottle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
