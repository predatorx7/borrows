class StringUtils {
  static String toFirstLetterUppercase(String word) {
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }

  /// Returns the value of enum
  static String fromEnum(Object enumEntry) {
    final String description = enumEntry.toString();
    final int indexOfDot = description.indexOf('.');
    assert(indexOfDot != -1 && indexOfDot < description.length - 1);
    return description.substring(indexOfDot + 1);
  }
}
