import 'package:flutter/material.dart';

import '../models/bottle.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteBottleDialog extends StatelessWidget {
  const DeleteBottleDialog({super.key, required this.bottle});

  final Bottle bottle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_forever),
      title: Text(AppLocalizations.of(context)!.deleteBottleConfirmationTitle),
      content: Text(AppLocalizations.of(context)!.deleteBottleConfirmationMessage(bottle.name ?? '')),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    );
  }
}
