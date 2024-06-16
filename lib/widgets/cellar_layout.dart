import 'dart:collection';

import 'package:cave_manager/models/cluster.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/widgets/blinking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../models/enum_cellar_type.dart';
import '../screens/bottle_details.dart';
import 'cellar_pin.dart';

class CellarLayout extends StatefulWidget {
  const CellarLayout({super.key, this.onTapEmptyCallback, this.blinkingBottleId, this.startingClusterId});

  final void Function(int clusterId, int row, int column)? onTapEmptyCallback;
  final int? blinkingBottleId;
  final int? startingClusterId;

  @override
  State<CellarLayout> createState() => _CellarLayoutState();
}

class _CellarLayoutState extends State<CellarLayout> {
  (int, List<Tab>) getTabs(UnmodifiableListView<CellarCluster> clusters) {
    int initialIndex = 0;
    List<Tab> tabList = [];

    for (int i = 0; i < clusters.length; i++) {
      if (clusters[i].id == widget.startingClusterId) {
        initialIndex = i;
      }

      tabList.add(Tab(
        text: clusters[i].name ?? "$i",
      ));
    }
    return (initialIndex, tabList);
  }

  List<Widget> getTabsContent(
      CellarType cellarType,
      UnmodifiableListView<CellarCluster> clusters,
      UnmodifiableMapView<int, UnmodifiableListView<Bottle>> bottlesByCluster) {
    List<Widget> tabsContent = [];

    for (CellarCluster cluster in clusters) {
      int currentWidth = cluster.width ?? 0;
      int currentHeight = cluster.height ?? 0;

      List<Widget> rows = getClusterLayout(currentWidth, currentHeight, cluster, bottlesByCluster[cluster.id]!);

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

  List<Row> getClusterLayout(int width, int height, CellarCluster cluster, UnmodifiableListView<Bottle> bottles) {
    List<Row> rows = [];
    int bottleListIndex = 0;
    bool displayBottle = false;

    List<Widget> firstRow = [
      const SizedBox(
          width: 35,
          height: 35,
          child: Center(child: Icon(Icons.wine_bar_outlined)))
    ];
    for (int i = 0; i < width; i++) {
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

    for (int i = 0; i < height; i++) {
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
      for (int j = 0; j < width; j++) {
        Bottle? currentBottle = (bottles.isNotEmpty && bottleListIndex < bottles.length) ? bottles[bottleListIndex] : null;
        void Function() onTap;
        if (currentBottle != null &&
            currentBottle.clusterY == i &&
            currentBottle.clusterX == j) {
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
        } else if (widget.onTapEmptyCallback != null) {
          onTap = () => widget.onTapEmptyCallback!(cluster.id!, i, j);
        } else {
          onTap = () {};
        }

        if (displayBottle && currentBottle != null && widget.blinkingBottleId == currentBottle.id) {
          rowChildren.add(
            SizedBox(
              width: 35,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: BlinkingWidget(
                  duration: const Duration(milliseconds: 700),
                  child: CellarPin(
                    bottle: currentBottle,
                    onTap: onTap,
                  ),
                ),
              ),
            ),
          );
        } else {
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
        }

        if (displayBottle) {
          bottleListIndex++;
          displayBottle = false;
        }
      }
      rows.add(Row(
        children: rowChildren,
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    CellarType cellarType = context.read<ClustersProvider>().cellarType;
    UnmodifiableListView<CellarCluster> clusters =
        context.read<ClustersProvider>().clusters;
    UnmodifiableMapView<int, UnmodifiableListView<Bottle>> bottlesByCluster =
        context.watch<BottlesProvider>().sortedBottlesByCluster;

    if (clusters.length > 1) {
      (int, List<Tab>) tabs = getTabs(clusters);

      return DefaultTabController(
        length: clusters.length,
        initialIndex: tabs.$1,
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: TabBar(
                tabs: tabs.$2,
              ),
            ),
            Expanded(
                child: TabBarView(
                    children:
                    getTabsContent(cellarType, clusters, bottlesByCluster))),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clusters[0].name ?? cellarType.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ...getClusterLayout(
                  clusters[0].width ?? 0, clusters[0].height ?? 0, clusters[0], bottlesByCluster[clusters[0].id!]!),
            ]
          ),
        ),
      ),
    );
  }
}
