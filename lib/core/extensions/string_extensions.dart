extension StringExtensions on String {
  bool get isNullOrWhiteSpace => trim().isEmpty;

  bool get isNotNullOrWhiteSpace => trim().isNotEmpty;
}
