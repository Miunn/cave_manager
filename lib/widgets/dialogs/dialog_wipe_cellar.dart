import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WipeCellarDialog extends StatelessWidget {
  const WipeCellarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeScaleTransition(
      animation: ModalRoute.of(context)!.animation!,
      child: AlertDialog(
        icon: const Icon(Icons.delete_forever),
        title: Text(AppLocalizations.of(context)!.wipeCellarConfirmationTitle),
        content: Text(AppLocalizations.of(context)!.wipeCellarConfirmationMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.wipe),
          ),
        ],
      ),
    );
  }
}