import 'package:cave_manager/models/bottle.dart';
import 'package:cave_manager/models/enum_wine_colors.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:cave_manager/screens/view_bottle_in_cellar.dart';
import 'package:cave_manager/widgets/open_bottle_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bottles_provider.dart';
import 'cellar_layout.dart';

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
      content: const Text('Bouteille sortie de cave'),
      action: SnackBarAction(
        label: 'Annuler',
        onPressed: () {
          bottle.isOpen = false;
          bottle.tastingNote = null;
          scaffoldKey.currentContext?.read<BottlesProvider>().updateBottle(bottle);
          ScaffoldMessenger.of(scaffoldKey.currentContext ?? context).showSnackBar(const SnackBar(
            content: Text('Bouteille remise en cave'),
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
        colorText = "Vin ${WineColors.red.label}";
        break;

      case WineColors.pink:
        colorText = "Vin ${WineColors.pink.label}";
        break;

      case WineColors.white:
        colorText = "Vin ${WineColors.white.label}";
        break;

      case WineColors.other:
        colorText = WineColors.other.label;
        break;

      default:
        colorText = "Couleur non renseigné";
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottleDetails(bottleId: bottle.id!)),
          );
        },
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.wine_bar),
              title: Text("${bottle.name}"),
              subtitle: Text(
                colorText,
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
                    child: const Text("Voir en cave")),
                TextButton(
                    child: const Text("Sortir la bouteille"),
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
    );
  }
}
