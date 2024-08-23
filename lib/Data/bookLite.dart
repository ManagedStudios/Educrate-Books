/*
BookLite provides a lightweight version of the book class that is meant to be used in UI.
This class is especially handy due to our storage-mechanism of books associated with a student;
Books are stored in a dictionary of the student and can then be easily transformed to BookLite objects.
 */

import '../Resources/text.dart';

class BookLite implements Comparable {
  BookLite(this._bookId, this.name, this.subject, this.classLevel);

  final String
      _bookId; //bookId is retrieved from the book-class collection saved in db
  final String name;
  final String subject;
  final int classLevel;

  String get bookId => _bookId;

  factory BookLite.fromJson(Object json) {
    var data = json as dynamic;
    late BookLite result;
    //handle missing fields
    if (data[TextRes.bookIdJson] == null ||
        data[TextRes.bookNameJson] == null ||
        data[TextRes.bookSubjectJson] == null ||
        data[TextRes.studentClassLevelJson] == null) {
      throw Exception("Incomplete JSON");
    }

    try {
      result = BookLite(
          data[TextRes.bookIdJson] as String,
          data[TextRes.bookNameJson] as String,
          data[TextRes.bookSubjectJson] as String,
          data[TextRes.studentClassLevelJson] is int
              ? data[TextRes.studentClassLevelJson] as int
              : int.parse(data[
                  TextRes.studentClassLevelJson])); //handle stringified ints
    } on TypeError catch (e) {
      throw Exception(e.toString()); //handle wrong types
    }
    return result;
  }

  Map<String, Object?> toJson() {
    final data = {
      TextRes.bookIdJson: bookId,
      TextRes.bookNameJson: name,
      TextRes.bookSubjectJson: subject,
      TextRes.studentClassLevelJson: classLevel
    };
    return data;
  }

  bool equals(BookLite other) {
    return other.bookId == bookId;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    return other is BookLite && bookId == other.bookId;
  }

  @override
  int get hashCode => bookId.hashCode;

  @override
  int compareTo(other) {
    if (subject == other.subject && bookId != other.bookId) {
      return 1;
    } else {
      return subject.compareTo(other.subject);
    }
  }
}
