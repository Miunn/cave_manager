enum CellarType {
  holder('Porte Bouteilles', 'holder'),
  bags('Contenants', 'bags'),
  fridge('Frigo', 'fridge'),
  none('None', 'none');

  const CellarType(this.label, this.value);
  final String label;
  final String value;
}