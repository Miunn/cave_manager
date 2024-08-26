import 'dart:collection';
import 'dart:math';

import 'package:cave_manager/models/cluster.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/widgets/blinking.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../models/enum_cellar_type.dart';
import '../screens/bottle_details.dart';
import 'cellar_pin.dart';

class CellarLayout extends StatefulWidget {
  const CellarLayout(
      {super.key,
      this.onTapEmptyCallback,
      this.blinkingBottleId,
      this.startingClusterId,
      this.customize = false});

  final void Function(int clusterId, int row, int column)? onTapEmptyCallback;
  final int? blinkingBottleId;
  final int? startingClusterId;
  final bool customize;

  @override
  State<CellarLayout> createState() => _CellarLayoutState();
}

class _CellarLayoutState extends State<CellarLayout>
    with SingleTickerProviderStateMixin {
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
      UnmodifiableMapView<int, Map<int, List<Bottle>>> bottlesByClusterByRow,
      Map<int, List<int>> clustersRowConfiguration) {
    List<Widget> tabsContent = [];

    for (CellarCluster cluster in clusters) {
      int currentWidth = cluster.width ?? 0;
      int currentHeight = cluster.height ?? 0;

      List<Widget> rows = getClusterLayout(currentWidth, currentHeight, cluster,
          bottlesByClusterByRow[cluster.id] ?? {}, clustersRowConfiguration);

      tabsContent.add(
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rows,
              ),
            ),
          ),
        ),
      );
    }

    return tabsContent;
  }

  List<Widget> getSubRows(
      int clusterId, int rowId, int width, int maxWidth, int height, List<Bottle> bottles) {
    List<Widget> cells = [];

    //debugPrint(bottles.toString());
    Iterable<int?> subY = bottles.map((bottle) => bottle.clusterSubY);

    // Build an empty row if there are no sub rows
    if (subY.isEmpty) {
      for (int i = 0; i < width; i++) {
        cells.add(
          SizedBox(
            width: 35,
            height: 35,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: CellarPin(
                bottle: null,
                onTap: () {},
              ),
            ),
          ),
        );
      }
      return cells;
    }

    int maxSubY =
        subY.reduce((value, element) => max(value ?? 0, element ?? 0)) ?? 0;

    for (int i = maxSubY; i >= 0; i--) {
      for (int j = 0; j < width; j++) {
        Bottle? currentBottle = bottles.firstWhereOrNull((bottle) => bottle.clusterSubY == i && bottle.clusterX == j);

        void Function() onTap;
        if (currentBottle != null) {
          onTap = () {
            if (widget.customize) {
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottleDetails(
                  bottleId: currentBottle.id!,
                ),
              ),
            );
          };
        } else if (widget.onTapEmptyCallback != null) {
          onTap = () => widget.onTapEmptyCallback!(clusterId, i, j);
        } else {
          onTap = () {};
        }

        if (currentBottle != null && widget.blinkingBottleId == currentBottle.id) {
          cells.add(
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
        } else  {
          cells.add(
            SizedBox(
              width: 35,
              height: 35,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: CellarPin(
                  bottle: currentBottle,
                  onTap: onTap,
                ),
              ),
            ),
          );
        }
      }

      // Add some empty cells to fill the row
      for (int j = width; j < maxWidth; j++) {
        cells.add(
          const SizedBox(
            width: 35,
            height: 35,
          ),
        );
      }
    }
    return cells;
  }

  List<Widget> getClusterLayout(
      int width,
      int height,
      CellarCluster cluster,
      Map<int, List<Bottle>> clusterBottlesByRow,
      Map<int, List<int>> clustersRowConfiguration) {
    if (cluster.id == null) {
      return [];
    }

    List<Widget> rows = [];

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

      rowChildren.addAll(getSubRows(cluster.id!, i, width, clustersRowConfiguration[cluster.id!]![i], height, clusterBottlesByRow[i] ?? []));

      if (widget.customize) {
        rows.add(Stack(
            alignment: AlignmentGeometry.lerp(
                Alignment.topLeft, Alignment.bottomRight, 0.5)!,
            children: [
              Opacity(
                opacity: 0.2,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: rowChildren,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      if (clustersRowConfiguration[cluster.id!]![i] <= 1) {
                        return;
                      }
                      context
                          .read<ClustersProvider>()
                          .updateClustersRowConfiguration(cluster.id!, i,
                              clustersRowConfiguration[cluster.id!]![i] - 1);
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${clustersRowConfiguration[cluster.id!]![i]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.tonal(
                    onPressed: () {
                      if (clustersRowConfiguration[cluster.id!]![i] >=
                          cluster.width!) {
                        return;
                      }
                      context
                          .read<ClustersProvider>()
                          .updateClustersRowConfiguration(cluster.id!, i,
                              clustersRowConfiguration[cluster.id!]![i] + 1);
                    },
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ]));
      } else {
        rows.add(Row(
          children: rowChildren,
        ));
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    CellarType cellarType = context.read<ClustersProvider>().cellarType;
    UnmodifiableListView<CellarCluster> clusters =
        context.read<ClustersProvider>().clusters;
    UnmodifiableMapView<int, Map<int, List<Bottle>>> bottlesByClusterByRow =
        context.watch<BottlesProvider>().sortedBottlesByClusterByRow;
    Map<int, List<int>> clustersRowConfiguration =
        context.watch<ClustersProvider>().clustersRowConfiguration;

    if (clusters.length > 1) {
      (int, List<Tab>) tabs = getTabs(clusters);

      return DefaultTabController(
        length: clusters.length,
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
                    children: getTabsContent(cellarType, clusters,
                        bottlesByClusterByRow, clustersRowConfiguration))),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              clusters[0].name ?? cellarType.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...getClusterLayout(
                clusters[0].width ?? 0,
                clusters[0].height ?? 0,
                clusters[0],
                bottlesByClusterByRow[clusters[0].id!]!,
                clustersRowConfiguration),
          ]),
        ),
      ),
    );
  }
}
