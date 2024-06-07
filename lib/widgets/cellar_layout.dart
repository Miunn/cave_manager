import 'dart:collection';

import 'package:cave_manager/models/cluster.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../models/cellar_type_enum.dart';
import '../screens/bottle_details.dart';
import 'cellar_pin.dart';

class CellarLayout extends StatefulWidget {
  const CellarLayout({super.key, required this.onTapEmptyCallback});

  final void Function(int clusterId, int row, int column) onTapEmptyCallback;

  @override
  State<CellarLayout> createState() => _CellarLayoutState();
}

class _CellarLayoutState extends State<CellarLayout> {
  List<Tab> getTabs(UnmodifiableListView<CellarCluster> clusters) {
    List<Tab> tabList = [];

    for (int i = 0; i < clusters.length; i++) {
      tabList.add(Tab(
        text: clusters[i].name ?? "$i",
      ));
    }
    return tabList;
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
    Bottle? currentBottle;
    List<Row> rows = [];
    int bottleListIndex = 0;

    if (bottles.isNotEmpty) {
      currentBottle = bottles[bottleListIndex];
    }
    bool displayBottle = false;
    void Function() onTap;

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

          if (bottleListIndex < bottles.length) {
            currentBottle = bottles[bottleListIndex];
          }
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
      return DefaultTabController(
        length: clusters.length,
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: TabBar(
                tabs: getTabs(clusters),
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
