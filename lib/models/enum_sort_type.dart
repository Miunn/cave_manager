enum SortType {
  ascending,
  descending,
  none;

  SortType next() {
    switch (this) {
      case SortType.ascending:
        return SortType.descending;
      case SortType.descending:
        return SortType.none;
      case SortType.none:
        return SortType.ascending;
      default:
        return SortType.none;
    }
  }
}