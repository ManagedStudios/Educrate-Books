import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Models/book_utils.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';

import '../Data/bookLite.dart';
import '../Data/buildQuery.dart';
import '../Data/db.dart';

class StudentDetailState extends ChangeNotifier {
  HashSet<Student> selectedStudentIdObjects =
      HashSet(); //currSelectStudents - updated by all_students_column

  StudentDetailState(this.database);

  final DB database;

  void clearSelectedStudents() {
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

  Stream<List<Student>> streamStudentsDetails(List<String> studentIds) async* {
    String query = BuildQuery.buildStudentDetailQuery(studentIds);

    yield* database.streamLiveDocs(query).asyncMap((change) {
      //asyncMap required as the data is asynchronously fetched from the Web
      return change.results
          .asStream()
          .map((result) => database.toEntity(
              Student.fromJson, result)) //build Student objects from JSON
          .toList();
    });
  }

  Stream<List<BookLite>> streamBooks(String? searchQuery) async* {
    String query = BuildQuery.buildStudentDetailBookAddQuery(searchQuery);


    yield* database.streamLiveDocs(query).asyncMap((change) {
      return change.results
          .asStream()
          .map((result) {

            return database.toEntity(Book.fromJson, result);
      } )
          .map((book) {
        return BookLite(book.id, book.name, book.subject, book.classLevel);
            }
              )
          .toList();
    });
  }

  Future<void> deleteBooksOfStudents(
      List<Student> students, List<BookLite> selectedBooks) async {

    final List<MutableDocument> docs = [];
    final List<Student> updatedStudentObjects = [];
    final Map<String, int> bookIdByAmountDeleted = {};

    // Iterate through each student to remove books and accumulate deletion counts
    for (Student student in students) {
      final doc = (await database.getDoc(student.id))!.toMutable();
      docs.add(doc);
      // Remove books from the student and accumulate deletion counts
      student.removeBooks(selectedBooks,
          (book) => bookIdByAmountDeleted[book.bookId] =
              (bookIdByAmountDeleted[book.bookId] ?? 0) + 1
      );
      updatedStudentObjects.add(student);
    }

    // Update the book amounts in the database based on the accumulated deletion counts
    for (MapEntry<String, int> bookIdByAmount in bookIdByAmountDeleted.entries) {
      BookUtils
          .updateAmountOnBookFromStudentDeleted(
          bookIdByAmount.key, bookIdByAmount.value, database);
    }

    // Batch update the student documents in the database
    database.changeDocsFromEntities(docs, updatedStudentObjects);
  }

  Future<void> duplicateBooksOfStudents(
      List<Student> students, List<BookLite> selectedBooks) async {
    await addBooksToStudent(selectedBooks, students);
  }

  Future<void> addBooksToStudent(
      //TODO BookUtils updateBookAmount
      List<BookLite> books, List<Student> selectedStudents) async {
    for (Student student in selectedStudents) {
      final doc = (await database.getDoc(student.id))!.toMutable();
      student.addBooks(books);

      database.updateDocFromEntity(student, doc);
      await database.saveDocument(doc);
    }
  }
}
