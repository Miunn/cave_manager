import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegionsByCountry {
  RegionsByCountry(this.context);

  final BuildContext context;

  static RegionsByCountry? of(BuildContext context) {
    return RegionsByCountry(context);
  }

  List<String> regionsByCountry(String country) {
    return [];/*: [
      'Algiers'
    ],
    'France': [
      'Alsace',
      'Beaujolais',
      'Bordeaux',
      'Bourgogne',
      'Champagne',
      'Corse',
      'Jura',
      'Languedoc-Roussillon',
      'Loire',
      'Provence',
      'Savoie',
      'Sud-Ouest',
      'Vallée du Rhône',
    ],
    'Nigeria': [
      'Abia',
      'Adamawa',
      'Akwa Ibom',
      'Anambra',
      'Bauchi',
      'Bayelsa',
    ]*/
  }
}