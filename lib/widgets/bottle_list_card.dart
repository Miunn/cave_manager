import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../providers/bottles_provider.dart';
import '../screens/bottle_details.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottleListCard extends StatefulWidget {
  const BottleListCard({super.key, required this.bottleId});

  final int bottleId;

  @override
  State<BottleListCard> createState() => _BottleListCardState();
}

class _BottleListCardState extends State<BottleListCard> {
  final ExpansionTileController controller = ExpansionTileController();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Bottle bottle =
        context.read<BottlesProvider>().getBottleById(widget.bottleId);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: OpenContainer(
        closedBuilder: (BuildContext context, void Function() action) => InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: action,
          onLongPress: () {
            setState(() {
              if (controller.isExpanded) {
                controller.collapse();
              } else {
                controller.expand();
              }
            });
          },
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: IgnorePointer(
              ignoring: true,
              child: ExpansionTile(
                controller: controller,
                leading: const Icon(Icons.wine_bar, color: Colors.black),
                trailing: const SizedBox.shrink(),
                title: Text('${bottle.name}'),
                subtitle: Text(
                  (bottle.signature == null || bottle.signature!.isEmpty)
                      ? AppLocalizations.of(context)!.noEstate
                      : '${bottle.signature}',
                  style: TextStyle(
                    fontStyle:
                        (bottle.signature == null || bottle.signature!.isEmpty)
                            ? FontStyle.italic
                            : FontStyle.normal,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 20.0),
                expandedAlignment: Alignment.topLeft,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                onExpansionChanged: (bool isExpanded) {
                  setState(() {
                    this.isExpanded = isExpanded;
                  });
                },
                children: <Widget>[
                  SizedBox(
                    height: 74,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 16),
                            Text(
                              (bottle.vintageYear == null)
                                  ? AppLocalizations.of(context)!.noVintage
                                  : '${bottle.vintageYear}',
                              style: TextStyle(
                                fontStyle: (bottle.vintageYear == null)
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.map),
                            const SizedBox(width: 16),
                            Text(
                              (bottle.area == null || bottle.area!.isEmpty)
                                  ? AppLocalizations.of(context)!.noRegion
                                  : '${bottle.area}',
                              style: TextStyle(
                                fontStyle:
                                    (bottle.area == null || bottle.area!.isEmpty)
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.fruitGrapes),
                            const SizedBox(width: 16),
                            Text(
                              (bottle.grapeVariety == null ||
                                      bottle.grapeVariety!.isEmpty)
                                  ? AppLocalizations.of(context)!.noGrape
                                  : '${bottle.grapeVariety}',
                              style: TextStyle(
                                fontStyle: (bottle.grapeVariety == null ||
                                        bottle.grapeVariety!.isEmpty)
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.map),
                            const SizedBox(width: 16),
                            Text(
                              (bottle.subArea == null || bottle.subArea!.isEmpty)
                                  ? AppLocalizations.of(context)!.noSubRegion
                                  : '${bottle.subArea}',
                              style: TextStyle(
                                fontStyle: (bottle.subArea == null ||
                                        bottle.subArea!.isEmpty)
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        openBuilder: (BuildContext context, void Function({Object? returnValue}) action) => BottleDetails(bottle: bottle),
        tappable: false,
      ),
    );
  }
}
