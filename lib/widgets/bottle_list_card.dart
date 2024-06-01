import 'package:flutter/material.dart';

import '../models/bottle.dart';
import '../screens/bottle_details.dart';

class BottleListCard extends StatelessWidget {
  const BottleListCard({super.key, required this.bottle});

  final Bottle bottle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BottleDetails(bottle: bottle)),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.wine_bar),
          title: Text('${bottle.name}'),
          subtitle: Text(
            (bottle.signature == null || bottle.signature!.isEmpty)
                ? "Aucun domaine"
                : '${bottle.signature}',
            style: TextStyle(
              fontStyle: (bottle.signature == null || bottle.signature!.isEmpty)
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }
}
