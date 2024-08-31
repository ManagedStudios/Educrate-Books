
bool isNumeric(String s) {
  // Use a regular expression to check if the string consists of digits only
  final numericRegExp = RegExp(r'^[0-9]+$');
  return numericRegExp.hasMatch(s);
}

bool isOnlyWhitespace(String str) {
  final regex = RegExp(r'^\s*$');
  return regex.hasMatch(str);
}

bool containsNonAlphabetical(String input) {
  final regex = RegExp(r"[0-9,;.:?=)(/&%$§!*+#><]");

  return regex.hasMatch(input);
}

bool isClassValid(bool isClassWithoutCharAllowed, String input) {
  final regexWithLetters = RegExp(r'^\d+[a-zA-Z]+$');
  final regexNumericOnly = RegExp(r'^\d+$');

  if (isClassWithoutCharAllowed && regexNumericOnly.hasMatch(input.trim())) {
    return true;
  }

  return regexWithLetters.hasMatch(input.trim());
}

bool isTrainingDirectionValid(String input) {
  final regex = RegExp(r'[-–,;]'); // Add other characters inside the square brackets if needed
  return !regex.hasMatch(input);
}
