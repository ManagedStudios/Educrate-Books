


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

}
