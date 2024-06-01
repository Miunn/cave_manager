enum WineColors {
  red('Rouge', 'red'),
  pink('Rosé', 'pink'),
  white('Blanc', 'white'),
  other('Autre', 'other');

  const WineColors(this.label, this.value);
  final String label;
  final String value;
}