enum Areas {
  alsace('Alsace', 'alsace'),
  champagne('Champagne', 'champagne'),
  bourgogne('Bourgogne', 'bourgogne'),
  bordelais('Bordelaise', 'bordelaise'),
  loire('Vallée de la Loire', 'loire'),
  rhone('Vallée du Rhône', 'rhone'),
  midi('Midi', 'midi'),
  corse('Corse', 'corse'),
  other('Autre', 'other');

  const Areas(this.label, this.value);
  final String label;
  final String value;
}