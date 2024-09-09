import 'package:cave_manager/models/history.dart';
import 'package:cave_manager/providers/history_provider.dart';
import 'package:cave_manager/widgets/history/history_entry.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/bottle.dart';
import 'settings.dart';

class GlobalHistory extends StatelessWidget {
  const GlobalHistory({super.key});

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
        title: Text(AppLocalizations.of(context)!.history),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(
                        title: AppLocalizations.of(context)!.settings)),
              ),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (BuildContext context, HistoryProvider history, Widget? child) {
          List<History> entries = history.history;
          return ListView.builder(
            itemCount: entries.length,
            prototypeItem: HistoryEntry(
              bottle: Bottle.empty(),
              isIncoming: true,
              entryDate: DateTime(2024),
            ),
            itemBuilder: (context, index) {
              return HistoryEntry(
                bottle: entries[index].bottleId ?? Bottle.empty(),
                isIncoming: entries[index].isIncoming ?? false,
                entryDate: entries[index].createdAt ?? DateTime.now(),
              );
            }
          );
        },
      ),
    );
  }
}