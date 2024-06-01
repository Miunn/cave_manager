import 'package:cave_manager/models/cluster.dart';
import 'package:flutter/material.dart';

import '../../models/cellar_type_enum.dart';

class CellarSummary extends StatelessWidget {
  const CellarSummary(
      {super.key,
      required this.cellarType,
      required this.clusters,
      required this.cellarConfiguration});

  final CellarType cellarType;
  final int clusters;
  final List<CellarCluster> cellarConfiguration;

  @override
  Widget build(BuildContext context) {
    String clusterLabel = 'Nombre de Porte Bouteilles';
    String cellarWidthLabel = 'Nombre de colonnes';
    String cellarHeightLabel = 'Nombre de lignes';

    switch (cellarType) {
      case CellarType.holder:
        clusterLabel = 'Nombre de Porte Bouteilles';
        break;

      case CellarType.bags:
        clusterLabel = "";
        break;

      case CellarType.fridge:
        clusterLabel = "Nombre de frigo";
        break;

      default:
        clusterLabel = "";
        break;
    }

    switch (cellarType) {
      case CellarType.holder:
        cellarWidthLabel = 'Nombre de colonnes';
        break;

      case CellarType.bags:
        cellarWidthLabel = "Capacité d'un contenant";
        break;

      case CellarType.fridge:
        cellarWidthLabel = "Capacité d'un niveau";
        break;
      default:
        cellarWidthLabel = "";
        break;
    }

    switch (cellarType) {
      case CellarType.holder:
        cellarHeightLabel = 'Nombre de lignes';
        break;

      case CellarType.bags:
        cellarHeightLabel = "Nombre de contenant";
        break;

      case CellarType.fridge:
        cellarHeightLabel = "Nombre de niveaux";
        break;
      default:
        cellarHeightLabel = "";
        break;
    }

    // Build dynamic UI
    List<Widget> cellarConfigurationWidgets = [];
    int capacity = 0;

    debugPrint(cellarConfiguration.toString());
    for (int i = 0; i < cellarConfiguration.length; i++) {
      CellarCluster cluster = cellarConfiguration[i];
      capacity += (cluster.width ?? 0) * (cluster.height ?? 0);
      cellarConfigurationWidgets.addAll([
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            cluster.name ?? "${cellarType.label} $i",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const Divider(
          height: 1,
          color: Color.fromARGB(255, 220, 220, 220),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(cellarWidthLabel),
              const Spacer(),
              Text(((cluster.width ?? 0) <= 1)
                  ? "${cluster.width} bouteille"
                  : "${cluster.width} bouteilles"),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Color.fromARGB(255, 220, 220, 220),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(cellarHeightLabel),
              const Spacer(),
              Text(((cluster.height ?? 0) <= 1)
                  ? "${cluster.height} bouteille"
                  : "${cluster.height} bouteilles"),
            ],
          ),
        ),
      ]);
      cellarConfigurationWidgets.add(const Divider(
        height: 1,
        color: Color.fromARGB(255, 220, 220, 220),
      ));
    }

    return Column(
      children: [
        const Text("Résumé de votre configuration",
            style: TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 220, 220, 220)),
              borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Text("Type de cave"),
                    const Spacer(),
                    Text(
                      cellarType.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                color: Color.fromARGB(255, 220, 220, 220),
              ),
              Visibility(
                visible: cellarType != CellarType.bags,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(clusterLabel),
                      const Spacer(),
                      Text("$clusters"),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: cellarType != CellarType.bags,
                child: const Divider(
                  height: 1,
                  color: Color.fromARGB(255, 220, 220, 220),
                ),
              ),
              ...cellarConfigurationWidgets,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Text(
                      "Capacité totale",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      (capacity <= 1)
                          ? "$capacity bouteille"
                          : "$capacity bouteilles",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
