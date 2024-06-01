import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/bottle.dart';

class OpenBottleDialog extends StatefulWidget {
  const OpenBottleDialog({super.key, required this.bottle});

  final Bottle bottle;

  @override
  State<OpenBottleDialog> createState() => _OpenBottleDialogState();
}

class _OpenBottleDialogState extends State<OpenBottleDialog> {

  bool writeDescription = true;

  @override
  Widget build(BuildContext context) {
    final TextEditingController tastingNoteController = TextEditingController();

    return AlertDialog(
      title: const Text('Sortir la bouteille ?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${widget.bottle.name} sera retiré de la cave. Elle sera toujours consultable via l'onglet 'Mes bouteilles'"
          ),
          const SizedBox(height: 20,),
          /*TextButton.icon(
            onPressed: () {
              setState(() {
                writeDescription = !writeDescription;
              });
            },
            icon: const Icon(Icons.note_add),
            label: const Text('Ajouter une note de dégustation'),
          ),
          Visibility(visible: writeDescription, child: const SizedBox(height: 20,)),*/
          Visibility(
            visible: writeDescription,
            child: TextField(
              controller: tastingNoteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Pour quelle occasion sortir cette bouteille ? (facultatif)',
                hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)
              ),
              style: const TextStyle(fontSize: 15),
              maxLines: 4,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            widget.bottle.tastingNote = tastingNoteController.text;
            Navigator.pop(context, true);
          },
          child: const Text('Sortir'),
        ),
      ],
    );
  }
}