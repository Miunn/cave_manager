import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cave_manager/screens/take_picture.dart';
import 'package:cave_manager/utils/cellar_db_interface.dart';
import 'package:cave_manager/widgets/delete_bottle_dialog.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bottle.dart';
import '../models/cluster.dart';
import '../models/wine_colors_enum.dart';
import '../utils/bottle_db_interface.dart';
import '../widgets/open_bottle_dialog.dart';

class BottleDetails extends StatefulWidget {
  const BottleDetails({super.key, required this.bottle});

  final Bottle bottle;

  @override
  State<BottleDetails> createState() => _BottleDetailState();
}

class _BottleDetailState extends State<BottleDetails> {
  CellarDatabaseInterface cellarDatabase = CellarDatabaseInterface.instance;
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;
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

  Future<CellarCluster?> bottleCluster() async {
    return await cellarDatabase.getBottleCluster(widget.bottle);
  }

  @override
  Widget build(BuildContext context) {
    String? colorText;
    Country? bottleCountry = (widget.bottle.country == null) ? null : Country.tryParse(widget.bottle.country!);
    String cellarPositionFormatted = (widget.bottle.clusterId == null) ? "Non renseigné" : "Ligne ${widget.bottle.clusterY!} Colonne ${widget.bottle.clusterX!}";

    switch (
        WineColors.values.firstWhere((e) => e.value == widget.bottle.color)) {
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
        colorText = "Couleur non renseigné";
    }

    String inCellarString = "";
    Duration inCellarSince =
        DateTime.now().difference(widget.bottle.createdAt!);
    int years = inCellarSince.inDays ~/ 365;
    int extraDaysInYears = inCellarSince.inDays % 365;

    if (inCellarSince.inDays == 0) {
      inCellarString = "Aujourd'hui";
    } else if (inCellarSince.inDays == 1) {
      inCellarString = "Hier";
    } else if (inCellarSince.inDays < 365) {
      inCellarString = "${inCellarSince.inDays} jours";
    } else if (inCellarSince.inDays == 365) {
      inCellarString = "1 an";
    } else if (years == 1 && extraDaysInYears == 1) {
      inCellarString = "1 an 1 jour";
    } else if (years == 1) {
      inCellarString = "1 an $extraDaysInYears jours";
    } else if (extraDaysInYears == 1) {
      inCellarString = "$years ans 1 jour";
    } else {
      inCellarString = "$years ans $extraDaysInYears jours";
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

      await widget.bottle.setImage(capturedImage);
      setState(() {
        bottleDatabase.update(widget.bottle);
      });
    }

    deleteBottleCallback() {
      bottleDatabase.delete(widget.bottle.id!);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Bouteille supprimée'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            setState(() {
              bottleDatabase.insert(widget.bottle);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Suppression annulée'),
              ));
            });
          },
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${widget.bottle.name}',),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
          ),
          IconButton(
              onPressed: () async {
                bool? showDelete = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteBottleDialog(bottle: widget.bottle);
                });

                if (showDelete == null || !showDelete) {
                  return;
                }

                deleteBottleCallback();
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
                      child: (widget.bottle.imageUri == null)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/wine-bottle.png',
                                  width: 70,
                                  height: 70,
                                ),
                                iconSize: 70,
                                onPressed: registerNewPicture,
                              ),
                            )
                          : IconButton(
                              icon: Image.file(File(widget.bottle.imageUri!)),
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
                        Text("${widget.bottle.name}"),
                        Text(
                          (widget.bottle.signature == null ||
                                  widget.bottle.signature!.isEmpty)
                              ? "Aucun domaine"
                              : "${widget.bottle.signature}",
                          style: TextStyle(
                              fontStyle: (widget.bottle.signature == null ||
                                      widget.bottle.signature!.isEmpty)
                                  ? FontStyle.italic
                                  : FontStyle.normal),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              (widget.bottle.vintageYear == null)
                                  ? "Aucun millésime"
                                  : "${widget.bottle.vintageYear}",
                              style: TextStyle(
                                  fontStyle: (widget.bottle.vintageYear == null)
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
                offstage: widget.bottle.isOpen!,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      bool? open = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) =>
                            OpenBottleDialog(bottle: widget.bottle),
                      );

                      if (open == null || !open) {
                        return;
                      }

                      widget.bottle.isOpen = true;
                      widget.bottle.openedAt = DateTime.now();
                      await bottleDatabase.update(widget.bottle);

                      setState(() {});
                    },
                    child: const Text("Sortir de cave"),
                  ),
                ),
              ),
              Offstage(
                offstage: widget.bottle.isOpen!,
                child: const SizedBox(
                  height: 15,
                ),
              ),
              const Text("SPECIFICATIONS"),
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
                          const Text("Couleur"),
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
                          const Text("Degré"),
                          const Spacer(),
                          Text(
                            widget.bottle.alcoholLevel == null
                                ? "Non renseigné"
                                : "${widget.bottle.alcoholLevel} %",
                            style: TextStyle(
                                fontStyle: widget.bottle.alcoholLevel == null
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
                          const Text("Cépage"),
                          const Spacer(),
                          Text(
                            (widget.bottle.grapeVariety == null || widget.bottle.grapeVariety!.isEmpty)
                                ? "Non renseigné"
                                : "${widget.bottle.grapeVariety}",
                            style: TextStyle(
                                fontStyle: (widget.bottle.grapeVariety == null || widget.bottle.grapeVariety!.isEmpty)
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
                      offstage: widget.bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text("En cave depuis"),
                            const Spacer(),
                            Text(inCellarString),
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: widget.bottle.isOpen!,
                      child: const Divider(
                        height: 1,
                        color: Color.fromARGB(255, 220, 220, 220),
                      ),
                    ),
                    Offstage(
                      offstage: widget.bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text("Emplacement"),
                            const Spacer(),
                            Text(
                                cellarPositionFormatted,
                              style: TextStyle(
                                fontStyle: widget.bottle.clusterId == null
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                    Offstage(
                      offstage: !widget.bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text("Mise en cave le"),
                            const Spacer(),
                            Text(DateFormat.yMMMd()
                                .format(widget.bottle.createdAt!))
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !widget.bottle.isOpen!,
                      child: const Divider(
                        height: 1,
                        color: Color.fromARGB(255, 220, 220, 220),
                      ),
                    ),
                    Offstage(
                      offstage: !widget.bottle.isOpen!,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text("Sortie le"),
                            const Spacer(),
                            Text(
                                // Test to be able to perform null operator
                                widget.bottle.isOpen!
                                    ? DateFormat.yMMMd()
                                        .format(widget.bottle.openedAt!)
                                    : DateFormat.yMMMd().format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            0))),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "ORIGINE",
              ),
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
                          const Text("Pays"),
                          const Spacer(),
                          Text(
                            widget.bottle.country == null
                                ? "Non renseigné"
                                : "${bottleCountry?.flagEmoji} ${bottleCountry?.displayNameNoCountryCode}",
                            style: TextStyle(
                                fontStyle: widget.bottle.country == null
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
                          const Text("Région"),
                          const Spacer(),
                          Text(
                            (widget.bottle.area == null || widget.bottle.area!.isEmpty)
                                ? "Non renseignée"
                                : "${widget.bottle.area}",
                            style: TextStyle(
                                fontStyle: (widget.bottle.area == null || widget.bottle.area!.isEmpty)
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
                          const Text("Sous-région"),
                          const Spacer(),
                          Text(
                            (widget.bottle.subArea == null || widget.bottle.subArea!.isEmpty)
                                ? "Non renseignée"
                                : "${widget.bottle.subArea}",
                            style: TextStyle(
                                fontStyle: (widget.bottle.subArea == null || widget.bottle.subArea!.isEmpty)
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
                  visible: widget.bottle.isOpen! || (widget.bottle.tastingNote != null && widget.bottle.tastingNote!.isNotEmpty),
                  child: const Text('DEGUSTATION')),
              Visibility(
                visible: widget.bottle.isOpen! || (widget.bottle.tastingNote != null && widget.bottle.tastingNote!.isNotEmpty),
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
                      (widget.bottle.tastingNote == null ||
                              widget.bottle.tastingNote!.isEmpty)
                          ? "Aucune note"
                          : widget.bottle.tastingNote!,
                      style: TextStyle(
                        fontStyle: (widget.bottle.tastingNote == null ||
                                widget.bottle.tastingNote!.isEmpty)
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
