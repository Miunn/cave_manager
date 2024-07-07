import 'package:cave_manager/models/enum_cellar_type.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cluster.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    String widthLabel = AppLocalizations.of(context)!.clusterRackWidth;
    String heightLabel = AppLocalizations.of(context)!.clusterRackHeight;

    switch (clusters.cellarType) {
      case CellarType.holder:
        widthLabel = AppLocalizations.of(context)!.clusterRackWidth;
        break;

      case CellarType.bags:
        widthLabel = AppLocalizations.of(context)!.clusterContainersWidth;
        break;

      case CellarType.fridge:
        widthLabel = AppLocalizations.of(context)!.clusterFridgeWidth;
        break;

      default:
        widthLabel = "";
        break;
    }

    switch (clusters.cellarType) {
      case CellarType.holder:
        heightLabel = AppLocalizations.of(context)!.clusterRackHeight;
        break;

      case CellarType.bags:
        heightLabel = AppLocalizations.of(context)!.clusterContainersHeight;
        break;

      case CellarType.fridge:
        heightLabel = AppLocalizations.of(context)!.clusterFridgeHeight;
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
            Text(AppLocalizations.of(context)!.cellarConfigurationTitle2,
                style: const TextStyle(fontSize: 15)),
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
                labelText: AppLocalizations.of(context)!.clusterTypeName(clusters.cellarType.label),
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
                  return AppLocalizations.of(context)!.enterValueWarning;
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
                  return AppLocalizations.of(context)!.enterValueWarning;
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
