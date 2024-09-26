

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

//update the amount of a list of books where some are of same type
//as multiple books at the same time are updated negative Amounts are enabled
//since you will not know which book causes negative Amounts on an easy way
Future<void> updateBookAmountOnBooksAddedUtil(
    List<BookLite> books, DB database) async {
  Map<String, int> bookIdByAmount = {};

  for (BookLite bookLite in books) {
    bookIdByAmount[bookLite.bookId] =
        (bookIdByAmount[bookLite.bookId] ?? 0) + 1;
  }

  for (MapEntry<String, int> bookByAmount in bookIdByAmount.entries) {
    await BookUtils.updateAmountOnBookToStudentAdded(
        bookByAmount.key, bookByAmount.value, database,
        allowNegativeBookAmount: true);
  }
}


