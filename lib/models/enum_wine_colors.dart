enum WineColors {
  red('Rouge', 'red'),
  pink('Rosé', 'pink'),
  white('Blanc', 'white'),
  other('Autre', 'other');

  const WineColors(this.label, this.value);

  final String label;
  final String value;

  static WineColors fromValue(String value) {
    return WineColors.values.firstWhere((element) => element.value == value);
  }
}
