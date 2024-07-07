import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enum_cellar_type.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CellarTypeSelector extends StatefulWidget {
  const CellarTypeSelector({super.key});

  @override
  State<CellarTypeSelector> createState() => _CellarTypeSelectorState();
}

class _CellarTypeSelectorState extends State<CellarTypeSelector> {
  @override
  Widget build(BuildContext context) {
    ClustersProvider clusters = context.watch<ClustersProvider>();

    return Column(
      children: [
        Text(AppLocalizations.of(context)!.cellarTopologySelection, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        Wrap(
          verticalDirection: VerticalDirection.up,
          alignment: WrapAlignment.center,
          runSpacing: 4.0,
          spacing: 4.0,
          children: <Widget>[
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    color: (clusters.cellarType == CellarType.bags)
                        ? Colors.blue
                        : Theme.of(context).colorScheme.outlineVariant),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => clusters.setCellarType(CellarType.bags),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 60,
                        child: Icon(Icons.shopping_bag),
                      ),
                      Text(AppLocalizations.of(context)!.clusterNameContainers),
                    ]),
                  ),
                ),
              ),
            ),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    color: (clusters.cellarType == CellarType.fridge)
                        ? Colors.blue
                        : Theme.of(context).colorScheme.outlineVariant),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => clusters.setCellarType(CellarType.fridge),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 60,
                        child: Icon(Icons.kitchen_outlined),
                      ),
                      Text(AppLocalizations.of(context)!.clusterNameFridge),
                    ]),
                  ),
                ),
              ),
            ),
            Card.outlined(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    color: (clusters.cellarType == CellarType.holder)
                        ? Colors.blue
                        : Theme.of(context).colorScheme.outlineVariant),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => clusters.setCellarType(CellarType.holder),
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(children: <Widget>[
                      const SizedBox(
                          height: 60,
                          child: Icon(Icons.align_vertical_bottom_outlined)),
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context)!.clusterNameWineRack),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
