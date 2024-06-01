import 'package:cave_manager/screens/settings/cellar.dart';
import 'package:cave_manager/widgets/cellar_filling_short.dart';
import 'package:flutter/material.dart';

import '../utils/bottle_db_interface.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.title});

  final String title;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
  int _totalBottles = 0;

  @override
  void initState() {
    super.initState();
    getState();
  }

  getState() async {
    _totalBottles = await bottleDatabase.getInCellarCount();

    setState(() {
      _totalBottles = _totalBottles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CellarFillingShort(
              bottleAmount: _totalBottles,
              text: _totalBottles > 1
                  ? 'Bouteilles en cave'
                  : 'Bouteille en cave',
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    debugPrint("Tap général");
                  },
                  child: const ListTile(
                    leading: Icon(Icons.tune),
                    title: Text("Général"),
                    subtitle: Text("Langue, Pays par défaut"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    debugPrint("Tap Apparence");
                  },
                  child: const ListTile(
                    leading: Icon(Icons.palette_outlined),
                    title: Text("Apparence"),
                    subtitle: Text("Thème de l'application"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CellarSettings(),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.storefront),
                    title: Text("Cave"),
                    subtitle: Text("Capacité, Topologie"),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
