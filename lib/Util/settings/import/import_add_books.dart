import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:buecherteam_2023_desktop/Util/database/update.dart';
import 'package:cbl/cbl.dart';

import '../../../Data/db.dart';
import '../../../Data/student.dart';
import '../../../Models/book_utils.dart';

Future<void> addBooksTo(List<MutableDocument> importedStudents, DB database,
    {Map<String, List<BookLite>>? firstLastNameExistingStudents}) async{

  if (firstLastNameExistingStudents != null) {
    addBooksOfExistingStudentsTo(importedStudents, firstLastNameExistingStudents, database);
  }

  Map<String, List<MutableDocument>> trainingDirectionToStudents =
              groupStudentsAccordingToTrainingDirection(importedStudents, database);

  for (MapEntry<String, List<MutableDocument>> entry in
        trainingDirectionToStudents.entries) {

    List<BookLite>? booksToAdd =
          await getBooksFromTrainingDirectionsUtil([entry.key], database);

    for (MutableDocument studentDoc in entry.value) {
      Student student = database.toEntity(Student.fromJson, studentDoc);

      if (booksToAdd != null) student.addBooks(booksToAdd);
      database.updateDocFromEntity(student, studentDoc);

      await database.saveDocument(studentDoc);
    }

  if (booksToAdd != null) {
    for (BookLite bookLite in booksToAdd) {
      await BookUtils.updateAmountOnBookToStudentAdded(
          bookLite.bookId,
          entry.value.length,
          database,
          allowNegativeBookAmount: true);
    }
  }

  }

}

Future<void> addBooksOfExistingStudentsTo(
    List<MutableDocument> importedStudents, Map<String,
    List<BookLite>> firstLastNameExistingStudents, DB database) async{

  List<BookLite> booksAddedToStudents = [];

  for (MutableDocument studentDoc in importedStudents) {
    Student student = database.toEntity(Student.fromJson, studentDoc);
    //add books of existing student
      List<BookLite>? books =
          firstLastNameExistingStudents["${student.firstName}${student.lastName}"];
      if (books != null) {
        student.addBooks(books);
        booksAddedToStudents.addAll(books);
        database.updateDocFromEntity(student, studentDoc);
      }
  }

  await updateBookAmountOnBooksAddedUtil(booksAddedToStudents, database);

}

Map<String, List<MutableDocument>> groupStudentsAccordingToTrainingDirection
    (List<MutableDocument> importedStudents, DB database) {

  Map<String, List<MutableDocument>> res = {};

  for (MutableDocument studentDoc in importedStudents) {
    Student student = database.toEntity(Student.fromJson, studentDoc);
    for (String trainingDirection in student.trainingDirections) {
      res[trainingDirection] ??= <MutableDocument>[];
      res[trainingDirection]!.add(studentDoc);
    }
  }

  return res;
}