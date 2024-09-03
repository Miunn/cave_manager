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
      this.cellarType = CellarType.none,
      required this.clusters,
      required this.bottlesByClusterByRow,
      required this.clustersRowConfiguration,
      this.onTapEmptyCallback,
      this.blinkingBottleId,
      this.startingClusterId,
      this.customize = false,
      this.shouldDisplayNewSubRow = false});

  final CellarType cellarType;
  final UnmodifiableListView<CellarCluster> clusters;
  final UnmodifiableMapView<int, Map<int, List<Bottle>>> bottlesByClusterByRow;
  final Map<int, List<int>> clustersRowConfiguration;
  final void Function(int clusterId, int row, int subRow, int column)? onTapEmptyCallback;
  final int? blinkingBottleId;
  final int? startingClusterId;
  final bool customize;
  final bool shouldDisplayNewSubRow;

  @override
  State<CellarLayout> createState() => _CellarLayoutState();
}

class _CellarLayoutState extends State<CellarLayout> with SingleTickerProviderStateMixin {
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

  List<Widget> getTabsContent(CellarType cellarType, UnmodifiableListView<CellarCluster> clusters,
      UnmodifiableMapView<int, Map<int, List<Bottle>>> bottlesByClusterByRow, Map<int, List<int>> clustersRowConfiguration) {
    List<Widget> tabsContent = [];

    for (CellarCluster cluster in clusters) {
      int currentWidth = cluster.width ?? 0;
      int currentHeight = cluster.height ?? 0;

      List<Widget> rows = getClusterLayout(currentWidth, currentHeight, cluster, bottlesByClusterByRow[cluster.id] ?? {}, clustersRowConfiguration);

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

  void Function() getBottleCallback(Bottle? bottle, int clusterId, int rowId, int subRowId, int column) {
    if (bottle != null) {
      return () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottleDetails(
              bottle: bottle,
              isCellarConfigured: context.read<ClustersProvider>().isCellarConfigured,
            ),
          ),
        );
      };
    }

    if (widget.onTapEmptyCallback != null) {
      return () => widget.onTapEmptyCallback!(clusterId, rowId, subRowId, column);
    }

    return () {};
  }

  SizedBox getCell(Bottle? bottle, bool forcedOpacity, int clusterId, int rowId, int subRowId, int column,
      {bool blinking = false, bool addIcon = false}) {
    return SizedBox(
      width: 35,
      height: 35,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Opacity(
          opacity: (bottle != null || forcedOpacity) ? 1 : 0.4,
          child: blinking
              ? BlinkingWidget(
                  duration: const Duration(milliseconds: 700),
                  child: CellarPin(
                    bottle: bottle,
                    onTap: widget.customize ? null : getBottleCallback(bottle, clusterId, rowId, subRowId, column),
                    addIcon: addIcon,
                  ),
                )
              : CellarPin(
                  bottle: bottle,
                  onTap: widget.customize ? null : getBottleCallback(bottle, clusterId, rowId, subRowId, column),
                  addIcon: addIcon,
                ),
        ),
      ),
    );
  }

  Widget getSubRowLayout(int clusterId, int rowId, int highestSubRowIndex, int width, List<Bottle> bottles) {
    List<Row> subRows = [];

    List<Bottle> currentSubRowBottles = bottles.where((element) => element.clusterSubY == highestSubRowIndex).toList();
    List<Bottle> nextSubRowBottles = bottles.where((element) => element.clusterSubY == highestSubRowIndex - 1).toList();

    for (int i = highestSubRowIndex; i > 0; i--) {
      List<Widget> rowCells = [];
      bool shouldAddRow = false; // To decide if we display the subRow (should have at least one interactive pin)
      for (int j = 0; j < width - (i % 2); j++) {
        Bottle? currentBottle = currentSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j);

        if (i % 2 == 0 && j > 0 && j < width - (i % 2) - 1) {
          // Check if previous and next are filled
          Bottle? previousBottle = nextSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j - 1);
          Bottle? nextBottle = nextSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j);

          if (previousBottle != null && nextBottle != null) {
            rowCells.add(getCell(currentBottle, false, clusterId, rowId, i, j, addIcon: currentBottle == null));
            shouldAddRow = true;
          } else {
            rowCells.add(const SizedBox(width: 35, height: 35));
          }
        } else if (i % 2 == 0 && j == 0) {
          Bottle? nextBottle = nextSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j);

          if (nextBottle != null) {
            rowCells.add(getCell(currentBottle, false, clusterId, rowId, i, j, addIcon: currentBottle == null));
            shouldAddRow = true;
          } else {
            rowCells.add(const SizedBox(width: 35, height: 35));
          }
        } else if (i % 2 == 0 && j == width - (i % 2) - 1) {
          Bottle? previousBottle = nextSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j - 1);

          if (previousBottle != null) {
            rowCells.add(getCell(currentBottle, false, clusterId, rowId, i, j, addIcon: currentBottle == null));
            shouldAddRow = true;
          } else {
            rowCells.add(const SizedBox(width: 35, height: 35));
          }
        } else if (i % 2 == 1) {
          Bottle? previousBottle = nextSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j);
          Bottle? nextBottle = nextSubRowBottles.firstWhereOrNull((bottle) => bottle.clusterX == j + 1);

          if (previousBottle != null && nextBottle != null) {
            rowCells.add(getCell(currentBottle, false, clusterId, rowId, i, j, addIcon: currentBottle == null));
            shouldAddRow = true;
          } else {
            rowCells.add(const SizedBox(width: 35, height: 35));
          }
        }
      }

      if (shouldAddRow) {
        subRows.add(Row(
          children: rowCells,
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: subRows,
    );
  }

  Column getRowLayout(int clusterId, int rowId, int width, int maxWidth, int height, List<Bottle> bottles) {
    List<Widget> rowColumnChildren = [];

    List<int?> subY = bottles.map((bottle) => bottle.clusterSubY).toList();
    subY.add(0); // This ensure .reduce will always return at least 0

    int maxSubY = subY.reduce((value, element) => max(value ?? 0, element ?? 0)) ?? 0;

    if (widget.shouldDisplayNewSubRow) {
      maxSubY++;
    }

    rowColumnChildren.add(getSubRowLayout(clusterId, rowId, maxSubY, width, bottles));

    List<Widget> mainRowCells = [];
    for (int i = 0; i < width; i++) {
      Bottle? currentBottle = bottles.firstWhereOrNull((bottle) => bottle.clusterSubY == 0 && bottle.clusterX == i);

      mainRowCells
          .add(getCell(currentBottle, true, clusterId, rowId, 0, i, blinking: currentBottle != null && widget.blinkingBottleId == currentBottle.id));
    }

    // Add some empty cells to fill the row
    for (int j = width; j < maxWidth; j++) {
      rowColumnChildren.add(
        const SizedBox(
          width: 35,
          height: 35,
        ),
      );
    }

    rowColumnChildren.add(Row(children: mainRowCells));
    return Column(
      children: rowColumnChildren,
    );
  }

  List<Widget> getClusterLayout(
      int width, int height, CellarCluster cluster, Map<int, List<Bottle>> clusterBottlesByRow, Map<int, List<int>> clustersRowConfiguration) {
    if (cluster.id == null) {
      return [];
    }

    List<Widget> rows = [];

    List<Widget> firstRow = [const SizedBox(width: 35, height: 35, child: Center(child: Icon(Icons.wine_bar_outlined)))];
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

      rowChildren.add(getRowLayout(cluster.id!, i, width, clustersRowConfiguration[cluster.id!]![i], height, clusterBottlesByRow[i] ?? []));

      if (widget.customize) {
        rows.add(Stack(alignment: AlignmentGeometry.lerp(Alignment.topLeft, Alignment.bottomRight, 0.5)!, children: [
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
                  context.read<ClustersProvider>().updateClustersRowConfiguration(cluster.id!, i, clustersRowConfiguration[cluster.id!]![i] - 1);
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
                  if (clustersRowConfiguration[cluster.id!]![i] >= cluster.width!) {
                    return;
                  }
                  context.read<ClustersProvider>().updateClustersRowConfiguration(cluster.id!, i, clustersRowConfiguration[cluster.id!]![i] + 1);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ]));
      } else {
        rows.add(Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: rowChildren,
        ));
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {

    if (widget.clusters.isEmpty) {
      return const Text("Bad clusters configuration");
    }

    if (widget.clusters.length > 1) {
      (int, List<Tab>) tabs = getTabs(widget.clusters);

      return DefaultTabController(
        length: widget.clusters.length,
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
                child: TabBarView(children: getTabsContent(widget.cellarType, widget.clusters, widget.bottlesByClusterByRow,
                    widget.clustersRowConfiguration))),
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.clusters[0].name ?? widget.cellarType.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...getClusterLayout(widget.clusters[0].width ?? 0, widget.clusters[0].height ?? 0, widget.clusters[0],
                widget.bottlesByClusterByRow[widget.clusters[0].id!]!, widget.clustersRowConfiguration),
          ]),
        ),
      ),
    );
  }
}
