/// Adds [isNullOrEmpty] property to [String?]
extension NullOrEmpty on String? {
  /// Whether this string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
