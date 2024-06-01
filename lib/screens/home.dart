import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/utils/bottle_db_interface.dart';
import 'package:cave_manager/widgets/bottle_card.dart';
import 'package:flutter/material.dart';

import '../models/bottle.dart';
import '../widgets/cellar_fillng.dart';
import 'add_bottle_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  List<Bottle> _lastBottles = [];
  int _totalBottles = 0;
  int _redCount = 0;
  int _pinkCount = 0;
  int _whiteCount = 0;

  @override
  void initState() {
    debugPrint("Init state home");
    refreshBottlesState();
    super.initState();
  }

  refreshBottlesState() async {
    _lastBottles = await bottleDatabase.getLastBottles();
    _totalBottles = await bottleDatabase.getInCellarCount();
    _redCount = await bottleDatabase.getRedCount();
    _pinkCount = await bottleDatabase.getPinkCount();
    _whiteCount = await bottleDatabase.getWhiteCount();
    setState(() {
      _lastBottles = _lastBottles;
      _totalBottles = _totalBottles;
      _redCount = _redCount;
      _pinkCount = _pinkCount;
      _whiteCount = _whiteCount;
    });
  }

  openBottle(Bottle bottle) {
    bottle.isOpen = true;
    bottleDatabase.update(bottle);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Bouteille sortie de cave'),
      action: SnackBarAction(
        label: 'Annuler',
        onPressed: () {
          bottle.isOpen = false;
          bottle.tastingNote = null;
          bottleDatabase.update(bottle);
          refreshBottlesState();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Bouteille remise en cave'),
          ));
        },
      ),
    ));
    refreshBottlesState();
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
        title: const Text("Accueil"),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CellarFilling(
              bottleAmount: _totalBottles,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Chip(label: Text("$_redCount Vin rouge")),
                Chip(label: Text("$_whiteCount Vin blanc")),
                Chip(label: Text("$_pinkCount Vin rosé")),
              ],
            ),
            const SizedBox(height: 20,),
            const Text(
              "Dernières bouteilles enregistrées",
              style: TextStyle(fontSize: 20),
            ),
            _lastBottles.isEmpty
                ? const Center(
                    child: Text("Aucune bouteille enregistrée récemment"),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _lastBottles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BottleCard(
                            bottle: _lastBottles[index],
                            openBottleCallback: openBottle);
                      },
                    ),
                  ),
          ],
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
          refreshBottlesState();
        },
        tooltip: "Insert new bottle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
