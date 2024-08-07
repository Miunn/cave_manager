import 'package:animations/animations.dart';
import 'package:cave_manager/models/bottle.dart';
import 'package:cave_manager/models/enum_wine_colors.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:cave_manager/screens/cellar/view_bottle_in_cellar.dart';
import 'package:cave_manager/widgets/dialogs/dialog_open_bottle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bottles_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottleCard extends StatelessWidget {
  const BottleCard({super.key, required this.bottleId});

  final int bottleId;

  openBottle(BuildContext context) {
    Bottle bottle = context.read<BottlesProvider>().getBottleById(bottleId);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    bottle.isOpen = true;
    bottle.openedAt = DateTime.now();
    context.read<BottlesProvider>().updateBottle(bottle);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: scaffoldKey,
      content: Text(AppLocalizations.of(context)!.takenOutBottle),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.undo,
        onPressed: () {
          bottle.isOpen = false;
          bottle.tastingNote = null;
          scaffoldKey.currentContext?.read<BottlesProvider>().updateBottle(bottle);
          ScaffoldMessenger.of(scaffoldKey.currentContext ?? context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.takenOutCanceled),
          ));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Bottle bottle = context.read<BottlesProvider>().getBottleById(bottleId);
    String? colorText;

    switch (WineColors.values.firstWhere((e) => e.value == bottle.color)) {
      case WineColors.red:
        colorText = AppLocalizations.of(context)!.redWine;
        break;

      case WineColors.pink:
        colorText = AppLocalizations.of(context)!.pinkWine;
        break;

      case WineColors.white:
        colorText = AppLocalizations.of(context)!.whiteWine;
        break;

      case WineColors.other:
        colorText = WineColors.other.label;
        break;

      default:
        colorText = AppLocalizations.of(context)!.unknownColor;
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: OpenContainer(
        closedBuilder: (BuildContext context, void Function() action) => InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: action,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.wine_bar),
                title: Text("${bottle.name}"),
                subtitle: Text(
                  colorText!,
                  style: TextStyle(
                    fontStyle: bottle.color == null
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewBottleInCellar(bottle: bottle),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.seeInCellar)),
                  TextButton(
                      child: Text(AppLocalizations.of(context)!.takeOutBottle),
                      onPressed: () async {
                        bool? open = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) =>
                              OpenBottleDialog(bottle: bottle),
                        );
                        if (open != null && open && context.mounted) {
                          openBottle(context);
                        }
                      }),
                ],
              )
            ],
          ),
        ),
        openBuilder: (BuildContext context, void Function({Object? returnValue}) action) => BottleDetails(bottleId: bottle.id!),
        tappable: false,
      ),
    );
  }
}
