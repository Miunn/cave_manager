import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/screens/cellar/move_bottle.dart';
import 'package:cave_manager/screens/cellar/place_in_cellar.dart';
import 'package:cave_manager/screens/take_picture.dart';
import 'package:cave_manager/widgets/bottle_detail_line.dart';
import 'package:cave_manager/widgets/dialogs/dialog_delete_bottle.dart';
import 'package:cave_manager/widgets/dialogs/dialog_delete_cover.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/bottle.dart';
import '../models/enum_wine_colors.dart';
import '../widgets/dialogs/dialog_open_bottle.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'view_image.dart';

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
    debugPrint(bottle.toString());
    String? colorText;
    Country? bottleCountry =
        (bottle.country == null) ? null : Country.tryParse(bottle.country!);
    String cellarPositionFormatted = (bottle.clusterId == null)
        ? AppLocalizations.of(context)!.unknown
        : "${AppLocalizations.of(context)!.row} ${bottle.clusterY! + 1} ${AppLocalizations.of(context)!.column} ${bottle.clusterX! + 1}";

    switch (WineColors.values.firstWhere((e) => e.value == bottle.color)) {
      case WineColors.red:
        colorText =
            AppLocalizations.of(context)!.wineColors(WineColors.red.value);
        break;

      case WineColors.pink:
        colorText =
            AppLocalizations.of(context)!.wineColors(WineColors.pink.value);
        break;

      case WineColors.white:
        colorText =
            AppLocalizations.of(context)!.wineColors(WineColors.white.value);
        break;

      case WineColors.other:
        colorText =
            AppLocalizations.of(context)!.wineColors(WineColors.other.value);
        break;

      default:
        colorText = AppLocalizations.of(context)!.wineColors('other');
    }

    String inCellarString = "";
    Duration inCellarSince = DateTime.now().difference(bottle.createdAt!);
    int years = inCellarSince.inDays ~/ 365;
    int extraDaysInYears = inCellarSince.inDays % 365;

    if (inCellarSince.inDays == 0) {
      inCellarString = AppLocalizations.of(context)!.today;
    } else if (inCellarSince.inDays == 1) {
      inCellarString = AppLocalizations.of(context)!.yesterday;
    } else {
      inCellarString =
          AppLocalizations.of(context)!.xYearsXDays(extraDaysInYears, years);
    }

    registerNewPicture() async {
      XFile? capturedImage = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: _camera)),
      );

      if (capturedImage == null) {
        return;
      }

      await bottle.setImage(capturedImage);

      if (context.mounted) {
        context.read<BottlesProvider>().updateBottle(bottle);
      }
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
                              onPressed: () => showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                            width: 75,
                                            child: Divider(thickness: 4)),
                                        Flexible(
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.remove_red_eye),
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .viewImage),
                                                onTap: () async {
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewImage(
                                                              imagePath: bottle
                                                                  .imageUri!),
                                                    ),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.camera_alt),
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .takePicture),
                                                onTap: registerNewPicture,
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.image),
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .choosePicture),
                                                onTap: registerNewPicture,
                                              ),
                                              ListTile(
                                                leading: Icon(
                                                    Icons.delete_forever,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error),
                                                title: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .deletePicture,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error)),
                                                onTap: () async {
                                                  // Confirmation dialog
                                                  bool? shouldDelete =
                                                      await showDialog<bool>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              DeleteBottleCoverDialog(
                                                                  bottle:
                                                                      bottle));

                                                  if (!(shouldDelete ??
                                                      false)) {
                                                    return;
                                                  }

                                                  await bottle.deleteImage();
                                                  if (context.mounted) {
                                                    await context
                                                        .read<BottlesProvider>()
                                                        .updateBottle(bottle);
                                                  }
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    // Confirmation snack bar
                                                    final GlobalKey<
                                                            ScaffoldState>
                                                        scaffoldKey = GlobalKey<
                                                            ScaffoldState>();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      key: scaffoldKey,
                                                      content: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .deleteBottleCoverConfirmation),
                                                    ));
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
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
                      Consumer<ClustersProvider>(
                        builder: (BuildContext context,
                                ClustersProvider clusters, Widget? child) =>
                            Visibility(
                          visible: clusters.isCellarConfigured,
                          child: Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                Bottle? updatedBottle =
                                    await Navigator.of(context).push<Bottle?>(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          (bottle.isInCellar ?? false)
                                              ? MoveBottle(bottle: bottle)
                                              : PlaceInCellar(bottle: bottle)),
                                );

                                if (updatedBottle != null && context.mounted) {
                                  context
                                      .read<BottlesProvider>()
                                      .updateBottle(updatedBottle);
                                }
                              },
                              child: Text((bottle.isInCellar ?? false)
                                  ? AppLocalizations.of(context)!.move
                                  : AppLocalizations.of(context)!
                                      .placeInCellar),
                            ),
                          ),
                        ),
                      ),
                      Consumer<ClustersProvider>(
                          builder: (BuildContext context,
                                  ClustersProvider clusters, Widget? child) =>
                              Visibility(
                                  visible: clusters.isCellarConfigured,
                                  child: const SizedBox(width: 15))),
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
                          child: Text(
                            (bottle.isInCellar ?? false)
                                ? AppLocalizations.of(context)!.takeOutBottle
                                : AppLocalizations.of(context)!.openBottle,
                          ),
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
              Offstage(
                offstage: bottle.isInCellar ?? false,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 220, 220)),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Consumer<ClustersProvider>(
                          builder: (BuildContext context,
                                  ClustersProvider clusters, Widget? child) =>
                              Text((clusters.isCellarConfigured)
                                  ? AppLocalizations.of(context)!
                                      .outsideOfCellarWarning
                                  : AppLocalizations.of(context)!
                                      .configureCellarToRegisterThisBottle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: bottle.isInCellar ?? false,
                child: const SizedBox(height: 15),
              ),
              Text(AppLocalizations.of(context)!.specifications.toUpperCase()),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 220, 220)),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  children: <Widget>[
                    BottleDetailLine(
                      leftSideText: AppLocalizations.of(context)!.color,
                      rightSideText: colorText,
                    ),
                    const Divider(
                        height: 1, color: Color.fromARGB(255, 220, 220, 220)),
                    BottleDetailLine(
                      leftSideText: AppLocalizations.of(context)!.alcoholLevel,
                      rightSideText: bottle.alcoholLevel == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${bottle.alcoholLevel} %",
                      rightSideTextStyle: TextStyle(
                          fontStyle: bottle.alcoholLevel == null
                              ? FontStyle.italic
                              : FontStyle.normal),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    BottleDetailLine(
                      leftSideText: AppLocalizations.of(context)!.grapeVariety,
                      rightSideText: (bottle.grapeVariety == null ||
                              bottle.grapeVariety!.isEmpty)
                          ? AppLocalizations.of(context)!.unknown
                          : "${bottle.grapeVariety}",
                      rightSideTextStyle: TextStyle(
                          fontStyle: (bottle.grapeVariety == null ||
                                  bottle.grapeVariety!.isEmpty)
                              ? FontStyle.italic
                              : FontStyle.normal),
                    ),
                    const Divider(
                        height: 1, color: Color.fromARGB(255, 220, 220, 220)),
                    Offstage(
                      offstage: !(bottle.isInCellar ?? false),
                      child: BottleDetailLine(
                          leftSideText:
                              AppLocalizations.of(context)!.inCellarSince,
                          rightSideText: inCellarString),
                    ),
                    Offstage(
                      offstage: !(bottle.isInCellar ?? false),
                      child: const Divider(
                          height: 1, color: Color.fromARGB(255, 220, 220, 220)),
                    ),
                    Consumer<ClustersProvider>(builder: (BuildContext context,
                        ClustersProvider clusters, Widget? child) {
                      if (bottle.clusterId == null) {
                        return const SizedBox();
                      }

                      return Offstage(
                        offstage:
                            (bottle.isOpen! && clusters.clusters.length <= 1),
                        child: BottleDetailLine(
                          leftSideText: AppLocalizations.of(context)!
                              .cellarTypes(clusters.cellarType.value),
                          rightSideText: clusters
                                      .getClusterById(bottle.clusterId!)
                                      ?.name! ==
                                  null
                              ? AppLocalizations.of(context)!.unknown
                              : clusters
                                  .getClusterById(bottle.clusterId!)!
                                  .name!,
                          rightSideTextStyle: TextStyle(
                            fontStyle: bottle.clusterId == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      );
                    }),
                    Consumer<ClustersProvider>(builder: (BuildContext context,
                        ClustersProvider clusters, Widget? child) {
                      if (bottle.clusterId == null) {
                        return const SizedBox();
                      }
                      return Offstage(
                        offstage:
                            (bottle.isOpen! && clusters.clusters.length <= 1) ||
                                bottle.clusterId == null,
                        child: const Divider(
                            height: 1,
                            color: Color.fromARGB(255, 220, 220, 220)),
                      );
                    }),
                    Offstage(
                      offstage: bottle.isOpen! || bottle.clusterId == null,
                      child: BottleDetailLine(
                        leftSideText: AppLocalizations.of(context)!.location,
                        rightSideText: cellarPositionFormatted,
                        rightSideTextStyle: TextStyle(
                          fontStyle: bottle.clusterId == null
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(bottle.isInCellar ?? false),
                      child: BottleDetailLine(
                        leftSideText:
                            AppLocalizations.of(context)!.inCellarSince,
                        rightSideText: DateFormat.yMMMd().format(
                            bottle.registeredInCellarAt ?? DateTime.now()),
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
                      child: BottleDetailLine(
                        leftSideText:
                            AppLocalizations.of(context)!.takenOutDate,
                        rightSideText: ((bottle.isOpen ?? false) &&
                                bottle.openedAt != null)
                            ? DateFormat.yMMMd().format(bottle.openedAt!)
                            : AppLocalizations.of(context)!.unknown,
                      ),
                    ),
                    BottleDetailLine(
                        leftSideText:
                            AppLocalizations.of(context)!.bottleCreatedAt,
                        rightSideText: (bottle.createdAt != null)
                            ? DateFormat.yMMMd().format(bottle.createdAt!)
                            : AppLocalizations.of(context)!.unknown),
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
                    BottleDetailLine(
                      leftSideText: AppLocalizations.of(context)!.country,
                      rightSideText: bottle.country == null
                          ? AppLocalizations.of(context)!.unknown
                          : "${bottleCountry?.flagEmoji} ${bottleCountry?.displayNameNoCountryCode}",
                      rightSideTextStyle: TextStyle(
                          fontStyle: bottle.country == null
                              ? FontStyle.italic
                              : FontStyle.normal),
                    ),
                    const Divider(
                        height: 1, color: Color.fromARGB(255, 220, 220, 220)),
                    BottleDetailLine(
                      leftSideText: AppLocalizations.of(context)!.region,
                      rightSideText:
                          (bottle.area == null || bottle.area!.isEmpty)
                              ? AppLocalizations.of(context)!.unknown
                              : "${bottle.area}",
                      rightSideTextStyle: TextStyle(
                          fontStyle:
                              (bottle.area == null || bottle.area!.isEmpty)
                                  ? FontStyle.italic
                                  : FontStyle.normal),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 220, 220, 220),
                    ),
                    BottleDetailLine(
                      leftSideText: AppLocalizations.of(context)!.subRegion,
                      rightSideText:
                          (bottle.subArea == null || bottle.subArea!.isEmpty)
                              ? AppLocalizations.of(context)!.unknown
                              : "${bottle.subArea}",
                      rightSideTextStyle: TextStyle(
                          fontStyle: (bottle.subArea == null ||
                                  bottle.subArea!.isEmpty)
                              ? FontStyle.italic
                              : FontStyle.normal),
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
