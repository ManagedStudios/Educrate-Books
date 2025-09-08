import 'dart:async';
import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/buildQuery.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:buecherteam_2023_desktop/Util/database/update.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';

import '../Data/bookLite.dart';

class StudentListState extends ChangeNotifier {
  StudentListState(this.database);

  final DB database;

  SplayTreeSet<int> selectedStudentIds =
      SplayTreeSet(); //always ordered hashset

  List<Student> _students = [];

  // Expose the current list of students
  List<Student> get students => _students;

  String? ftsQuery;
  Filter? filterOptions;

  /*
  saveStudent saves completely new Students
   */
  Future<String> saveStudent(String firstName, String lastName, int classLevel,
      String classChar, List<String> trainingDirections,
      {required Function(List<BookLite>? books, Student student)
          onAddBooksToStudent,
      List<BookLite>? books,
      List<String>? tags}) async {
    final document = createNewStudentDoc(
        firstName, lastName, classLevel, classChar, trainingDirections,
        books: [], //don't add books here since this way book amounts will not be updated
        tags: tags);
    await database.saveDocument(document);
    if (books == null) {
      //if no books were given add books according to trainingDirection
      onAddBooksToStudent(
          (await getBooksFromTrainingDirections(trainingDirections)),
          database.toEntity(Student.fromJson, document));
    } else {
      //if books were given add them

      onAddBooksToStudent(books, database.toEntity(Student.fromJson, document));
    }

    return document.id;
  }

  /*
  createNewStudentDoc creates the appropriate document for the saveStudent method
  the arguments are validated in the Stateful form widget
   */
  MutableDocument createNewStudentDoc(String firstName, String lastName,
      int classLevel, String classChar, List<String> trainingDirections,
      {List<BookLite>? books, List<String>? tags}) {
    final document =
        MutableDocument(); //create empty MutableDocument to retrieve students id
    final student = Student(document.id,
        firstName: firstName,
        lastName: lastName,
        classLevel: classLevel,
        classChar: classChar,
        trainingDirections: trainingDirections,
        books: books ?? [],
        amountOfBooks: books?.length ?? 0,
        tags: tags ?? []);
    database.updateDocFromEntity(student, document);
    return document;
  }

  /*
  streamStudents creates a stream with all the students that should be retrieved based
  on the searchbar text (ftsQuery) and the applied Filters(filterOptions). The stream
  yields live data - so when on an other device a student is created the student will
  immediately appear in the stream, if the student is included by ftsQuery and filterOptions
   */
  Stream<List<Student>> streamStudents(
      String? ftsQuery, Filter? filterOptions) async* {
    String query = BuildQuery.buildStudentListQuery(ftsQuery, filterOptions);

    // The stream from your database
    final sourceStream = database.streamLiveDocs(query);

    // We yield a modified stream
    yield* sourceStream.asyncMap((change) async { // Make this closure async

      // await the Future<List<Student>> from toList()
      final List<Student> studentList = await change.results.asStream().map((result) {
        return database.toEntity(Student.fromJson, result);
      }).toList();


      // 3. CAPTURE the result before returning it.
      _students = studentList;

      // 4. NOTIFY any listening widgets that the data has changed.
      // This is crucial for the DetailPage to get updates.
      notifyListeners();


      // Finally, return the list to the original consumer (your StreamBuilder)
      return studentList;
    });
  }

  Future<String> updateStudent(Student newStudent) async {
    final doc = (await database.getDoc(newStudent.id))!.toMutable();
    database.updateDocFromEntity(newStudent, doc);
    database.saveDocument(doc);
    return doc.id;
  }

  Future<List<ClassData>> getAllClasses() async {
    String query = BuildQuery.getAllClassesQuery();
    final res = await database.getDocs(query);
    return res
        .asStream()
        .map((result) => database.toEntity(ClassData.fromJson, result))
        .toList();
  }

  Future<List<TrainingDirectionsData>> getAllTrainingDirections() async {
    return getAllTrainingDirectionsUtil(database);
  }

  Future<void> deleteStudent(Student student) async {
    final doc = await database.getDoc(student.id);
    if (doc != null) {
      database.deleteDoc(doc);
      updateBookAmountOnStudentsDeletedUtil([student], database);
    }
  }

  void setFtsQuery(String query) {
    ftsQuery = query;
    //important since this mistake has been done: streamStudents only opens a new stream with
    //new data using the state management system (provider or flutter setState)
    // calling the streamStudents method with the updated parameters here wont work!!
  }

  void setFilterOptions(Filter filter) {
    filterOptions = filter;
  }

  void clearSelectedStudents() {
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

  /*
  Method to retrieve all books of given trainingDirections
   */
  Future<List<BookLite>?> getBooksFromTrainingDirections(
      List<String> trainingDirections) async {
    List<BookLite>? books =
          await getBooksFromTrainingDirectionsUtil(trainingDirections, database);
    return books;
  }
}
