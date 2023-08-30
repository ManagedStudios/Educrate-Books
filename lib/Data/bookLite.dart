
/*
BookLite provides a lightweight version of the book class that is meant to be used in UI.
This class is especially handy due to our storage-mechanism of books associated with a student;
Books are stored in a dictionary of the student and can then be easily transformed to BookLite objects.
 */

class BookLite {

  BookLite(this._bookId, this.name, this.subject, this.classLevel);

  final String _bookId;
  final String name;
  final String subject;
  final int classLevel;

  String get bookId => _bookId;

}