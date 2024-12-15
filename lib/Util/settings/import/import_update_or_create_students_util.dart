import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:cbl/cbl.dart';

import '../../../Data/db.dart';
import '../../../Data/student.dart';

Future<List<MutableDocument>> getUpdatedOrCreatedStudents
    (List<MutableDocument> studentGroupedRowsToBeImported,
    Map<String, Student> studentFirstLastNameExistingStudents,
    DB database) async{

  List<MutableDocument> res = [];
  //1. Loop over the new information
  Map<String, List<BookLite>?> trainingDirectionToBooks = {};

  for (MutableDocument studentDoc in studentGroupedRowsToBeImported) {
    Student? existingStudent = studentFirstLastNameExistingStudents[
      "${studentDoc.string(TextRes.studentFirstNameJson)}"
        "${studentDoc.string(TextRes.studentLastNameJson)}"];

      final newInfoStudent = database.toEntity(Student.fromJson, studentDoc);
      List<BookLite> booksToAdd = [];
      for (String trainingDirection in newInfoStudent.trainingDirections) {
        //cache the books belonging to a trainingDirection
        trainingDirectionToBooks[trainingDirection] ??=
          await getBooksFromTrainingDirectionsUtil([trainingDirection], database);
        booksToAdd.addAll(trainingDirectionToBooks[trainingDirection]!);
      }
    MutableDocument updatedDoc = MutableDocument();
    if (existingStudent != null) { //student does exist, so update
      //add the new Books for a trainingDirection
      existingStudent.addBooks(booksToAdd);

      //update other attributes
      existingStudent.addTrainingDirections(newInfoStudent.trainingDirections);
      existingStudent.addTags(newInfoStudent.tags);

      updatedDoc = MutableDocument.withId(existingStudent.id);
      database.updateDocFromEntity(existingStudent, updatedDoc);
    } else { //student does not exist, so create new one with books added
      Student newStudent = database.toEntity(Student.fromJson, studentDoc);
      newStudent.addBooks(booksToAdd);
      database.updateDocFromEntity(newStudent, updatedDoc);
    }
    res.add(updatedDoc);
  }

  return res;

}

