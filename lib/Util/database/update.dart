

import '../../Data/bookLite.dart';
import '../../Data/db.dart';
import '../../Data/student.dart';
import '../../Models/book_utils.dart';

Future<void> updateBookAmountOnStudentsDeletedUtil (List<Student> students, DB database) async {
  Map<String, int> bookIdByAmount = {};

  for (Student student in students) {
    for (BookLite bookLite in student.books) {
      bookIdByAmount[bookLite.bookId] =
          (bookIdByAmount[bookLite.bookId] ?? 0) + 1;
    }
  }

  for (MapEntry<String, int> bookByAmount in bookIdByAmount.entries) {
    await BookUtils.updateAmountOnBookFromStudentDeleted(
        bookByAmount.key, bookByAmount.value, database);
  }
}