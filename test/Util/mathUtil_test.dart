import 'package:buecherteam_2023_desktop/Util/mathUtil.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  group("Test formatRange method", () {

    test("Usual classes list", () {
      final list = [5, 6, 7, 8, 9, 10, 11, 12, 13];
      expect(formatRange(list), "5-13");
    });

    test("With gaps classes list", () {
      final list = [5, 6, 7, 11, 12, 13];
      expect(formatRange(list), "5-7, 11-13");
    });

    test("With gaps and single class classes list", () {
      final list = [5, 6, 7, 9, 11, 12, 13];
      expect(formatRange(list), "5-7, 9, 11-13");
    });

    test("empty list", () {
      final List<int> list = [];
      expect(formatRange(list), "");
    });


  });
}