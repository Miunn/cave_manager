import 'package:cave_manager/widgets/cellar_layout.dart';
import 'package:flutter/material.dart';

class CellarCustomization extends StatefulWidget {
  const CellarCustomization({super.key});

  @override
  State<CellarCustomization> createState() => _CellarCustomizationState();
}

class _CellarCustomizationState extends State<CellarCustomization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mettre à jour la cave"),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: const CellarLayout(
        customize: true,
      ),
    );
  }

}