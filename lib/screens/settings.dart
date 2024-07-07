import 'package:cave_manager/models/enum_themes.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/screens/settings/cellar.dart';
import 'package:cave_manager/widgets/cellar_filling_short.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.title});

  final String title;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Country appLocale = Country.parse('fr');
  Country defaultCountry = Country.parse('fr');
  AppTheme appTheme = AppTheme.system;

  @override
  void initState() {
    super.initState();
    getState();
  }

  getState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      appLocale = Country.parse(prefs.getString('appLocale') ?? 'fr');
      defaultCountry = Country.parse(prefs.getString('defaultCountry') ?? 'fr');
      appTheme = AppTheme.fromValue(prefs.getString('appTheme') ?? 'system');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<BottlesProvider>(
              builder: (BuildContext context, BottlesProvider bottles, Widget? child) =>
                CellarFillingShort(
                  bottleAmount: bottles.closedBottles.length,
                  text: AppLocalizations.of(context)!.bottlesCellar(bottles.closedBottles.length),
                )
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(AppLocalizations.of(context)!.languageDescription),
                  trailing: Text(appLocale.name),
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) async {
                        final prefs = await SharedPreferences.getInstance();
                        setState(() {
                          prefs.setString('appLocale', country.countryCode);
                          appLocale = country;
                        });
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(AppLocalizations.of(context)!.defaultCountry),
                  subtitle: Text(AppLocalizations.of(context)!.defaultCountryDescription),
                  trailing: Text(defaultCountry.name),
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) async {
                        final prefs = await SharedPreferences.getInstance();
                        setState(() {
                          prefs.setString('defaultCountry', country.countryCode);
                          defaultCountry = country;
                        });
                      },
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    debugPrint("Tap Apparence");
                  },
                  child: ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: Text(AppLocalizations.of(context)!.appearance),
                    subtitle: Text(AppLocalizations.of(context)!.appearanceDescription),
                    trailing: Text(appTheme.label),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsCellar(),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.storefront),
                    title: Text(AppLocalizations.of(context)!.cellar),
                    subtitle: Text(AppLocalizations.of(context)!.cellarDescription),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
