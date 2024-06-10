import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/utils/bottle_db_interface.dart';
import 'package:cave_manager/widgets/cellar_filling_short.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  int _inCellarBottles = 0;
  int _openedBottles = 0;
  int _redCount = 0;
  int _pinkCount = 0;
  int _whiteCount = 0;

  @override
  void initState() {
    refreshStatisticsState();
    super.initState();
  }

  refreshStatisticsState() async {
    _inCellarBottles = await bottleDatabase.getInCellarCount();
    _openedBottles = await bottleDatabase.getOpenedCount();
    _redCount = await bottleDatabase.getRedCount();
    _pinkCount = await bottleDatabase.getPinkCount();
    _whiteCount = await bottleDatabase.getWhiteCount();
    setState(() {
      _inCellarBottles = _inCellarBottles;
      _openedBottles = _openedBottles;
      _redCount = _redCount;
      _pinkCount = _pinkCount;
      _whiteCount = _whiteCount;
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
        title: const Text("Statistiques"),
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
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(

          children: <Widget>[
            Center(
              child: Wrap(
                runSpacing: 30.0,
                spacing: 50.0,
                children: <Widget>[
                  CellarFillingShort(
                    bottleAmount: _inCellarBottles,
                    text: "En cave",
                  ),
                  CellarFillingShort(
                    bottleAmount: _redCount,
                    text: "Vin rouge",
                  ),
                  CellarFillingShort(
                    bottleAmount: _pinkCount,
                    text: "Vin rosé",
                  ),
                  CellarFillingShort(
                    bottleAmount: _whiteCount,
                    text: "Vin blanc",
                  ),
                  CellarFillingShort(
                    bottleAmount: _openedBottles,
                    text: "Ouvertes",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
