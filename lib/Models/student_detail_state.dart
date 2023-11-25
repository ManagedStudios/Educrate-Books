

import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:flutter/material.dart';

class StudentDetailState extends ChangeNotifier {

  HashSet<Student> selectedStudentIdObjects = HashSet();


  void clearSelectedStudents  () {
    selectedStudentIdObjects = HashSet();
  }

  void addSelectedStudent(Student student) {
    selectedStudentIdObjects.add(student);
  }

  void removeSelectedStudent(Student student) {
    selectedStudentIdObjects.remove(student);
  }

}