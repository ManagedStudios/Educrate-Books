
/*
BookLite provides a lightweight version of the book class that is meant to be used in UI.
This class is especially handy due to our storage-mechanism of books associated with a student;
Books are stored in a dictionary of the student and can then be easily transformed to BookLite objects.
 */




class BookLite implements Comparable<BookLite>{

  BookLite(this._bookId, this.name, this.subject, this.classLevel);

  final String _bookId;
  final String name;
  final String subject;
  final int classLevel;

  String get bookId => _bookId;

  factory BookLite.fromJson (Object json) {
    var data = json as dynamic;
    late BookLite result;
    //handle missing fields
    if(data['bookId'] == null || data['name'] == null ||
    data['subject'] == null || data['classLevel'] == null) {
      throw Exception("Incomplete JSON");
    }

    try {
       result = BookLite(data['bookId'] as String, data['name'] as String,
          data['subject'] as String, data['classLevel'] is int
               ? data['classLevel'] as int
               : int.parse(data['classLevel'])); //handle stringified ints
    } on TypeError catch(e) {
      throw Exception(e.toString()); //handle wrong types
    }
    return result;
  }

  Map<String, Object?> toJson() {
    final data = {
      'bookId': bookId,
      'name': name,
      'subject': subject,
      'classLevel': classLevel
    };
    return data;
  }

  bool equals (BookLite other) {
    return other.classLevel==classLevel&&other.name==name&&other.subject==subject&&other.bookId==bookId;
  }

  @override
  int compareTo(other) {
    return subject.compareTo(other.subject);
  }

}