import 'package:cave_manager/screens/cellar/cellar_customization.dart';
import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/widgets/cellar_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/clusters_provider.dart';
import '../../widgets/cellar_configuration.dart';

class Cellar extends StatefulWidget {
  const Cellar({super.key});

  @override
  State<Cellar> createState() => _CellarState();
}

class _CellarState extends State<Cellar> {
  bool isCellarBeingConfigured = false;

  Widget getCellarLayout(bool cellarConfigured) {
    if (cellarConfigured) {
      return const CellarLayout();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: cellarConfigured
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
                child: const CellarConfiguration(),
              )
            ]),
      ),
    );
  }

  List<Widget> getActionsList(bool cellarConfigured) {
    List<Widget> actions = <Widget>[];

    if (cellarConfigured) {
      actions.add(IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CellarCustomization(),
          ),
        ),
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
    ClustersProvider clusters = context.watch<ClustersProvider>();

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Cave"),
        actions: getActionsList(clusters.isCellarConfigured),
      ),
      body: getCellarLayout(clusters.isCellarConfigured),
    );
  }
}
