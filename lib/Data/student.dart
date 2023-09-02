


import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:flutter/foundation.dart';

import '../Resources/text.dart';
import 'bookLite.dart';

class Student {

  Student(this._id, {required this.firstName, required this.lastName, required this.classLevel, required this.classChar, required this.trainingDirections, required this.books, required this.amountOfBooks});

  final String _id; //make id private
  final String firstName;
  final String lastName;
  final int classLevel;
  final String classChar;
  final List<String> trainingDirections;
  final List<BookLite> books;
  final int amountOfBooks;
  String get id => _id;

  factory Student.fromJson(Map<String, Object?> json) {
    if(json[TextRes.studentIdJson] == null||
    json[TextRes.studentFirstNameJson] == null||
    json[TextRes.studentLastNameJson] == null||
    json[TextRes.studentClassLevelJson] == null||
    json[TextRes.studentClassCharJson] == null||
    json[TextRes.studentTrainingDirectionsJson] == null||
    json[TextRes.studentBooksJson] == null ||
    json[TextRes.amountOfBooksJson] == null) {
      throw Exception("Incomplete JSON");
    }
    return Student(
      json[TextRes.studentIdJson] as String,
      firstName: json[TextRes.studentFirstNameJson] as String,
      lastName: json[TextRes.studentLastNameJson] as String,
      classLevel: json[TextRes.studentClassLevelJson] is int ? json[TextRes.studentClassLevelJson] as int : int.parse(json[TextRes.studentClassLevelJson] as String),
      classChar: json[TextRes.studentClassCharJson] as String,
      trainingDirections: List.from(json[TextRes.studentTrainingDirectionsJson] as dynamic),
      books: List.from(json[TextRes.studentBooksJson] as dynamic).map((bookData) => BookLite.fromJson(bookData)).toList(),
      amountOfBooks: json[TextRes.amountOfBooksJson] is int ? json[TextRes.amountOfBooksJson] as int : int.parse(json[TextRes.amountOfBooksJson] as String)
    );
  }

  Map<String, Object?> toJson() {
    final data = {TextRes.studentIdJson: id,
      TextRes.studentFirstNameJson: firstName,
      TextRes.studentLastNameJson: lastName,
      TextRes.studentClassLevelJson: classLevel,
      TextRes.studentClassCharJson: classChar,
      TextRes.studentTrainingDirectionsJson: trainingDirections,
      TextRes.studentBooksJson: books.isEmpty ? [] : books.map((book) => book.toJson()),
      TextRes.amountOfBooksJson: amountOfBooks,
      TextRes.typeJson:TextRes.studentTypeJson
    };
    return data;
}



  bool equals (Student other) {
    return id==other.id&&firstName==other.firstName&&lastName==other.lastName
        &&classLevel==other.classLevel&&classChar==other.classChar
        &&listEquals(trainingDirections, other.trainingDirections)
        &&areBooksEqual(books, other.books);
  }

}
