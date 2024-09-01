
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Util/parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {

  group("Test Class Parser", () {

    test("Usual Class", () {
      String cl = "10K";
      ClassData classData = parseStringToClass(cl);

      expect(classData, ClassData(10, "K"));
    });

    test("Another Usual Class", () {
      String cl = "5A";
      ClassData classData = parseStringToClass(cl);

      expect(classData, ClassData(5, "A"));
    });

    test("Lower to Upper", () {
      String cl = "7c";
      ClassData classData = parseStringToClass(cl);

      expect(classData, ClassData(7, "C"));
    });

    test("Only number", () {
      String cl = "12";
      ClassData classData = parseStringToClass(cl);

      expect(classData, ClassData(12, ''));
    });

  });

}