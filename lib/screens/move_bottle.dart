import 'package:flutter/material.dart';

import '../models/bottle.dart';
import '../widgets/cellar_layout.dart';

class MoveBottle extends StatefulWidget {
  const MoveBottle({super.key, required this.bottle});

  final Bottle bottle;

  @override
  State<MoveBottle> createState() => _MoveBottleState();
}

class _MoveBottleState extends State<MoveBottle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Déplacer une bouteille"),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: CellarLayout(
        onTapEmptyCallback: (int clusterId, int row, int column) {
          widget.bottle.clusterId = clusterId;
          widget.bottle.clusterY = row;
          widget.bottle.clusterX = column;
          Navigator.of(context).pop(widget.bottle);
        },
        blinkingBottleId: widget.bottle.id,
        startingClusterId: widget.bottle.clusterId,
      ),
    );
  }
}