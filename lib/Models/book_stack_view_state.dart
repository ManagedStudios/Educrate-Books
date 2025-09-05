
import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:flutter/material.dart';

import '../Data/db.dart';
import '../Data/student.dart';

class BookStateViewState extends ChangeNotifier {

  BookStateViewState(this.database);

  final DB database;

  Map<BookLite, int> bookToAmount = {};
  ClassData? selectedClass;

  Future<List<ClassData>?> getClasses () async{
    return getAllClasses(database);
  }

  Future<Map<BookLite, int>> getAmountOfBooksFor(ClassData classData) async {
    List<Student> students = await getStudentsOfClass(
        database, classData.classLevel, classData.classChar);

    Map<BookLite, int> res = {};

    for (Student student in students) {
      for (BookLite book in student.books) {
        res[book] = (res[book] ?? 0) + 1;
      }
    }

    // 1. Get the map's entries and convert to a list
    var sortedEntries = res.entries.toList();

    // 2. Sort the list by value (the count) in descending order
    sortedEntries.sort((a, b) {
      // Primary sort: by count, descending
      int compare = b.value.compareTo(a.value);
      // Secondary sort (tie-breaker): by book name, ascending
      if (compare == 0) {
        return a.key.name.compareTo(b.key.name);
      }
      return compare;
    });

    // 3. Create a new LinkedHashMap that respects the sorted order
    final sortedMap = Map.fromEntries(sortedEntries);

    return sortedMap;
  }

  Future<void> selectClass(ClassData classData) async{
    bookToAmount = await getAmountOfBooksFor(classData);
    selectedClass = classData;
    notifyListeners();
  }

}