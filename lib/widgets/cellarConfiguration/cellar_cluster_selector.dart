import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/cellar_type_enum.dart';

class CellarClusterSelector extends StatefulWidget {
  const CellarClusterSelector(
      {super.key,
      required this.clusterSliderCallback,
      required this.clusterValue});

  final void Function(double) clusterSliderCallback;
  final double clusterValue;

  @override
  State<CellarClusterSelector> createState() => _CellarClusterSelectorState();
}

class _CellarClusterSelectorState extends State<CellarClusterSelector> {
  @override
  Widget build(BuildContext context) {
    ClustersProvider clusters = context.read<ClustersProvider>();
    String clusterLabel = 'Nombre de Porte Bouteilles';

    switch (clusters.cellarType) {
      case CellarType.holder:
        clusterLabel = 'Nombre de Porte Bouteilles';
        break;

      case CellarType.fridge:
        clusterLabel = "Nombre de frigo";
        break;

      default:
        clusterLabel = "";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Définissez les dimensions de votre cave", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 70,),
        Text(clusterLabel),
        Slider(
          label: widget.clusterValue.round().toString(),
          value: widget.clusterValue,
          onChanged: (double value) {
            HapticFeedback.vibrate();
            widget.clusterSliderCallback(value);
          },
          min: 1,
          max: 10,
          divisions: 9,
        ),
        const SizedBox(height: 50,),
      ],
    );
  }
}