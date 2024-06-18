import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsCellar extends StatefulWidget {
  const SettingsCellar({super.key});

  @override
  State<SettingsCellar> createState() => _SettingsCellarState();
}

class _SettingsCellarState extends State<SettingsCellar> {
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
              Consumer(builder: (BuildContext context,
                  ClustersProvider clusters, Widget? child) {
                return CellarSummary(
                    cellarType: clusters.cellarType,
                    clustersConfiguration: clusters.clusters);
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {

                  },
                  child: const Text("Supprimer"),
                ),
              )
            ],
          ),
        ));
  }
}
