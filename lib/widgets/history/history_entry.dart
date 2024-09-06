import 'package:cave_manager/models/bottle.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryEntry extends StatelessWidget {
  const HistoryEntry({super.key, required this.bottle, required this.isIncoming, required this.entryDate});

  final Bottle bottle;
  final bool isIncoming;
  final DateTime entryDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isIncoming
          ? const Icon(
              Icons.swap_vert,
              color: Colors.green,
            )
          : const Icon(
              Icons.swap_vert,
              color: Colors.red,
            ),
      title: RichText(
        text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
          TextSpan(
              text: bottle.name ?? AppLocalizations.of(context)!.noName,
              style: TextStyle(fontStyle: bottle.name == null ? FontStyle.italic : FontStyle.normal)),
          bottle.name != null ? TextSpan(text: "- ${bottle.capacity ?? 0}cl") : const TextSpan()
        ]),
      ),
      subtitle: Text(DateFormat.yMMMd().add_jm().format(entryDate)),
      trailing: IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BottleDetails(bottle: bottle, isCellarConfigured: context.read<ClustersProvider>().isCellarConfigured))),
          icon: const Icon(Icons.open_in_new)),
    );
  }
}
