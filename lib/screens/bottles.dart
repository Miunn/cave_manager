import 'package:cave_manager/models/enum_sort_type.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/screens/add_bottle_dialog.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/widgets/bottle_list_card.dart';
import 'package:cave_manager/widgets/dropdown_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/area_enum.dart';
import '../models/bottle.dart';
import '../models/enum_wine_colors.dart';

class Bottles extends StatefulWidget {
  const Bottles({super.key});

  @override
  State<Bottles> createState() => _BottlesState();
}

class _BottlesState extends State<Bottles> {
  Set<WineColors> colorFilters = <WineColors>{};
  Areas? areaFilter;
  SortType sortName = SortType.none;
  SortType sortDomain = SortType.none;

  List<Bottle> filterBottles(List<Bottle> bottles) {
    List<Bottle> filteredBottles = colorFilters.isEmpty
        ? bottles
        : bottles
            .where((bottle) => colorFilters
                .contains(WineColors.fromValue(bottle.color ?? "other")))
            .toList();

    // Care to filter on area label because autocomplete widget register the label inside the database
    filteredBottles = areaFilter == null
        ? filteredBottles
        : filteredBottles
            .where((bottle) => bottle.area == areaFilter!.label)
            .toList();

    if (sortName != SortType.none) {
      filteredBottles.sort((a, b) {
        if (sortName == SortType.ascending) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        } else {
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        }
      });
    }

    if (sortDomain != SortType.none) {
      filteredBottles.sort((a, b) {
        if (sortDomain == SortType.ascending) {
          return a.signature!.toLowerCase().compareTo(b.signature!.toLowerCase());
        } else {
          return b.signature!.toLowerCase().compareTo(a.signature!.toLowerCase());
        }
      });
    }

    return filteredBottles;
  }
  
  getSortIcon(SortType sortType) {
    if (sortType == SortType.ascending) {
      return const Icon(Icons.arrow_upward, color: Colors.black);
    } else if (sortType == SortType.descending) {
      return const Icon(Icons.arrow_downward, color: Colors.black);
    } else {
      return const Icon(Icons.swap_vert, color: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI needs to change only when a bottle's name, domain or open status changes
    List<Bottle> openedBottles = filterBottles(
        context.select<BottlesProvider, List<Bottle>>(
            (provider) => provider.openedBottles).toList());
    List<Bottle> closedBottles = filterBottles(
        context.select<BottlesProvider, List<Bottle>>(
            (provider) => provider.closedBottles).toList());

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Bouteilles"),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Settings(title: "Paramètres")),
                  ),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.all(8.0)),
                      hintText: "Rechercher une bouteille",
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (String value) {
                        controller.openView();
                        //context.read<BottlesProvider>().searchBottles(value);
                      },
                      leading: const Icon(Icons.search),
                    );
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    List<Bottle> searchSuggest = context
                        .read<BottlesProvider>()
                        .searchBottles(controller.text);
                    return List.generate(searchSuggest.length, (index) {
                      Bottle item = searchSuggest[index];
                      return ListTile(
                        title: Text(item.name ?? "No name"),
                        onTap: () {
                          controller.closeView(item.name ?? "No name");
                          controller.clear();
                          Navigator.of(context).push(
                            MaterialPageRoute<Bottle>(
                              builder: (BuildContext context) =>
                                  BottleDetails(bottleId: item.id!),
                            ),
                          );
                        },
                      );
                    });
                  }),
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text(
                        "Rouge",
                      ),
                      selected: colorFilters.contains(WineColors.red),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            colorFilters.add(WineColors.red);
                          } else {
                            colorFilters.remove(WineColors.red);
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text(
                        "Rosé",
                      ),
                      selected: colorFilters.contains(WineColors.pink),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            colorFilters.add(WineColors.pink);
                          } else {
                            colorFilters.remove(WineColors.pink);
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text(
                        "Blanc",
                      ),
                      selected: colorFilters.contains(WineColors.white),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            colorFilters.add(WineColors.white);
                          } else {
                            colorFilters.remove(WineColors.white);
                          }
                        });
                      },
                    ),
                    DropdownChip(
                        label: const Text("Région"),
                        items: Areas.values
                            .map((area) => (area.value, Text(area.label)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            areaFilter = Areas.fromValue(value);
                          });
                        }),
                    ActionChip(
                      avatar: getSortIcon(sortName),
                      label: const Text("A-Z Nom"),
                      onPressed: () {
                        setState(() {
                          sortName = sortName.next();
                        });
                      },
                    ),
                    ActionChip(
                      avatar: getSortIcon(sortDomain),
                      label: const Text("A-Z Domaine"),
                      onPressed: () {
                        setState(() {
                          sortDomain = sortDomain.next();
                        });
                      },
                    ),
                  ],
                ),
                (closedBottles.length > 1)
                    ? Text(
                        "${closedBottles.length} Bouteilles en cave",
                        style: const TextStyle(fontSize: 15),
                      )
                    : Text(
                        "${closedBottles.length} Bouteille en cave",
                        style: const TextStyle(fontSize: 15),
                      ),
                Visibility(
                  visible: closedBottles.isEmpty,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Aucune bouteille en cave",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: closedBottles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BottleListCard(bottleId: closedBottles[index].id!);
                    }),
                const SizedBox(
                  height: 20,
                ),
                (openedBottles.length > 1)
                    ? Text(
                        "${openedBottles.length} Bouteilles ouvertes",
                        style: const TextStyle(fontSize: 15),
                      )
                    : Text(
                        "${openedBottles.length} Bouteille ouverte",
                        style: const TextStyle(fontSize: 15),
                      ),
                Visibility(
                  visible: openedBottles.isEmpty,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Aucune bouteille ouverte",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: openedBottles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BottleListCard(bottleId: openedBottles[index].id!);
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<Bottle>(
              fullscreenDialog: true,
              builder: (BuildContext context) => const AddBottleDialog()));
        },
        tooltip: "Insert new bottle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
