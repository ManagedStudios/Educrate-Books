
import 'dart:async';
import 'dart:collection';


import 'package:buecherteam_2023_desktop/Data/buildQuery.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';

import '../Data/bookLite.dart';


class StudentListState extends ChangeNotifier {



  StudentListState(this.database);

  final DB database;

  SplayTreeSet<int> selectedStudentIds = SplayTreeSet(); //always ordered hashset

  String? ftsQuery;
  Filter? filterOptions;

  /*
  saveStudent saves completely new Students
   */
  Future<String> saveStudent(String firstName, String lastName, int classLevel,
      String classChar, List<String> trainingDirections, {List<BookLite>? books, List<String>? tags}) async {
    final document = createNewStudentDoc(firstName, lastName, classLevel, classChar, trainingDirections, books: books, tags: tags);
    await database.saveDocument(document);
    return document.id;
  }

  /*
  createNewStudentDoc creates the appropriate document for the saveStudent method
  the arguments are validated in the Stateful form widget
   */
  MutableDocument createNewStudentDoc (String firstName, String lastName, int classLevel,
      String classChar, List<String> trainingDirections, {List<BookLite>? books, List<String>? tags}) {
    final document = MutableDocument(); //create empty MutableDocument to retrieve students id
    final student = Student(document.id, firstName: firstName, lastName: lastName,
        classLevel: classLevel, classChar: classChar,
        trainingDirections: trainingDirections, books: books??[], amountOfBooks: books?.length??0,
        tags: tags??[]);
    database.updateDocFromEntity(student, document);
    return document;
  }

  /*
  streamStudents creates a stream with all the students that should be retrieved based
  on the searchbar text (ftsQuery) and the applied Filters(filterOptions). The stream
  yields live data - so when on an other device a student is created the student will
  immediately appear in the stream, if the student is included by ftsQuery and filterOptions
   */
  Stream<List<Student>> streamStudents (String? ftsQuery, Filter? filterOptions) async* {
      String query = BuildQuery.buildStudentListQuery(ftsQuery, filterOptions);

      yield* database.streamLiveDocs(query).asyncMap((change) { //asyncMap required as the data is asynchronously fetched from the Web
        return change.results
            .asStream()
            .map((result) => database.toEntity(Student.fromJson, result)) //build Student objects from JSON
            .toList();
      });
  }

  Future<String> updateStudent(Student newStudent) async{
    final doc = (await database.getDoc(newStudent.id))!.toMutable();
    database.updateDocFromEntity(newStudent, doc);
    database.saveDocument(doc);
    return doc.id;
  }

  Future<List<ClassData>> getAllClasses () async{

    String query = BuildQuery.getAllClassesQuery();
    final res = await database.getDocs(query);
    return res
    .asStream()
    .map((result) => database.toEntity(ClassData.fromJson, result))
    .toList();
  }

  Future<List<TrainingDirectionsData>> getAllTrainingDirections () async{
    String query = BuildQuery.getAllTrainingDirections();
    final res = await database.getDocs(query);
    return res
        .asStream()
        .map((result) => database.toEntity(TrainingDirectionsData.fromJson, result))
        .toList();
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

  void clearSelectedStudents () {
    selectedStudentIds = SplayTreeSet();
    notifyListeners();
  }


  void addSelectedStudent(int studentIndex) {
    selectedStudentIds.add(studentIndex);
    notifyListeners();
  }

  void removeSelectedStudent(int index) {
    selectedStudentIds.remove(index);
    notifyListeners();
  }


}

