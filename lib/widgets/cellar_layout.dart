import 'package:cave_manager/models/cluster.dart';
import 'package:flutter/material.dart';

import '../models/bottle.dart';
import '../models/cellar_type_enum.dart';
import '../screens/bottle_details.dart';
import 'cellar_pin.dart';

class CellarLayout extends StatefulWidget {
  const CellarLayout(
      {super.key,
      required this.cellarType,
      required this.cellarConfiguration,
      required this.bottles,
      required this.onTapEmptyCallback});

  final CellarType cellarType;
  final List<CellarCluster> cellarConfiguration;
  final Map<int, List<Bottle>> bottles;
  final void Function(int, int, int) onTapEmptyCallback;

  @override
  State<CellarLayout> createState() => _CellarLayoutState();
}

class _CellarLayoutState extends State<CellarLayout> {
  @override
  void initState() {
    super.initState();
  }

  List<Tab> getTabs() {
    List<Tab> tabList = [];

    for (int i = 0; i < widget.cellarConfiguration.length; i++) {
      tabList.add(Tab(
        text: widget.cellarConfiguration[i].name ?? "$i",
      ));
    }
    return tabList;
  }

  List<Widget> getTabsContent() {
    List<Widget> tabsContent = [];

    for (CellarCluster cluster in widget.cellarConfiguration) {
      int currentWidth = cluster.width ?? 0;
      int currentHeight = cluster.height ?? 0;
      int bottleListIndex = 0;
      Bottle? currentBottle;

      if (widget.bottles[cluster.id] != null && widget.bottles[cluster.id]!.isNotEmpty) {
        currentBottle = widget.bottles[cluster.id]![bottleListIndex];
        debugPrint("Current bottle: $currentBottle");
      }
      bool displayBottle = false;
      void Function() onTap;

      List<Widget> rows = [];

      List<Widget> firstRow = [const SizedBox(width: 35, height: 35, child: Center(child: Icon(Icons.wine_bar_outlined)))];
      for (int i = 0; i < currentWidth; i++) {
        firstRow.add(SizedBox(
          width: 35,
          height: 35,
          child: Center(
            child: Text(
              "${i + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ));
      }
      rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: firstRow,
      ));

      for (int i = 0; i < currentHeight; i++) {
        List<Widget> rowChildren = [
          SizedBox(
            width: 35,
            height: 35,
            child: Center(
              child: Text(
                "${i + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ];
        for (int j = 0; j < currentWidth; j++) {
          if (currentBottle != null && currentBottle.clusterY == i && currentBottle.clusterX == j) {
            debugPrint("Display bottle, i: $i, j: $j, bottle: $currentBottle");
            onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottleDetails(
                    bottleId: currentBottle!.id!,
                  ),
                ),
              );
            };
            displayBottle = true;
          } else {
            onTap = () => widget.onTapEmptyCallback(cluster.id!, i, j);
          }

          rowChildren.add(
            SizedBox(
              width: 35,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CellarPin(
                  bottle: (displayBottle) ? currentBottle : null,
                  onTap: onTap,
                ),
              ),
            ),
          );

          if (displayBottle) {
            bottleListIndex++;
            displayBottle = false;

            if (bottleListIndex < widget.bottles[cluster.id]!.length) {
              currentBottle = widget.bottles[cluster.id]![bottleListIndex];
            }
          }
        }
        rows.add(Row(
          children: rowChildren,
        ));
      }

      tabsContent.add(
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: rows,
              ),
            ),
          ),
        ),
      );
    }

    return tabsContent;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.cellarConfiguration.length,
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: TabBar(
              tabs: getTabs(),
            ),
          ),
          Expanded(child: TabBarView(children: getTabsContent())),
        ],
      ),
    );
  }
}
