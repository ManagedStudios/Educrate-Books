int roundUpDivision(int numerator, int denominator) {
  double result = numerator / denominator;
  return result.ceil();
}

String formatRange(List<int> numbers) {
  if (numbers.isEmpty) return "";

  // Sort the list just in case it's not sorted
  numbers.sort();

  List<String> parts = [];
  int start = numbers.first;
  int previous = start;

  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] == previous + 1) {
      previous = numbers[i];
    } else {
      parts.add(start == previous ? '$start' : '$start-$previous');
      start = numbers[i];
      previous = start;
    }
  }

  // Add the last part
  parts.add(start == previous ? '$start' : '$start-$previous');

  return parts.join(', ');
}
