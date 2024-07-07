import 'package:cave_manager/models/cluster.dart';
import 'package:flutter/material.dart';

import '../../models/enum_cellar_type.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CellarSummary extends StatelessWidget {
  const CellarSummary(
      {super.key,
        required this.cellarType,
        required this.clustersConfiguration,});

  final CellarType cellarType;
  final List<CellarCluster> clustersConfiguration;

  @override
  Widget build(BuildContext context) {
    String clusterLabel = AppLocalizations.of(context)!.clusterNameAmount(cellarType);
    String cellarWidthLabel = AppLocalizations.of(context)!.clusterRackWidth;
    String cellarHeightLabel = AppLocalizations.of(context)!.clusterRackHeight;

    switch (cellarType) {
      case CellarType.holder:
        cellarWidthLabel = AppLocalizations.of(context)!.clusterRackWidth;
        break;

      case CellarType.bags:
        cellarWidthLabel = AppLocalizations.of(context)!.clusterContainersWidth;
        break;

      case CellarType.fridge:
        cellarWidthLabel = AppLocalizations.of(context)!.clusterFridgeWidth;
        break;
      default:
        cellarWidthLabel = "";
        break;
    }

    switch (cellarType) {
      case CellarType.holder:
        cellarHeightLabel = AppLocalizations.of(context)!.clusterRackHeight;
        break;

      case CellarType.bags:
        cellarHeightLabel = AppLocalizations.of(context)!.clusterContainersHeight;
        break;

      case CellarType.fridge:
        cellarHeightLabel = AppLocalizations.of(context)!.clusterFridgeHeight;
        break;
      default:
        cellarHeightLabel = "";
        break;
    }

    // Build dynamic UI
    List<Widget> cellarConfigurationWidgets = [];
    int capacity = 0;

    for (int i = 0; i < clustersConfiguration.length; i++) {
      CellarCluster cluster = clustersConfiguration[i];
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
              Text(AppLocalizations.of(context)!.bottlesTotal(cluster.width ?? 0)),
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
              Text(AppLocalizations.of(context)!.bottlesTotal(cluster.height ?? 0)),
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
        Text(AppLocalizations.of(context)!.cellarSummary, style: const TextStyle(fontSize: 15)),
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
                    Text(AppLocalizations.of(context)!.cellarType),
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
                      Text("${clustersConfiguration.length}"),
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
                    Text(AppLocalizations.of(context)!.cellarTotalCapacity, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(AppLocalizations.of(context)!.bottlesTotal(capacity), style: const TextStyle(fontWeight: FontWeight.bold)),
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
