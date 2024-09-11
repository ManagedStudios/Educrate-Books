import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:cbl/cbl.dart';

import '../../../Data/db.dart';
import '../../../Data/student.dart';
import '../../../Models/book_utils.dart';

Future<void> addBooksTo(List<MutableDocument> importedStudents, DB database,
    {Map<String, List<BookLite>>? firstLastNameExistingStudents}) async{

  Map<String, List<MutableDocument>> trainingDirectionToStudents =
              groupStudentsAccordingToTrainingDirection(importedStudents, database);

  for (MapEntry<String, List<MutableDocument>> entry in
        trainingDirectionToStudents.entries) {

    List<BookLite>? booksToAdd =
          await getBooksFromTrainingDirectionsUtil([entry.key], database);

    for (MutableDocument studentDoc in entry.value) {
      Student student = database.toEntity(Student.fromJson, studentDoc);

      //add books of existing student
      if (firstLastNameExistingStudents != null &&
            firstLastNameExistingStudents
                .containsKey("${student.firstName}${student.lastName}")) {
                    booksToAdd ??= [];
                    booksToAdd.addAll(
                        firstLastNameExistingStudents["${student.firstName}${student.lastName}"]!
                    );
      }


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