import '../Data/bookLite.dart';
import '../Data/settings/excel_data.dart';
import '../Data/settings/student_excel_mapper_attributes.dart';
import '../Resources/text.dart';

bool areListsEqualIgnoringOrder<T>(List<T> list1, List<T> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  list1.sort();
  list2.sort();

  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }

  return true;
}

bool areMapsEqual(Map<String, Object?> map1, Map<String, Object?> map2) {
  if (map1.length != map2.length) {
    return false;
  }
  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) {
      return false;
    }
  }
  return true;
}

bool areImportMapsEqual (Map<StudentAttributes, List<ExcelData>> map1,
Map<StudentAttributes, List<ExcelData>> map2) {
  if (map1.length != map2.length) {
    return false;
  }

  for (MapEntry<StudentAttributes, List<ExcelData>> entry in map1.entries) {
    if (!map2.containsKey(entry.key)) {
      return false;
    } else {
      for (var excelData in map2[entry.key]!) {
        if (!entry.value.contains(excelData)) {
          return false;
        }
      }
    }
  }


  return true;
}

bool areBooksEqual(List<BookLite> list1, List<BookLite> list2) {
  if (list1.length != list2.length) {
    return false;
  }

  list1.sort();
  list2.sort();

  for (int i = 0; i < list1.length; i++) {
    if (!list1[i].equals(list2[i])) {
      return false;
    }
  }

  return true;
}

bool areMapsEqualForStudents(
    Map<String, Object?> map1, Map<String, Object?> map2) {
  if (map1.length != map2.length) {
    return false;
  }

  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) {
      if (key == TextRes.studentTrainingDirectionsJson &&
          areListsEqualIgnoringOrder(List.from(map1[key] as dynamic),
              List.from(map2[key] as dynamic))) {
        continue;
      }

      if (key == TextRes.studentBooksJson &&
          areBooksEqual(
              List.from(map1[key] as dynamic)
                  .map((e) => BookLite.fromJson(e))
                  .toList(),
              List.from(map2[key] as dynamic)
                  .map((e) => BookLite.fromJson(e))
                  .toList())) {
        continue;
      }
      return false;
    }
  }
  return true;
}
