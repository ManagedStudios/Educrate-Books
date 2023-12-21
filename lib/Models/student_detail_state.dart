

import 'dart:collection';



import 'package:buecherteam_2023_desktop/Data/book.dart';
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

  Stream<List<BookLite>> streamBooks (String? searchQuery) async* {
    String query = BuildQuery.buildStudentDetailBookAddQuery(searchQuery);

    yield* database.streamLiveDocs(query).asyncMap((change) {
      return change.results
          .asStream()
          .map((result) => database.toEntity(Book.fromJson, result))
          .map((book) => BookLite(book.id, book.name, book.subject, book.classLevel))
          .toList();
    });
  }

  Future<void> deleteBooksOfStudents(List<Student> students, List<BookLite> selectedBooks) async {
    for (Student student in students) {
      final doc = (await database.getDoc(student.id))!.toMutable();
      student.removeBooks(selectedBooks);
      student.decrementAmountOfBooks(selectedBooks.length);
      database.updateDocFromEntity(student, doc);
      database.saveDocument(doc);
    }
  }

  Future<void> duplicateBooksOfStudents(List<Student> students, List<BookLite> selectedBooks) async {
    addBooksToStudent(selectedBooks, students);
  }

  Future<void> addBooksToStudent(List<BookLite> books, List<Student> selectedStudents) async{
    for (Student student in selectedStudents) {
      final doc = (await database.getDoc(student.id))!.toMutable();
      student.addBooks(books);

      student.incrementAmountOfBooks(books.length);
      database.updateDocFromEntity(student, doc);
      database.saveDocument(doc);
    }
  }



}