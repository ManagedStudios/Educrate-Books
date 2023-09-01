
import 'dart:collection';


import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';


class StudentListState extends ChangeNotifier {

  StudentListState(this.database);

  final DB database;

  HashSet<String> selectedStudentIds = HashSet();

  /*
  saveStudent to save completely new Students
   */
  Future<void> saveStudent(String firstName, String lastName, int classLevel,
      String classChar, List<String> trainingDirections) async {
    final document = MutableDocument(); //create empty MutableDocument to retrieve students id
    final student = Student(document.id, firstName: firstName, lastName: lastName,
        classLevel: classLevel, classChar: classChar,
        trainingDirections: trainingDirections, books: []);
    database.updateDocFromEntity(student, document);
    await database.saveDocument(document);
  }

  Stream<List<Student>> streamStudents (String? ftsQuery, Filter? filterOptions) async*{
      String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson} FROM _""";

      //TODO add the functionality to build the query
  }




}

