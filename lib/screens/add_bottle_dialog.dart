import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/screens/cellar/place_in_cellar.dart';
import 'package:cave_manager/screens/take_picture.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/area_enum.dart';
import '../models/bottle.dart';
import '../models/enum_wine_colors.dart';
import '../providers/bottles_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBottleDialog extends StatefulWidget {
  const AddBottleDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddBottleDialogState();
}

class _AddBottleDialogState extends State<AddBottleDialog> {
  late CameraDescription _camera;
  bool _save = false;

  final _formKey = GlobalKey<FormState>();
  String? bottleImageUri;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController signatureController = TextEditingController();
  final TextEditingController vintageYearController = TextEditingController();
  final TextEditingController alcoholLevelController = TextEditingController();

  Country? selectedCountry = CountryService().findByCode("fr");
  String? area;
  String? subArea;
  final TextEditingController grapeVarietyController = TextEditingController();

  WineColors selectedColor = WineColors.red;

  @override
  void initState() {
    getCam();
    super.initState();
  }

  saveImage(XFile image) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    await image.saveTo('$path/${image.name}');

    // Delete previous saved picture
    if (bottleImageUri != null) {
      await File(bottleImageUri!).delete();
    }

    setState(() {
      bottleImageUri = '$path/${image.name}';
    });
  }

  getCam() async {
    List<CameraDescription> cameras = await availableCameras();
    _camera = cameras.first;
  }

  saveBottle(BuildContext context, bool askForCellar) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Bottle bottle = Bottle(nameController.text, DateTime.now(), false,
        imageUri: bottleImageUri,
        color: selectedColor.value,
        signature: signatureController.text,
        vintageYear: int.tryParse(vintageYearController.text),
        alcoholLevel: double.tryParse(alcoholLevelController.text),
        country: selectedCountry?.countryCode,
        area: area,
        subArea: subArea,
        grapeVariety: grapeVarietyController.text);
    if (!context.read<ClustersProvider>().isCellarConfigured || !askForCellar) {
      context.read<BottlesProvider>().addBottle(bottle);
    } else {
      Bottle? bottlePosition = await Navigator.of(context).push(
        MaterialPageRoute<Bottle>(
          fullscreenDialog: true,
          builder: (context) => PlaceInCellar(bottle: bottle),
        ),
      );

      if (bottlePosition != null) {
        bottle = bottlePosition;
      }

      if (context.mounted) {
        await context.read<BottlesProvider>().addBottle(bottle);
      }
      setState(() {
        _save = true;
      });
    }
  }

  @override
  void dispose() {
    // Delete picture if no save
    if (bottleImageUri != null && !_save) {
      File(bottleImageUri!).delete();
    }

    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    signatureController.dispose();
    vintageYearController.dispose();
    alcoholLevelController.dispose();
    grapeVarietyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    registerNewPicture() async {
      XFile? capturedImage = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: _camera)),
      );

      if (capturedImage == null) {
        return;
      }

      saveImage(capturedImage);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newBottle),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 70),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: InkWell(
                    onTap: registerNewPicture,
                    child:
                        Stack(alignment: Alignment.topRight, children: <Widget>[
                      (bottleImageUri != null)
                          ? Image(
                              image: FileImage(File(bottleImageUri!)),
                              width: 140,
                              height: 140,
                            )
                          : const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                              child: Image(
                                image: AssetImage('assets/wine-bottle.png'),
                                width: 70,
                                height: 70,
                              )),
                      const Icon(Icons.camera_alt_outlined),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SegmentedButton(
                  segments: <ButtonSegment<WineColors>>[
                    ButtonSegment<WineColors>(
                      value: WineColors.red,
                      label: Text(AppLocalizations.of(context)!
                          .wineColors(WineColors.red.value)),
                      icon: const Icon(Icons.wine_bar),
                    ),
                    ButtonSegment<WineColors>(
                      value: WineColors.pink,
                      label: Text(AppLocalizations.of(context)!
                          .wineColors(WineColors.pink.value)),
                      icon: const Icon(Icons.wine_bar),
                    ),
                    ButtonSegment<WineColors>(
                      value: WineColors.white,
                      label: Text(AppLocalizations.of(context)!
                          .wineColors(WineColors.white.value)),
                      icon: const Icon(Icons.wine_bar),
                    ),
                  ],
                  selected: <WineColors>{selectedColor},
                  onSelectionChanged: (Set<WineColors> newSelection) {
                    setState(() {
                      selectedColor = newSelection.first;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: nameController,
                  /*autofocus: true,*/
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Appellation requise';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Appellation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: signatureController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.estate,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: vintageYearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.vintage,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: alcoholLevelController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.alcoholLevel,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country;
                        });
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                    padding: const EdgeInsets.fromLTRB(12.0, 20.5, 12.0, 20.5),
                    child: Text(
                      "${AppLocalizations.of(context)!.country}: ${selectedCountry?.flagEmoji} ${selectedCountry?.displayNameNoCountryCode}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    setState(() {
                      area = textEditingValue.text;
                    });

                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return Areas.values
                        .where((element) => element.label
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((e) => e.label);
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.region,
                        border: const OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    setState(() {
                      subArea = textEditingValue.text;
                    });

                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return Areas.values
                        .where((element) => element.label
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((e) => e.label);
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.subRegion,
                        border: const OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: grapeVarietyController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.grapeVariety,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Offstage(
            offstage: !context.read<ClustersProvider>().isCellarConfigured,
            child: FloatingActionButton.small(
              heroTag: 'save',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await saveBottle(context, false);
                }

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(Icons.save),
            ),
          ),
          const SizedBox(height: 24),
          FloatingActionButton.extended(
            heroTag: 'placeInCellar',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await saveBottle(context, context.read<ClustersProvider>().isCellarConfigured);
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: Icon((context.read<ClustersProvider>().isCellarConfigured) ? Icons.storefront : Icons.save),
            label: Text((context.read<ClustersProvider>().isCellarConfigured)
                ? AppLocalizations.of(context)!.placeInCellar
                : AppLocalizations.of(context)!.saveOutOfCellar
            ),
          ),
        ],
      ),
    );
  }
}
