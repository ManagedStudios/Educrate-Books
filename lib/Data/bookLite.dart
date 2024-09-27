/*
BookLite provides a lightweight version of the book class that is meant to be used in UI.
This class is especially handy due to our storage-mechanism of books associated with a student;
Books are stored in a dictionary of the student and can then be easily transformed to BookLite objects.
 */

import '../Resources/text.dart';

class BookLite implements Comparable {
  BookLite(this._bookId, this.name, this.subject, this.classLevel,
      {this.satzNummer});

  final String
      _bookId; //bookId is retrieved from the book-class collection saved in db
  final String name;
  final String subject;
  final int classLevel;
  int? satzNummer; //indicates how often one student owns one book of the same type

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
      int? satz;
      if (data[TextRes.bookSatzNummerJson] != null) {
        satz = data[TextRes.bookSatzNummerJson] is int
            ? data[TextRes.bookSatzNummerJson] as int
            : int.parse(data[
              TextRes.bookSatzNummerJson]);
      }
      result = BookLite(
          data[TextRes.bookIdJson] as String,
          data[TextRes.bookNameJson] as String,
          data[TextRes.bookSubjectJson] as String,
          data[TextRes.studentClassLevelJson] is int
              ? data[TextRes.studentClassLevelJson] as int
              : int.parse(data[
                  TextRes.studentClassLevelJson]),//handle stringified ints
          satzNummer: satz);
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
    if (satzNummer != null) {
      data[TextRes.bookSatzNummerJson] = satzNummer!;
    }
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
    // First, compare by classLevel
    int classLevelComparison = classLevel.compareTo(other.classLevel);
    if (classLevelComparison != 0) {
      return classLevelComparison;
    }

    // If classLevels are equal, compare by subject
    int subjectComparison = subject.compareTo(other.subject);
    if (subjectComparison != 0) {
      return subjectComparison;
    }

    // If subjects are equal, compare by name
    int nameComparison = name.compareTo(other.name);
    if (nameComparison != 0) {
      return nameComparison;
    }

    // If names are also equal, compare by satzNummer
    // Treat null as lower than any integer
    if (satzNummer == null && other.satzNummer == null) {
      return 0;
    } else if (satzNummer == null) {
      return -1;
    } else if (other.satzNummer == null) {
      return 1;
    } else {
      return satzNummer!.compareTo(other.satzNummer!);
    }
  }
}
