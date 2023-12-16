

import 'dart:collection';



import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:flutter/material.dart';

import '../Data/bookLite.dart';
import '../Data/buildQuery.dart';
import '../Data/db.dart';

class StudentDetailState extends ChangeNotifier {

  HashSet<Student> selectedStudentIdObjects = HashSet(); //currSelectStudents - updated by all_students_column

  StudentDetailState(this.database);

  final DB database;

  void clearSelectedStudents  () {
    selectedStudentIdObjects = HashSet();
    notifyListeners();
  }

  void addSelectedStudent(Student student) {
    selectedStudentIdObjects.add(student);
    notifyListeners();
  }

  void removeSelectedStudent(Student student) {
    selectedStudentIdObjects.remove(student);
    notifyListeners();
  }


  Stream<List<Student>> streamStudentsDetails (List<String> studentIds) async*{
    String query = BuildQuery.buildStudentDetailQuery(studentIds);

    yield* database.streamLiveDocs(query).asyncMap((change) { //asyncMap required as the data is asynchronously fetched from the Web
      return change.results
          .asStream()
          .map((result) => database.toEntity(Student.fromJson, result)) //build Student objects from JSON
          .toList();
    });
  }

  Future<void> deleteBooksOfStudents(List<Student> students, List<BookLite> selectedBooks) async {}

  Future<void> duplicateBooksOfStudents(List<Student> students, List<BookLite> selectedBooks) async {}



}