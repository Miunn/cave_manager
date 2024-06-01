import 'package:cave_manager/models/bottle.dart';
import 'package:cave_manager/models/wine_colors_enum.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:cave_manager/widgets/open_bottle_dialog.dart';
import 'package:flutter/material.dart';


class BottleCard extends StatelessWidget {
  const BottleCard(
      {super.key, required this.bottle, required this.openBottleCallback});

  final Bottle bottle;
  final void Function(Bottle) openBottleCallback;

  @override
  Widget build(BuildContext context) {
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
            MaterialPageRoute(builder: (context) => BottleDetails(bottle: bottle)),
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
                  child: const Text("Sortir la bouteille"),
                  onPressed: () async {
                    bool? open = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) =>
                          OpenBottleDialog(bottle: bottle),
                    );
                    if (open != null && open) {
                      openBottleCallback(bottle);
                    }
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
