bool isNumeric(String s) {
  // Use a regular expression to check if the string consists of digits only
  final numericRegExp = RegExp(r'^[0-9]+$');
  return numericRegExp.hasMatch(s);
}

bool isOnlyWhitespace(String str) {
  final regex = RegExp(r'^\s*$');
  return regex.hasMatch(str);
}