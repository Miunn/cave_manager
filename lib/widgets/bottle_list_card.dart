import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../providers/bottles_provider.dart';
import '../screens/bottle_details.dart';

class BottleListCard extends StatelessWidget {
  const BottleListCard({super.key, required this.bottleId});

  final int bottleId;

  @override
  Widget build(BuildContext context) {
    Bottle bottle = context.read<BottlesProvider>().getBottleById(bottleId);
    debugPrint("Bottle: ${bottle.name} (${bottle.id})");

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
