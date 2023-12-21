


import 'package:buecherteam_2023_desktop/Data/selectableItem.dart';

import '../Resources/text.dart';
import 'bookLite.dart';

class Student implements SelectableItem {

  Student(this._id, {required this.firstName, required this.lastName, required this.classLevel, required this.classChar, required this.trainingDirections, required this.books, required this.amountOfBooks, required this.tags});

  final String _id; //make id private
  final String firstName;
  final String lastName;
  final int classLevel;
  final String classChar;
  final List<String> trainingDirections;
  final List<BookLite> books;
  int amountOfBooks;
  final List<String> tags;
  String get id => _id;


  factory Student.fromJson(Map<String, Object?> json) {
    if(json[TextRes.studentIdJson] == null||
    json[TextRes.studentFirstNameJson] == null||
    json[TextRes.studentLastNameJson] == null||
    json[TextRes.studentClassLevelJson] == null||
    json[TextRes.studentClassCharJson] == null||
    json[TextRes.studentTrainingDirectionsJson] == null||
    json[TextRes.studentBooksJson] == null ||
    json[TextRes.studentAmountOfBooksJson] == null ||
    json[TextRes.studentTagsJson] == null) {
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
      amountOfBooks: json[TextRes.studentAmountOfBooksJson] is int ? json[TextRes.studentAmountOfBooksJson] as int : int.parse(json[TextRes.studentAmountOfBooksJson] as String),
      tags: List.from(json[TextRes.studentTagsJson] as dynamic)
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
      TextRes.studentAmountOfBooksJson: amountOfBooks,
      TextRes.studentTagsJson:tags,
      TextRes.typeJson:TextRes.studentTypeJson,
    };
    return data;
}

void addBooks(List<BookLite> books) {
    this.books.addAll(books);
}

void incrementAmountOfBooks (int amount) {
    amountOfBooks+=amount;
}

void removeBooks (List<BookLite> books) {
    for (BookLite book in books) {
      int index = this.books.indexOf(book);
      if (index != -1) {
        this.books.removeAt(index);
      }
    }
}

void decrementAmountOfBooks (int amount) {
    amountOfBooks-=amount;
}



@override
bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    return other is Student && id==other.id;
  }



  bool equals (Student other) {
    return id==other.id;
  }

  @override
  int get hashCode {
    return _id.hashCode;
  }

  @override
  List<String> getAttributes() {
    return [
      TextRes.studentIdJson,
      TextRes.studentTagsJson,
      TextRes.studentBooksJson,
      TextRes.studentClassCharJson,
      TextRes.studentClassLevelJson,
      TextRes.studentLastNameJson,
      TextRes.studentTrainingDirectionsJson,
      TextRes.studentFirstNameJson,
      TextRes.studentAmountOfBooksJson
    ];
  }

  @override
  String getDocId() {
    return id;
  }

  @override
  String getType() {
    return TextRes.studentTypeJson;
  }

  @override
  bool isDeletable() {
    return true;
  }
}
