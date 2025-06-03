

import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/import_add_missing_classes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group("Test GetMissingClassesFrom method", () {


    test("Test if uniqueClasses is a superset of availableClasses", () {
      List<ClassData> availableClasses = [
        ClassData(5, "A"),
        ClassData(6, "B"),
        ClassData(7, "C")
      ];
      List<ClassData> classesToBeAdded = [
        ClassData(10, "K"),
        ClassData(8, "A"),
        ClassData(9, "B"),
        ClassData(7, "A")
      ];
      HashSet<ClassData> uniqueClasses = HashSet.from(availableClasses);
      uniqueClasses.addAll(classesToBeAdded);

      expect(areListsEqualIgnoringOrder(
          getMissingClassesFrom(uniqueClasses, availableClasses),
          classesToBeAdded
      ), true);

    });


    test("Test if uniqueClasses is a subset of availableClasses", () {
      List<ClassData> availableClasses = [
        ClassData(5, "A"),
        ClassData(6, "B"),
        ClassData(7, "C")
      ];

      HashSet<ClassData> uniqueClasses = HashSet.from(availableClasses.sublist(0, 1));

      expect(areListsEqualIgnoringOrder(
          getMissingClassesFrom(uniqueClasses, availableClasses),
          []
      ), true);

    });

    test("Test if availableClasse is null", () {
      List<ClassData>? availableClasses;
      List<ClassData> classesToBeAdded = [
        ClassData(10, "K"),
        ClassData(8, "A"),
        ClassData(9, "B"),
        ClassData(7, "A")
      ];

      HashSet<ClassData> uniqueClasses = HashSet.from(classesToBeAdded);

      expect(areListsEqualIgnoringOrder(
          getMissingClassesFrom(uniqueClasses, availableClasses),
          classesToBeAdded
      ), true);

    });

    test("Test if availableClasse is empty", () {
      List<ClassData> availableClasses = [];
      List<ClassData> classesToBeAdded = [
        ClassData(10, "K"),
        ClassData(8, "A"),
        ClassData(9, "B"),
        ClassData(7, "A")
      ];

      HashSet<ClassData> uniqueClasses = HashSet.from(classesToBeAdded);

      expect(areListsEqualIgnoringOrder(
          getMissingClassesFrom(uniqueClasses, availableClasses),
          classesToBeAdded
      ), true);

    });

  });

}