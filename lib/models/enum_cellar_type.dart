enum CellarType {
  holder('Porte Bouteilles', 'wineRack'),
  bags('Contenants', 'containers'),
  fridge('Frigo', 'fridge'),
  none('None', 'none');

  const CellarType(this.label, this.value);
  final String label;
  final String value;
}