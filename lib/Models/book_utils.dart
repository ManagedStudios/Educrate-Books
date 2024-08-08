/*
This Class provides helper functions for data manipulation of books.
These functions might be required in more than 1 model; this way code duplication
is avoided
 */

import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';



class BookUtils {

  static final BookUtils _instance = BookUtils._internal();

  factory BookUtils () {
    return _instance;
  }

  BookUtils._internal();

  static Future<void> updateAmountOnBookFromStudentDeleted (String bookId, int amount, DB database) async {
    final doc = (await database.getDoc(bookId))!.toMutable();
    Book dbBook = database.toEntity(Book.fromJson, doc);
    dbBook.updateBookAmountOnDeletes(amount);
    database.updateDocFromEntity(dbBook, doc);
    database.saveDocument(doc);
  }
  static Future<bool> updateAmountOnBookToStudentAdded (String bookId, int amount, DB database) async {
    final doc = (await database.getDoc(bookId))!.toMutable();
    Book dbBook = database.toEntity(Book.fromJson, doc);
    //update amount if enough books are available else quit by returning false
    if (dbBook.updateBookAmountOnAdds(amount)) {
      database.updateDocFromEntity(dbBook, doc);
      database.saveDocument(doc);
      return true;
    } else {
      return false;
    }

  }

}