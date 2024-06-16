import 'package:flutter/material.dart';

import '../models/bottle.dart';

class DeleteBottleDialog extends StatelessWidget {
  const DeleteBottleDialog({super.key, required this.bottle});

  final Bottle bottle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_outline),
      title: const Text("Supprimer la bouteille ?"),
      content: Text("${bottle.name}sera définitivement supprimée"),
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
