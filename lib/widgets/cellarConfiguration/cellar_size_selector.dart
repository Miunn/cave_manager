import 'package:cave_manager/models/enum_cellar_type.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cluster.dart';

class CellarSizeSelector extends StatefulWidget {
  const CellarSizeSelector(
      {super.key,
      required this.clusterStep,
      required this.totalClusterStep,
      required this.clusterConfiguration});

  final int clusterStep;
  final int totalClusterStep;
  final CellarCluster clusterConfiguration;

  @override
  State<CellarSizeSelector> createState() => _CellarSizeSelectorState();
}

class _CellarSizeSelectorState extends State<CellarSizeSelector> {
  //  To reset fields every time
  final TextEditingController nameController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // On back and forth, restore previous values
    ClustersProvider clusters = context.read<ClustersProvider>();
    nameController.text = widget.clusterConfiguration.name ?? "";
    widthController.text = (widget.clusterConfiguration.width ?? "").toString();
    heightController.text = (widget.clusterConfiguration.height ?? "").toString();

    String widthLabel = 'Nombre de colonnes';
    String heightLabel = 'Nombre de lignes';

    switch (clusters.cellarType) {
      case CellarType.holder:
        widthLabel = 'Nombre de colonnes';
        break;

      case CellarType.bags:
        widthLabel = "Capacité d'un contenant";
        break;

      case CellarType.fridge:
        widthLabel = "Capacité d'un niveau";
        break;

      default:
        widthLabel = "";
        break;
    }

    switch (clusters.cellarType) {
      case CellarType.holder:
        heightLabel = 'Nombre de lignes';
        break;

      case CellarType.bags:
        heightLabel = 'Nombre de contenants';
        break;

      case CellarType.fridge:
        heightLabel = 'Nombre de niveaux';
        break;

      default:
        heightLabel = "";
        break;
    }

    return Center(
      child: SizedBox(
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Définissez les dimensions de votre cave",
                style: TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            Visibility(
                visible: widget.totalClusterStep > 1,
                child:
                    Text("${clusters.cellarType.label} n°${widget.clusterStep}")),
            Visibility(
                visible: widget.totalClusterStep > 1,
                child: const SizedBox(height: 20)),
            TextFormField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nom du ${clusters.cellarType.label}',
              ),
              onChanged: (value) {
                widget.clusterConfiguration.name = value;
              }
            ),
            TextFormField(
              controller: widthController,
              decoration: InputDecoration(
                labelText: widthLabel,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner une valeur';
                }
                return null;
              },
              onChanged: (value) {
                widget.clusterConfiguration.width = int.tryParse(value) ?? 0;
              },
            ),
            TextFormField(
              controller: heightController,
              decoration: InputDecoration(
                labelText: heightLabel,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez renseigner une valeur';
                }
                return null;
              },
              onChanged: (value) {
                widget.clusterConfiguration.height = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
