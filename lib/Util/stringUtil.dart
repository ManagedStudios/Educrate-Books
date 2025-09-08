
import '../Resources/text.dart';

bool isNumeric(String s) {
  // Use a regular expression to check if the string consists of digits only
  final numericRegExp = RegExp(r'^[0-9]+$');
  return numericRegExp.hasMatch(s);
}

bool isOnlyWhitespace(String str) {
  final regex = RegExp(r'^\s*$');
  return regex.hasMatch(str);
}

bool containsOnlyLetters(String input) {
  final RegExp regex = RegExp(r'^[a-zA-Z]+$');
  return regex.hasMatch(input);
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

bool isAlphaNumericalExtended(String input) {
  final regex = RegExp(r'[-–,;]'); // Add other characters inside the square brackets if needed
  return !regex.hasMatch(input);
}

String? getQueryFromSearchText (String text) {
  final searchText = text.trim().replaceAll("*", "");

  if (searchText.isEmpty) {
    return null;
  }

  // Regex to find class patterns like "5A", "10B", etc.
  // It captures the number part (\d+) and the character part ([A-Za-z]).
  final classRegex = RegExp(r'^(\d+)([A-Za-z])$');

  List<String> parts = searchText.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  List<String> queryConditions = [];

  for (final part in parts) {
    final classMatch = classRegex.firstMatch(part);
    if (classMatch != null) {
      // This part is a class identifier like "5A"
      final String level = classMatch.group(1)!; // The number part, e.g., "5"
      final String char = classMatch.group(2)!;  // The char part, e.g., "A"

      // Create a specific, grouped condition for the class
      queryConditions.add('(${TextRes.studentClassLevelJson}:${level} AND ${TextRes.studentClassCharJson}:${char})');
    } else {
      // This part is a name, tag, etc. Use a prefix search.
      queryConditions.add('${part}*');
    }
  }

  final query = queryConditions.join(' AND ');

  return query;
}