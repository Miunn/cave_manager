import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/bottle.dart';


class DeleteBottleCoverDialog extends StatelessWidget {
  const DeleteBottleCoverDialog({super.key, required this.bottle});

  final Bottle bottle;

  @override
  Widget build(BuildContext context) {
    return FadeScaleTransition(
      animation: ModalRoute.of(context)!.animation!,
      child: AlertDialog(
        icon: const Icon(Icons.delete_outline),
        title: Text(AppLocalizations.of(context)!.deleteBottleCoverTitle),
        content: Text(AppLocalizations.of(context)!.deleteBottleCoverMessage(bottle.name ?? '')),
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
      ),
    );
  }
}