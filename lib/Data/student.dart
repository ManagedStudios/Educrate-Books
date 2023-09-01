


import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:flutter/foundation.dart';

import 'bookLite.dart';

class Student {

  Student(this._id, {required this.firstName, required this.lastName, required this.classLevel, required this.classChar, required this.trainingDirections, required this.books});

  final String _id; //make id private
  final String firstName;
  final String lastName;
  final int classLevel;
  final String classChar;
  final List<String> trainingDirections;
  final List<BookLite> books;
  String get id => _id;

  factory Student.fromJson(Map<String, Object?> json) {
    if(json['id'] == null||
    json['firstName'] == null||
    json['lastName'] == null||
   json['classLevel'] == null||
    json['classChar'] == null||
    json['trainingDirections'] == null||
    json['books'] == null) {
      throw Exception("Incomplete JSON");
    }
    return Student(
      json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      classLevel: json['classLevel'] is int ? json['classLevel'] as int : int.parse(json['classLevel'] as String),
      classChar: json['classChar'] as String,
      trainingDirections: List.from(json['trainingDirections'] as dynamic),
      books: List.from(json['books'] as dynamic).map((bookData) => BookLite.fromJson(bookData)).toList()
    );
  }

  Map<String, Object?> toJson() {
    final data = {'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'classLevel': classLevel,
      'classChar': classChar,
      'trainingDirections': trainingDirections,
      'books': books.isEmpty ? [] : books.map((book) => book.toJson())
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
