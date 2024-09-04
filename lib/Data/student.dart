import 'package:buecherteam_2023_desktop/Data/selectableItem.dart';

import '../Resources/text.dart';
import 'bookLite.dart';

class Student implements SelectableItem {
  Student(this._id,
      {required this.firstName,
      required this.lastName,
      required this.classLevel,
      required this.classChar,
      required this.trainingDirections,
      required this.books,
      required this.amountOfBooks,
      required this.tags});

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
    if (json[TextRes.studentIdJson] == null ||
        json[TextRes.studentFirstNameJson] == null ||
        json[TextRes.studentLastNameJson] == null ||
        json[TextRes.studentClassLevelJson] == null ||
        json[TextRes.studentClassCharJson] == null ||
        json[TextRes.studentTrainingDirectionsJson] == null ||
        json[TextRes.studentBooksJson] == null ||
        json[TextRes.studentAmountOfBooksJson] == null ||
        json[TextRes.studentTagsJson] == null) {
      throw Exception("Incomplete JSON");
    }
    return Student(json[TextRes.studentIdJson] as String,
        firstName: json[TextRes.studentFirstNameJson] as String,
        lastName: json[TextRes.studentLastNameJson] as String,
        classLevel: json[TextRes.studentClassLevelJson] is int
            ? json[TextRes.studentClassLevelJson] as int
            : int.parse(json[TextRes.studentClassLevelJson] as String),
        classChar: json[TextRes.studentClassCharJson] as String,
        trainingDirections:
            List.from(json[TextRes.studentTrainingDirectionsJson] as dynamic),
        books: List.from(json[TextRes.studentBooksJson] as dynamic)
            .map((bookData) => BookLite.fromJson(bookData))
            .toList(),
        amountOfBooks: json[TextRes.studentAmountOfBooksJson] is int
            ? json[TextRes.studentAmountOfBooksJson] as int
            : int.parse(json[TextRes.studentAmountOfBooksJson] as String),
        tags: List.from(json[TextRes.studentTagsJson] as dynamic));
  }

  Map<String, Object?> toJson() {
    final data = {
      TextRes.studentIdJson: id,
      TextRes.studentFirstNameJson: firstName,
      TextRes.studentLastNameJson: lastName,
      TextRes.studentClassLevelJson: classLevel,
      TextRes.studentClassCharJson: classChar,
      TextRes.studentTrainingDirectionsJson: trainingDirections,
      TextRes.studentBooksJson:
          books.isEmpty ? [] : books.map((book) => book.toJson()),
      TextRes.studentAmountOfBooksJson: amountOfBooks,
      TextRes.studentTagsJson: tags,
      TextRes.typeJson: TextRes.studentTypeJson,
    };
    return data;
  }

  void addBooks(List<BookLite> books) {
    Map<BookLite, int> countMap = {};
    int uniqueBooks = books.toSet().length;
    for (BookLite book in this.books) {
      //count already owned book types
      countMap[book] = (countMap[book] ?? 0) + 1;
    }
    for (BookLite book in books) {
      if (countMap[book] != null) {
        //book to be added already owned by student -> Update name of book
        final updatedBook = BookLite(
            book.bookId,
            "${book.name} ${countMap[book]! + 1}${TextRes.bookSet}",
            book.subject,
            book.classLevel);
        this.books.add(updatedBook);
      } else {
        //if book is newly added, just go ahead
        this.books.add(book);
      }
      //update the map along the adds if books of the same type are added multiple times
      if (uniqueBooks != books.length) countMap[book] = (countMap[book] ?? 0) + 1;
    }
  }

  int extractNumberBeforeDot(String input) {
    final regex = RegExp(r'(\d+)\.');
    final match = regex.firstMatch(input);
    if (match != null) {
      return int.parse(
          match.group(1)!); // Convert the matched string to an integer
    }
    return 1; // must be 1 else because it is the 1. Satz of the book
  }

  /*
  Method to remove books
  Always removes at first the books of higher "Satz" number and then gradually
  the lower ones to ensure data consistency across all students

  Ensure that the book amounts are updated correctly by the caller!!!
  (Updating happens not here because of performance reasons -> calculate
  the amount updated upfront, especially beneficial when you delete books of
  multiple students)
   */
  void removeBooks(List<BookLite> books, Function(BookLite) onRemoveBook) {
    Map<String, int> highestNumberBooks = {};
    List<String> bookIds = books.map((book) => book.bookId).toList();
    Map<String, int> bookIdByAmount = {};
    //create a map bookId and the corresponding amount
    for (String id in bookIds) {
      bookIdByAmount[id] = (bookIdByAmount[id] ?? 0) + 1;
    }
    //create a map of bookIds that are matched with the highest "satz" number the student owns
    for (BookLite book in this.books) {
      if (bookIds.contains(book.bookId)) {
        final number = extractNumberBeforeDot(book.name);
        if (!highestNumberBooks.containsKey(book.bookId) ||
            number > highestNumberBooks[book.bookId]!) {
          highestNumberBooks[book.bookId] = number;
        }
      }
    }

    //remove the books
    this.books.removeWhere((book) {
      if (bookIds.contains(book
              .bookId) //check first if bookId and "satz"-number is in correct range
          &&
          extractNumberBeforeDot(book.name) >
              highestNumberBooks[book.bookId]! - bookIdByAmount[book.bookId]! &&
          extractNumberBeforeDot(book.name) <=
              highestNumberBooks[book.bookId]!) {
        onRemoveBook(book);
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    return other is Student && id == other.id;
  }

  bool equals(Student other) {
    return id == other.id;
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
