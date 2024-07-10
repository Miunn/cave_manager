import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/screens/cellar/move_bottle.dart';
import 'package:cave_manager/screens/take_picture.dart';
import 'package:cave_manager/widgets/delete_bottle_dialog.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../models/enum_wine_colors.dart';
import '../widgets/open_bottle_dialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottleDetails extends StatefulWidget {
  const BottleDetails({super.key, required this.bottleId});

  // Load bottle across the provider instead of passing it as a parameter
  // So updates are reflected in the UI (and other children)
  final int bottleId;

  @override
  State<BottleDetails> createState() => _BottleDetailState();
}

class _BottleDetailState extends State<BottleDetails> {
  late CameraDescription _camera;

  @override
  void initState() {
    getCam();
    super.initState();
  }

  getCam() async {
    List<CameraDescription> cameras = await availableCameras();
    _camera = cameras.first;
  }

  deleteBottleCallback(BuildContext context, Bottle bottle) {
    Provider.of<BottlesProvider>(context, listen: false).deleteBottle(bottle);
    Navigator.pop(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: scaffoldKey,
      content: Text(AppLocalizations.of(context)!.deletedBottle),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.undo,
        onPressed: () {
          scaffoldKey.currentContext?.read<BottlesProvider>().addBottle(bottle);
          ScaffoldMessenger.of(scaffoldKey.currentContext ?? context)
              .showSnackBar(SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.deletedCanceled)));
        },
      ),
    ));
  }

  openBottle(BuildContext context, Bottle bottle) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    bottle.isOpen = true;
    bottle.openedAt = DateTime.now();
    context.read<BottlesProvider>().updateBottle(bottle);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: scaffoldKey,
      content: Text(AppLocalizations.of(context)!.takenOutBottle),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.undo,
        onPressed: () {
          bottle.isOpen = false;
          bottle.tastingNote = null;
          scaffoldKey.currentContext
              ?.read<BottlesProvider>()
              .updateBottle(bottle);
          ScaffoldMessenger.of(scaffoldKey.currentContext ?? context)
              .showSnackBar(SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.takenOutCanceled)));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Bottle bottle = context.select<BottlesProvider, Bottle>(
        (provider) => provider.getBottleById(widget.bottleId));
    String? colorText;
    Country? bottleCountry =
        (bottle.country == null) ? null : Country.tryParse(bottle.country!);
    String cellarPositionFormatted = (bottle.clusterId == null)
        ? AppLocalizations.of(context)!.unknown
        : "${AppLocalizations.of(context)!.row} ${bottle.clusterY! + 1} ${AppLocalizations.of(context)!.column} ${bottle.clusterX! + 1}";

    switch (WineColors.values.firstWhere((e) => e.value == bottle.color)) {
      case WineColors.red:
        colorText = WineColors.red.label;
        break;

      case WineColors.pink:
        colorText = WineColors.pink.label;
        break;

      case WineColors.white:
        colorText = WineColors.white.label;
        break;

      case WineColors.other:
        colorText = WineColors.other.label;
        break;

      default:
        colorText = AppLocalizations.of(context)!.unknownColor;
    }

    String inCellarString = "";
    Duration inCellarSince = DateTime.now().difference(bottle.createdAt!);
    int years = inCellarSince.inDays ~/ 365;
    int extraDaysInYears = inCellarSince.inDays % 365;

    debugPrint("Years: $years, extra days: $extraDaysInYears");
    if (inCellarSince.inDays == 0) {
      inCellarString = AppLocalizations.of(context)!.today;
    } else if (inCellarSince.inDays == 1) {
      inCellarString = AppLocalizations.of(context)!.yesterday;
    } else {
      inCellarString =
          AppLocalizations.of(context)!.xYearsXDays(extraDaysInYears, years);
    }

    registerNewPicture() async {
      if (!context.mounted) {
        return;
      }

      XFile? capturedImage = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: _camera)),
      );

      if (capturedImage == null) {
        return;
      }

      await bottle.setImage(capturedImage);

      context.read<BottlesProvider>().updateBottle(bottle);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${bottle.name}',
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              bool? shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteBottleDialog(bottle: bottle);
                  });

              if ((shouldDelete ?? false) && context.mounted) {
                deleteBottleCallback(context, bottle);
              }
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 160,
                      child: (bottle.imageUri == null)
                          ? IconButton(
                              padding: const EdgeInsets.all(8.0),
                              icon: Image.asset(
                                'assets/wine-bottle.png',
                                width: 70,
                                height: 70,
                              ),
                              iconSize: 70,
                              onPressed: registerNewPicture,
                            )
                          : IconButton(
                              icon: Image.file(File(bottle.imageUri!)),
                              onPressed: registerNewPicture,
                            ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${bottle.name}"),
                        Text(
                          (bottle.signature == null ||
                                  bottle.signature!.isEmpty)
                              ? AppLocalizations.of(context)!.noEstate
                              : "${bottle.signature}",
                          style: TextStyle(
                              fontStyle: (bottle.signature == null ||
                                      bottle.signature!.isEmpty)
                                  ? FontStyle.italic
                                  : FontStyle.normal),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              (bottle.vintageYear == null)
                                  ? AppLocalizations.of(context)!.noVintage
                                  : "${bottle.vintageYear}",
                              style: TextStyle(
                                  fontStyle: (bottle.vintageYear == null)
                                      ? FontStyle.italic
                                      : FontStyle.normal),
                            ),
                            const Spacer(),
                            const Text("75cl")
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Offstage(
                offstage: bottle.isOpen!,
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            Bottle? updatedBottle =
                                await Navigator.of(context).push<Bottle?>(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MoveBottle(bottle: bottle)),
                            );

                            if (updatedBottle != null && context.mounted) {
                              context
                                  .read<BottlesProvider>()
                                  .updateBottle(updatedBottle);
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.move),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            bool? open = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) =>
                                  OpenBottleDialog(bottle: bottle),
                            );

                            if (open != null && open && context.mounted) {
                              openBottle(context, bottle);
                            }
                          },
                          child:
                              Text(AppLocalizations.of(context)!.takeOutBottle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: bottle.isOpen!,
                child: const SizedBox(
                  height: 15,
                ),
              ),
              Text(AppLocalizations.of(context)!.specifications.toUpperCase()),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 220, 220)),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.color),
                          const Spacer(),
                          Text(colorText),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.alcoholLevel),
                          const Spacer(),
                          Text(
                            bottle.alcoholLevel == null
                                ? AppLocalizations.of(context)!.unknown
                                : "${bottle.alcoholLevel} %",
                            style: TextStyle(
                                fontStyle: bottle.alcoholLevel == null
                                    ? FontStyle.italic
                                    : FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.grapeVariety),
                          const Spacer(),
                          Text(
                            (bottle.grapeVariety == null ||
                                    bottle.grapeVariety!.isEmpty)
                                ? AppLocalizations.of(context)!.unknown
                                : "${bottle.grapeVariety}",
                            style: TextStyle(
                                fontStyle: (bottle.grapeVariety == null ||
                                        bottle.grapeVariety!.isEmpty)
                                    ? FontStyle.italic
                                    : FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    Offstage(
                      offstage: bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(AppLocalizations.of(context)!.inCellarSince),
                            const Spacer(),
                            Text(inCellarString),
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: bottle.isOpen!,
                      child: const Divider(
                        height: 1,
                        color: Color.fromARGB(255, 220, 220, 220),
                      ),
                    ),
                    Consumer<ClustersProvider>(
                      builder: (BuildContext context, ClustersProvider clusters,
                              Widget? child) =>
                          Offstage(
                        offstage:
                            (bottle.isOpen! && clusters.clusters.length <= 1),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(clusters.cellarType.label),
                              const Spacer(),
                              Text(
                                clusters
                                            .getClusterById(bottle.clusterId!)
                                            ?.name! ==
                                        null
                                    ? AppLocalizations.of(context)!.unknown
                                    : clusters
                                        .getClusterById(bottle.clusterId!)!
                                        .name!,
                                style: TextStyle(
                                  fontStyle: bottle.clusterId == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Consumer<ClustersProvider>(
                      builder: (BuildContext context, ClustersProvider clusters,
                              Widget? child) =>
                          Offstage(
                        offstage:
                            (bottle.isOpen! && clusters.clusters.length <= 1),
                        child: const Divider(
                          height: 1,
                          color: Color.fromARGB(255, 220, 220, 220),
                        ),
                      ),
                    ),
                    Offstage(
                        offstage: bottle.isOpen!,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(AppLocalizations.of(context)!.location),
                              const Spacer(),
                              Text(
                                cellarPositionFormatted,
                                style: TextStyle(
                                  fontStyle: bottle.clusterId == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Offstage(
                      offstage: !bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text("Mise en cave le"),
                            const Spacer(),
                            Text(DateFormat.yMMMd().format(bottle.createdAt!))
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !bottle.isOpen!,
                      child: const Divider(
                        height: 1,
                        color: Color.fromARGB(255, 220, 220, 220),
                      ),
                    ),
                    Offstage(
                      offstage: !bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(AppLocalizations.of(context)!.takenOutDate),
                            const Spacer(),
                            Text(
                                // Test to be able to perform null operator
                                ((bottle.isOpen ?? false) &&
                                        bottle.openedAt != null)
                                    ? DateFormat.yMMMd()
                                        .format(bottle.openedAt!)
                                    : "Aucune donnée"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(AppLocalizations.of(context)!.origin.toUpperCase()),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 220, 220)),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.country),
                          const Spacer(),
                          Text(
                            bottle.country == null
                                ? AppLocalizations.of(context)!.unknown
                                : "${bottleCountry?.flagEmoji} ${bottleCountry?.displayNameNoCountryCode}",
                            style: TextStyle(
                                fontStyle: bottle.country == null
                                    ? FontStyle.italic
                                    : FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.region),
                          const Spacer(),
                          Text(
                            (bottle.area == null || bottle.area!.isEmpty)
                                ? AppLocalizations.of(context)!.unknown
                                : "${bottle.area}",
                            style: TextStyle(
                                fontStyle: (bottle.area == null ||
                                        bottle.area!.isEmpty)
                                    ? FontStyle.italic
                                    : FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.subRegion),
                          const Spacer(),
                          Text(
                            (bottle.subArea == null || bottle.subArea!.isEmpty)
                                ? AppLocalizations.of(context)!.unknown
                                : "${bottle.subArea}",
                            style: TextStyle(
                                fontStyle: (bottle.subArea == null ||
                                        bottle.subArea!.isEmpty)
                                    ? FontStyle.italic
                                    : FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: bottle.isOpen! ||
                      (bottle.tastingNote != null &&
                          bottle.tastingNote!.isNotEmpty),
                  child: Text(AppLocalizations.of(context)!.tasting)),
              Visibility(
                visible: bottle.isOpen! ||
                    (bottle.tastingNote != null &&
                        bottle.tastingNote!.isNotEmpty),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 220, 220, 220)),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      (bottle.tastingNote == null ||
                              bottle.tastingNote!.isEmpty)
                          ? AppLocalizations.of(context)!.tastingNoteEmpty
                          : bottle.tastingNote!,
                      style: TextStyle(
                        fontStyle: (bottle.tastingNote == null ||
                                bottle.tastingNote!.isEmpty)
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
