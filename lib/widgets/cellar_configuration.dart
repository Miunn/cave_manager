import 'package:cave_manager/models/enum_cellar_type.dart';
import 'package:cave_manager/models/cluster.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_cluster_selector.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_size_selector.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cellarConfiguration/cellar_type_selector.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CellarConfiguration extends StatefulWidget {
  const CellarConfiguration({super.key});

  static const MAX_STEP = 3;

  @override
  State<CellarConfiguration> createState() => _CellarConfigurationState();
}

class _CellarConfigurationState extends State<CellarConfiguration> {
  final _formKey = GlobalKey<FormState>();
  String sectionTitle = "Sélectionnez la topologie de votre cave";
  int currentStep = 0;
  int clusterStep = 1;
  double cellarClusterController = 1;
  List<CellarCluster> cellarConfiguration = [];

  previousStep(CellarType cellarType) {
    setState(() {
      if (currentStep == 2 && clusterStep > 1) {
        clusterStep--;
      } else {
        currentStep--;
      }

      if (currentStep <= 1) {
        cellarClusterController = 1; // Reset cluster value
        cellarConfiguration = []; // Reset configuration
      }

      // No cluster definition for bags
      if (currentStep == 1 && cellarType == CellarType.bags) {
        currentStep--;
      }
    });
  }

  nextStep(CellarType cellarType) {
    setState(() {
      if (currentStep == 2 && clusterStep < cellarClusterController.round()) {
        clusterStep++;
      } else {
        currentStep++;
      }

      // No cluster definition for bags
      if (currentStep == 1 && cellarType == CellarType.bags) {
        currentStep++;
      }
    });
  }

  getCurrentCellarCluster() {
    if (cellarConfiguration.length > clusterStep - 1) {
      return cellarConfiguration[clusterStep - 1];
    }

    CellarCluster newCluster = CellarCluster(id: clusterStep);
    cellarConfiguration.add(newCluster);
    return newCluster;
  }

  @override
  Widget build(BuildContext context) {
    ClustersProvider clusters = context.read<ClustersProvider>();

    switch (currentStep) {
      case 0:
        sectionTitle = AppLocalizations.of(context)!.cellarConfigurationTitle1;
        break;
      case 1:
      case 2:
        sectionTitle = AppLocalizations.of(context)!.cellarConfigurationTitle2;
        break;
      case 3:
        sectionTitle = AppLocalizations.of(context)!.cellarSummary;
        break;
    }

    return Form(
      key: _formKey,
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            [
              const CellarTypeSelector(),
              CellarClusterSelector(
                  clusterSliderCallback: (double value) {
                    setState(() {
                      cellarClusterController = value;
                    });
                  },
                  clusterValue: cellarClusterController),
              CellarSizeSelector(
                clusterStep: clusterStep,
                totalClusterStep: cellarClusterController.round(),
                clusterConfiguration: getCurrentCellarCluster(),
              ),
              CellarSummary(
                cellarType: clusters.cellarType,
                clustersConfiguration: cellarConfiguration,
              ),
            ][currentStep],
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FilledButton.tonal(
                    onPressed: (currentStep > 0)
                        ? () => previousStep(clusters.cellarType)
                        : null,
                    child: Text(AppLocalizations.of(context)!.back)),
                FilledButton(
                    onPressed: (currentStep < CellarConfiguration.MAX_STEP)
                        ? () => nextStep(clusters.cellarType)
                        : () => clusters
                            .setCellarConfiguration(cellarConfiguration),
                    child: Text((currentStep < CellarConfiguration.MAX_STEP)
                        ? AppLocalizations.of(context)!.next
                        : AppLocalizations.of(context)!.finish)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
