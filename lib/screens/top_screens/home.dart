import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/widgets/bottle_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bottle.dart';
import '../../providers/bottles_provider.dart';
import '../../widgets/cellar_fillng.dart';
import '../add_bottle_dialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(AppLocalizations.of(context)!.home),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Settings(title: AppLocalizations.of(context)!.settings)),
                  ),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<BottlesProvider>(
              builder: (context, bottles, child) {
                return CellarFilling(bottleAmount: bottles.closedBottles.length);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<BottlesProvider>(builder: (context, bottles, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(label: Text("${bottles.redCount} ${AppLocalizations.of(context)!.redWine}")),
                  Chip(label: Text("${bottles.whiteCount} ${AppLocalizations.of(context)!.whiteWine}")),
                  Chip(label: Text("${bottles.pinkCount} ${AppLocalizations.of(context)!.pinkWine}")),
                ],
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Text(AppLocalizations.of(context)!.lastRegisteredBottles, style: const TextStyle(fontSize: 20)),
            Consumer<BottlesProvider>(
              builder: (context, bottles, child) {
                return bottles.lastBottles.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.noLastRegisteredBottles),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: bottles.lastBottles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BottleCard(
                                bottleId: bottles.lastBottles[index].id!);
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<Bottle>(
              fullscreenDialog: true,
              builder: (BuildContext context) => const AddBottleDialog()));
        },
        tooltip: AppLocalizations.of(context)!.insertBottle,
        child: const Icon(Icons.add),
      ),
    );
  }
}
