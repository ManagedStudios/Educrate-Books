
import 'dart:async';
import 'dart:collection';


import 'package:buecherteam_2023_desktop/Data/buildQuery.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';


class StudentListState extends ChangeNotifier {

  StudentListState(this.database);

  final DB database;

  HashSet<String> selectedStudentIds = HashSet();

  String? ftsQuery;
  Filter? filterOptions;

  /*
  saveStudent saves completely new Students
   */
  Future<void> saveStudent(String firstName, String lastName, int classLevel,
      String classChar, List<String> trainingDirections) async {
    final document = createNewStudentDoc(firstName, lastName, classLevel, classChar, trainingDirections);
    await database.saveDocument(document);
  }

  /*
  createNewStudentDoc creates the appropriate document for the saveStudent method
  the arguments are validated in the Stateful form widget
   */
  MutableDocument createNewStudentDoc (String firstName, String lastName, int classLevel,
      String classChar, List<String> trainingDirections) {
    final document = MutableDocument(); //create empty MutableDocument to retrieve students id
    final student = Student(document.id, firstName: firstName, lastName: lastName,
        classLevel: classLevel, classChar: classChar,
        trainingDirections: trainingDirections, books: [], amountOfBooks: 0);
    database.updateDocFromEntity(student, document);
    return document;
  }

  Stream<List<Student>> streamStudents (String? ftsQuery, Filter? filterOptions) async* {
      String query = BuildQuery.buildStudentListQuery(ftsQuery, filterOptions);

      yield* database.streamLiveDocs(query).asyncMap((change) {
        return change.results
            .asStream()
            .map((result) => database.toEntity(Student.fromJson, result))
            .toList();
      });
  }


  Future<void> deleteStudent (Student student) async{
    final doc = await database.getDoc(student.id);
    if (doc != null) database.deleteDoc(doc);
  }

  void setFtsQuery (String query) {
    ftsQuery = query;
    streamStudents(ftsQuery, filterOptions);
  }

  void setFilterOptions (Filter filter) {
    filterOptions = filter;
    streamStudents(ftsQuery, filterOptions);
  }



}

