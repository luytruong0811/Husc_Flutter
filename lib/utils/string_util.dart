class StringUtil {
  static stringFromException(Exception exception) {
    return exception.toString().replaceFirst('Exception: ', '');
  }

  static doubleFromString(String value) {
    if (value.trim().isEmpty) {
      return 0.0;
    }
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }
}
