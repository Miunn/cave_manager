import 'package:cave_manager/models/enum_sort_type.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/screens/add_bottle_dialog.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/widgets/bottle_list_card.dart';
import 'package:cave_manager/widgets/dropdown_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/area_enum.dart';
import '../../models/bottle.dart';
import '../../models/enum_wine_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.bottles),
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
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.all(8.0)),
                      hintText: AppLocalizations.of(context)!.searchBottle,
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
                        title: Text(item.name ?? AppLocalizations.of(context)!.noName),
                        onTap: () {
                          controller.closeView(item.name ?? AppLocalizations.of(context)!.noName);
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
                      label: Text(AppLocalizations.of(context)!.wineColors(WineColors.red.value)),
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
                      label: Text(AppLocalizations.of(context)!.wineColors(WineColors.pink.value)),
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
                      label: Text(AppLocalizations.of(context)!.wineColors(WineColors.white.value)),
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
                        label: Text(AppLocalizations.of(context)!.region),
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
                      label: Text(AppLocalizations.of(context)!.sortName),
                      onPressed: () {
                        setState(() {
                          sortName = sortName.next();
                        });
                      },
                    ),
                    ActionChip(
                      avatar: getSortIcon(sortDomain),
                      label: Text(AppLocalizations.of(context)!.sortEstate),
                      onPressed: () {
                        setState(() {
                          sortDomain = sortDomain.next();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.bottlesCellar(closedBottles.length), style: const TextStyle(fontSize: 15)),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: closedBottles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BottleListCard(bottleId: closedBottles[index].id!);
                    }),
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context)!.bottlesTakenOut(openedBottles.length), style: const TextStyle(fontSize: 15)),
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
        tooltip: AppLocalizations.of(context)!.insertBottle,
        child: const Icon(Icons.add),
      ),
    );
  }
}
