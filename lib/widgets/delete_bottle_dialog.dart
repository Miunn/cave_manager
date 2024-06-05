import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../providers/bottles_provider.dart';

class DeleteBottleDialog extends StatelessWidget {
  const DeleteBottleDialog({super.key, required this.bottle});

  final Bottle bottle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Supprimer la bouteille"),
      content: Text("${bottle.name} sera supprimer définitivement"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
