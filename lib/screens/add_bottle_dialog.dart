import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cave_manager/models/cellar_type_enum.dart';
import 'package:cave_manager/screens/place_in_cellar.dart';
import 'package:cave_manager/screens/take_picture.dart';
import 'package:cave_manager/utils/bottle_db_interface.dart';
import 'package:cave_manager/utils/cellar_db_interface.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bottle.dart';
import '../models/cluster.dart';
import '../models/wine_colors_enum.dart';

class AddBottleDialog extends StatefulWidget {
  const AddBottleDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddBottleDialogState();
}

class _AddBottleDialogState extends State<AddBottleDialog> {
  CellarDatabaseInterface cellarDatabase = CellarDatabaseInterface.instance;
  BottleDatabaseInterface bottleDatabase = BottleDatabaseInterface.instance;

  late CameraDescription _camera;
  bool _save = false;

  final _formKey = GlobalKey<FormState>();
  CellarType cellarType = CellarType.none;
  List<CellarCluster> cellarConfiguration = [];
  String? bottleImageUri;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController signatureController = TextEditingController();
  final TextEditingController vintageYearController = TextEditingController();
  final TextEditingController alcoholLevelController = TextEditingController();

  Country? selectedCountry = CountryService().findByCode("fr");
  final TextEditingController areaController = TextEditingController();
  final TextEditingController subAreaController = TextEditingController();
  final TextEditingController grapeVarietyController = TextEditingController();

  WineColors selectedColor = WineColors.red;

  static const List<String> _areas = <String>[
    "Alsace/Moselle",
    "Beaujolais",
    "Bourgogne",
    "Bordeaux",
    "Corse",
    "Jura",
    "Languedoc Roussillon",
    "Sud Est",
    "Sud Ouest",
    "Vallée de la Loire",
  ];

  @override
  void initState() {
    getCam();
    loadCellar();
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

  Future<void> loadCellar() async {
    final prefs = await SharedPreferences.getInstance();

    List<CellarCluster> clusters = await cellarDatabase.getClusters();

    setState(() {
      cellarType = CellarType.values.firstWhere(
              (e) => e.value == prefs.getString("cellarType"),
          orElse: () => CellarType.none);
      cellarConfiguration = clusters;
    });
  }

  isCellarConfigured() {
    return cellarType != CellarType.none && cellarConfiguration.isNotEmpty;
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
    areaController.dispose();
    subAreaController.dispose();
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
        title: const Text("Nouvelle bouteille"),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 70),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                      label: Text(WineColors.red.label),
                      icon: const Icon(Icons.wine_bar),
                    ),
                    ButtonSegment<WineColors>(
                      value: WineColors.pink,
                      label: Text(WineColors.pink.label),
                      icon: const Icon(Icons.wine_bar),
                    ),
                    ButtonSegment<WineColors>(
                      value: WineColors.white,
                      label: Text(WineColors.white.label),
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
                  autofocus: true,
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
                  decoration: const InputDecoration(
                    labelText: 'Domaine',
                    border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          labelText: 'Millésime',
                          border: OutlineInputBorder(),
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
                        decoration: const InputDecoration(
                          labelText: 'Degré',
                          border: OutlineInputBorder(),
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
                      "Pays: ${selectedCountry?.flagEmoji} ${selectedCountry?.displayNameNoCountryCode}",
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
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _areas.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    debugPrint("Selected $selection");
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
                      decoration: const InputDecoration(
                        labelText: 'Région',
                        border: OutlineInputBorder(),
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
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _areas.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    debugPrint("Selected $selection");
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        labelText: 'Sous-région',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (String value) {
                        onFieldSubmitted();
                        debugPrint('You just typed a new entry  $value');
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: grapeVarietyController,
                  decoration: const InputDecoration(
                    labelText: 'Cépage',
                    border: OutlineInputBorder(),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: ElevatedButton(
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              if (!_formKey.currentState!.validate()) {
                return;
              }

              _save = true;

              Bottle bottle = Bottle(nameController.text, DateTime.now(), false,
                  imageUri: bottleImageUri,
                  color: selectedColor.value,
                  signature: signatureController.text,
                  vintageYear: int.tryParse(vintageYearController.text),
                  alcoholLevel: double.tryParse(alcoholLevelController.text),
                  country: selectedCountry?.countryCode,
                  area: areaController.text,
                  subArea: subAreaController.text,
                  grapeVariety: grapeVarietyController.text);
              if (!isCellarConfigured()) {
                Navigator.of(context).pop(bottle);
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
                  Navigator.of(context).pop(bottle);
                } else {
                  debugPrint("Context not mounted");
                }
              }
            },
            child: const Text('Placer dans la cave'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
