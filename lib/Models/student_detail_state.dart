

import 'dart:collection';


import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:flutter/material.dart';

import '../Data/bookLite.dart';

class StudentDetailState extends ChangeNotifier {

  HashSet<Student> selectedStudentIdObjects = HashSet(); //currSelectStudents - updated by all_students_column


  void clearSelectedStudents  () {
    selectedStudentIdObjects = HashSet();

  }

  void addSelectedStudent(Student student) {
    selectedStudentIdObjects.add(student);

  }

  void removeSelectedStudent(Student student) {
    selectedStudentIdObjects.remove(student);

  }


  Stream<List<Student>> streamStudentsDetails (List<String>? studentIds) async*{

    yield [
      Student("123",
          firstName: "Dibbo",
          lastName: "Saha",
          classLevel: 10,
          classChar: "K",
          trainingDirections: ["BASIC-10"],
          books: [
            BookLite("444", "Green Line New 5", "Englisch", 10),
            BookLite("444", "Green Line New 5", "Englisch", 10),
          ], amountOfBooks: 1,
          tags: [])
    ];
  }

  Future<void> deleteBooksOfStudents(List<Student> students, List<BookLite> selectedBooks) async {}

  Future<void> duplicateBooksOfStudents(List<Student> students, List<BookLite> selectedBooks) async {}



}