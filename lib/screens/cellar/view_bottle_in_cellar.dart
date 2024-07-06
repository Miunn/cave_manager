import 'package:flutter/material.dart';

import '../../models/bottle.dart';
import '../../widgets/cellar_layout.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewBottleInCellar extends StatefulWidget {
  const ViewBottleInCellar({super.key, required this.bottle});

  final Bottle bottle;

  @override
  State<ViewBottleInCellar> createState() => _ViewBottleInCellarState();
}

class _ViewBottleInCellarState extends State<ViewBottleInCellar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bottleInCellar(widget.bottle.name ?? "")),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: CellarLayout(
        blinkingBottleId: widget.bottle.id,
        startingClusterId: widget.bottle.clusterId,
      ),
    );
  }
}