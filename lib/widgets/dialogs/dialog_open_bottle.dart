import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../models/bottle.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return FadeScaleTransition(
      animation: ModalRoute.of(context)!.animation!,
      child: AlertDialog(
        title: Text(AppLocalizations.of(context)!.takeOutBottleConfirmationTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.takeOutBottleConfirmationMessage(widget.bottle.name ?? '')),
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.takeOutBottleTastingNoteHint,
                  hintStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15)
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
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              widget.bottle.tastingNote = tastingNoteController.text;
              Navigator.pop(context, true);
            },
            child: Text(AppLocalizations.of(context)!.takeOut),
          ),
        ],
      ),
    );
  }
}