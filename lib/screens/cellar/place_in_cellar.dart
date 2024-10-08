import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bottle.dart';
import '../../widgets/cellar_layout.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaceInCellar extends StatefulWidget {
  const PlaceInCellar({super.key, required this.bottle});

  final Bottle bottle;

  @override
  State<StatefulWidget> createState() => _PlaceInCellarState();
}

class _PlaceInCellarState extends State<PlaceInCellar> {
  Map<int, List<Bottle>> bottles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newBottle),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(widget.bottle);
            }),
      ),
      body: Consumer<ClustersProvider>(
        builder: (context, clusters, child) => CellarLayout(
          onTapEmptyCallback: (int clusterId, int row, int subRow, int column) {
            //widget.bottle.cellarPosition = index;
            widget.bottle.clusterId = clusterId;
            widget.bottle.clusterY = row;
            widget.bottle.clusterSubY = subRow;
            widget.bottle.clusterX = column;
            Navigator.of(context).pop(widget.bottle);
          },
          shouldDisplayNewSubRow: true,
        ),
      ),
    );
  }
}
