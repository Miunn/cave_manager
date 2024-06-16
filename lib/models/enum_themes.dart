enum AppTheme {
  light('Clair', 'light'),
  dark('Sombre', 'dark'),
  system('Système', 'system');

  const AppTheme(this.label, this.value);

  final String label;
  final String value;

  static AppTheme fromValue(String value) {
    return AppTheme.values.firstWhere((element) => element.value == value);
  }
}