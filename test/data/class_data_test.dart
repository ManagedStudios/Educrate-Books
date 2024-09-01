

import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {


  group("Test Hashcode", () {

    test("Duplicates", () {
      ClassData classData = ClassData(10, "K");

      HashSet<ClassData> cls = HashSet();
      cls.add(classData);
      expect(cls.length, 1);
      cls.add(classData);
      expect(cls.length, 1);

    });

    test("Duplicates and Singles", () {
      ClassData classData = ClassData(10, "K");
      ClassData classData1 = ClassData(8, "L");
      ClassData classData2 = ClassData(12, "");

      HashSet<ClassData> cls = HashSet();
      cls.add(classData);
      expect(cls.length, 1);
      cls.add(classData1);
      expect(cls.length, 2);
      cls.add(classData1);
      expect(cls.length, 2);
      cls.add(classData2);
      expect(cls.length, 3);
      cls.add(classData1);
      expect(cls.length, 3);

    });

  });

}