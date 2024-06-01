import 'package:cave_manager/models/cellar_type_enum.dart';
import 'package:cave_manager/models/cluster.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_cluster_selector.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_size_selector.dart';
import 'package:cave_manager/widgets/cellarConfiguration/cellar_summary.dart';
import 'package:flutter/material.dart';

import 'cellarConfiguration/cellar_type_selector.dart';

class CellarConfiguration extends StatefulWidget {
  const CellarConfiguration({super.key, required this.submitCallback});

  static const MAX_STEP = 3;
  final void Function(CellarType, int, List<CellarCluster>) submitCallback;

  @override
  State<CellarConfiguration> createState() => _CellarConfigurationState();
}

class _CellarConfigurationState extends State<CellarConfiguration> {
  final _formKey = GlobalKey<FormState>();
  String sectionTitle = "Sélectionnez la topologie de votre cave";
  CellarType cellarType = CellarType.holder;
  int currentStep = 0;
  int clusterStep = 1;
  double cellarClusterController = 1;
  List<CellarCluster> cellarConfiguration = [];

  previousStep() {
    setState(() {
      if (currentStep == 2 && clusterStep > 1) {
        clusterStep--;
      } else {
        currentStep--;
        debugPrint("Reset cluster");
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

  nextStep() {
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
    switch (currentStep) {
      case 0:
        sectionTitle = "Sélectionnez la topologie de votre cave";
        break;
      case 1:
      case 2:
        sectionTitle = "Définissez les dimensions de votre cave";
        break;
      case 3:
        sectionTitle = "Résumé de votre configuration";
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
              CellarTypeSelector(
                selected: cellarType,
                onSelectChange: (CellarType type) {
                  setState(() {
                    cellarType = type;
                  });
                },
              ),
              CellarClusterSelector(
                  cellarType: cellarType,
                  clusterSliderCallback: (double value) {
                    setState(() {
                      cellarClusterController = value;
                    });
                  },
                  clusterValue: cellarClusterController),
              CellarSizeSelector(
                cellarType: cellarType,
                clusterStep: clusterStep,
                totalClusterStep: cellarClusterController.round(),
                clusterConfiguration: getCurrentCellarCluster(),
              ),
              CellarSummary(
                  cellarType: cellarType,
                  clusters: cellarClusterController.round(),
                  cellarConfiguration: cellarConfiguration),
            ][currentStep],
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FilledButton.tonal(
                    onPressed: (currentStep > 0) ? previousStep : null,
                    child: const Text("Retour")),
                FilledButton(
                    onPressed: (currentStep < CellarConfiguration.MAX_STEP)
                        ? nextStep
                        : () {
                            widget.submitCallback(cellarType, cellarClusterController.round(), cellarConfiguration);
                          },
                    child: Text((currentStep < CellarConfiguration.MAX_STEP)
                        ? "Suivant"
                        : "Terminer")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
