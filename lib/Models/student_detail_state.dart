

import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:flutter/material.dart';

class StudentDetailState extends ChangeNotifier {

  HashSet<Student> selectedStudents = HashSet();


  void clearSelectedStudents  () {
    selectedStudents = HashSet();
  }

  void addSelectedStudent(Student student) {
    selectedStudents.add(student);
  }

  void removeSelectedStudent(Student student) {
    selectedStudents.remove(student);
  }

}