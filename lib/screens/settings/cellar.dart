import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCellar extends StatefulWidget {
  const SettingsCellar({super.key});

  @override
  State<SettingsCellar> createState() => _SettingsCellarState();
}

class _SettingsCellarState extends State<SettingsCellar> {
  int cellarWidth = 0;
  int cellarHeight = 0;

  @override
  void initState() {
    super.initState();
    loadCellarConfiguration();
  }

  loadCellarConfiguration() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      cellarWidth = prefs.getInt('cellarWidth') ?? 0;
      cellarHeight = prefs.getInt('cellarHeight') ?? 0;
    });
  }

  wipeConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cellarType');
    prefs.remove('cellarWidth');
    prefs.remove('cellarHeight');
    prefs.remove('cellarBags');
    prefs.remove('cellarBagCapacity');
    loadCellarConfiguration();
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
          title: const Text('Configuration de la cave'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: <Widget>[
              Text("Largeur de la cave : $cellarWidth"),
              Text("Hauteur de la cave : $cellarHeight"),
              ElevatedButton(
                  onPressed: wipeConfiguration,
                  child: const Text('Wipe configuration')),
            ],
          ),
        ));
  }
}
