import 'package:collection/collection.dart';

enum Areas {
  alsace('Alsace', 'alsace'),
  beaujolais('Beaujolais', 'beaujolais'),
  bourgogne('Bourgogne', 'bourgogne'),
  bordelais('Bordelaise', 'bordelaise'),
  champagne('Champagne', 'champagne'),
  corse('Corse', 'corse'),
  jura('Jura', 'jura'),
  languedoc('Languedoc Roussillon', 'languedoc'),
  provence('Provence', 'provence'),
  sudEst('Sud Est', 'sudEst'),
  sudOuest('Sud Ouest', 'sudOuest'),
  loire('Vallée de la Loire', 'loire'),
  rhone('Vallée du Rhône', 'rhone'),
  midi('Midi', 'midi'),
  other('Autre', 'other');

  const Areas(this.label, this.value);
  final String label;
  final String value;

  static Areas? fromValue(String? value) {
    return Areas.values.firstWhereOrNull((area) => area.value == value);
  }

  static Areas? fromLabel(String? label) {
    return Areas.values.firstWhereOrNull((area) => area.label == label);
  }
}