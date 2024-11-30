

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:cbl_dart/cbl_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunction extends Mock {
  void onRemoveBook(BookLite book);
}
void main () {
  late MockFunction mockFunction;
  late Student student1;
  late Student student2;
  late Student studentWithoutTraining;
  late Student studentWithoutBooks;
  late Map<String, Object?> validJson1;
  late Map<String, Object?> validJson2;
  late Map<String, Object?> classLevelStringJson;
  late Map<String, Object?> noBooksJson;
  late Map<String, Object?> wrongBooksJson;
  late Map<String, Object?> trainingDirectionsEmpty;
  late Map<String, Object?> emptyJson;
  late Map<String, Object?> missingFields;
  late BookLite book1;
  late BookLite book2;
  late BookLite book3;
  late BookLite book4;


  setUpAll(() async{
    await CouchbaseLiteDart.init(edition: Edition.community);
  });

  setUp(() {
    mockFunction = MockFunction();
    student1 = Student("jfiwoejfoiwjeiof", firstName: "Dibbo-Mrinmoy",
        lastName: "Saha", classLevel: 11, classChar: "Q",
        trainingDirections: ["BASIC-11, ETH-LAT-11"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11),
          BookLite("321", "Lambacher Schweizer", "Mather", 11)], amountOfBooks: 0, tags: []);
    student2 = Student("fiweohfoiwf", firstName: "Arda",
        lastName: "Stigler", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10, ETH-LAT-10, KUNST-10"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)], amountOfBooks: 0, tags: []);
    studentWithoutTraining = Student("fhuiwewfpihu", firstName: "Thomas",
        lastName: "Arbogast", classLevel: 10, classChar: "K",
        trainingDirections: [],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)], amountOfBooks: 0, tags: []);
    studentWithoutBooks = Student("flkajdwjqod", firstName: "Elias",
        lastName: "Kandemir", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10, ETH-LAT-10, KUNST-10"],
        books: [], amountOfBooks: 0, tags: []);
    book1 = BookLite("456", "Lambacher", "Mathe 8", 8);
    book2 = BookLite("555", "Green Line New 4", "Englisch", 10);
    book3 = BookLite("666", "Kollegstufe", "Ethik", 11);
    book4 = BookLite("777", "Hallo", "Neu", 10);


    validJson1 = {
      TextRes.studentIdJson: student1.id,
      TextRes.studentFirstNameJson: student1.firstName,
      TextRes.studentLastNameJson: student1.lastName,
      TextRes.studentClassLevelJson: student1.classLevel,
      TextRes.studentClassCharJson: student1.classChar,
      TextRes.studentTrainingDirectionsJson: student1.trainingDirections,
      TextRes.studentBooksJson: [
        student1.books[0].toJson(),
        student1.books[1].toJson()
      ],
      TextRes.studentAmountOfBooksJson:student1.amountOfBooks,
      TextRes.studentTagsJson:student1.tags
    };
    validJson2 = {
      TextRes.studentIdJson: student2.id,
      TextRes.studentFirstNameJson: student2.firstName,
      TextRes.studentLastNameJson: student2.lastName,
      TextRes.studentClassLevelJson: student2.classLevel,
      TextRes.studentClassCharJson: student2.classChar,
      TextRes.studentTrainingDirectionsJson: student2.trainingDirections,
      TextRes.studentBooksJson: [
        student2.books[0].toJson()
      ],
      TextRes.studentAmountOfBooksJson:student2.amountOfBooks,
      TextRes.studentTagsJson:student2.tags
    };

    classLevelStringJson = {
      TextRes.studentIdJson: student1.id,
      TextRes.studentFirstNameJson: student1.firstName,
      TextRes.studentLastNameJson: student1.lastName,
      TextRes.studentClassLevelJson: "${student1.classLevel}",
      TextRes.studentClassCharJson: student1.classChar,
      TextRes.studentTrainingDirectionsJson: student1.trainingDirections,
      TextRes.studentBooksJson: [
        student1.books[0].toJson(),
        student1.books[1].toJson()
      ],
      TextRes.studentAmountOfBooksJson:student1.amountOfBooks,
      TextRes.studentTagsJson:student1.tags
    };

    noBooksJson = {
      TextRes.studentIdJson: studentWithoutBooks.id,
      TextRes.studentFirstNameJson: studentWithoutBooks.firstName,
      TextRes.studentLastNameJson: studentWithoutBooks.lastName,
      TextRes.studentClassLevelJson: studentWithoutBooks.classLevel,
      TextRes.studentClassCharJson: studentWithoutBooks.classChar,
      TextRes.studentTrainingDirectionsJson: studentWithoutBooks.trainingDirections,
      TextRes.studentBooksJson: [],
      TextRes.studentAmountOfBooksJson:studentWithoutBooks.amountOfBooks,
      TextRes.studentTagsJson:studentWithoutBooks.tags
    };

    wrongBooksJson = {
      TextRes.studentIdJson: student2.id,
      TextRes.studentFirstNameJson: student2.firstName,
      TextRes.studentLastNameJson: student2.lastName,
      TextRes.studentClassLevelJson: student2.classLevel,
      TextRes.studentClassCharJson: student2.classChar,
      TextRes.studentTrainingDirectionsJson: student2.trainingDirections,
      TextRes.studentBooksJson: [
        {
          TextRes.studentIdJson: '321',
          TextRes.bookNameJson: 'Green Line New 4'
        }
      ],
      TextRes.studentAmountOfBooksJson:student2.amountOfBooks,
      TextRes.studentTagsJson:student2.tags
    };

    trainingDirectionsEmpty = {
      TextRes.studentIdJson: studentWithoutTraining.id,
      TextRes.studentFirstNameJson: studentWithoutTraining.firstName,
      TextRes.studentLastNameJson: studentWithoutTraining.lastName,
      TextRes.studentClassLevelJson: studentWithoutTraining.classLevel,
      TextRes.studentClassCharJson: studentWithoutTraining.classChar,
      TextRes.studentTrainingDirectionsJson: studentWithoutTraining.trainingDirections,
      TextRes.studentBooksJson: [
        studentWithoutTraining.books[0].toJson()
      ],
      TextRes.studentAmountOfBooksJson:studentWithoutTraining.amountOfBooks,
      TextRes.studentTagsJson:studentWithoutTraining.tags
    };

    emptyJson = {};

    missingFields = {
      TextRes.studentFirstNameJson: studentWithoutTraining.firstName,
      TextRes.studentLastNameJson: studentWithoutTraining.lastName,
      TextRes.studentClassLevelJson: studentWithoutTraining.classLevel,
      TextRes.studentClassCharJson: studentWithoutTraining.classChar,
      TextRes.studentTrainingDirectionsJson: studentWithoutTraining.trainingDirections,
      TextRes.studentBooksJson: [
        studentWithoutTraining.books[0].toJson()
      ],
      TextRes.studentAmountOfBooksJson:studentWithoutTraining.amountOfBooks,
      TextRes.studentTagsJson:studentWithoutTraining.tags
    };
  });

  group("Test serialization of student Json", () {

    test("valid json to student object 1", () {
      final jsonRes = Student.fromJson(validJson1);
      expect(jsonRes.equals(student1), true);
    });

    test("valid json to student object 2", () {
      final jsonRes = Student.fromJson(validJson2);
      expect(jsonRes.equals(student2), true);
    });

    test("valid json to student object 2 - negative test", () {
      final jsonRes = Student.fromJson(validJson2);
      expect(jsonRes.equals(student1), false);
    });

    test("classLevel as String but convertible", () {
      final jsonRes = Student.fromJson(classLevelStringJson);
      expect(jsonRes.equals(student1), true);
    });

    test("valid json: student without books", () {
      final jsonRes = Student.fromJson(noBooksJson);
      expect(jsonRes.equals(studentWithoutBooks), true);
    });

    test("valid json: student without trainingDirections", () {
      final jsonRes = Student.fromJson(trainingDirectionsEmpty);
      expect(jsonRes.equals(studentWithoutTraining), true);
    });

    test("wrong books throw exception", () {
      expect(() => Student.fromJson(wrongBooksJson), throwsException);
    });

    test("wrong books throw exception", () {
      expect(() => Student.fromJson(emptyJson), throwsA((e) => e.toString() == "Exception: Incomplete JSON"));
    });

    test("wrong books throw exception", () {
      expect(() => Student.fromJson(missingFields), throwsA((e) => e.toString() == "Exception: Incomplete JSON"));
    });

  });

  group("Test JSON deserialization", () {

    test("Test student 1 to Json", () {
      final Map<String, Object?> json = student1.toJson();
      json.remove(TextRes.typeJson);
      final expectedJson = validJson1;
      final res = areMapsEqualForStudents(json, expectedJson);
      expect(res, true);
    });

    test("Test student 2 to Json", () {
      final Map<String, Object?> json = student2.toJson();
      json.remove(TextRes.typeJson);
      final expectedJson = validJson2;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });

    test("Test student withoutBooks to Json", () {
      final Map<String, Object?> json = studentWithoutBooks.toJson();
      json.remove(TextRes.typeJson);
      final expectedJson = noBooksJson;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });

    test("Test student withoutTraining to Json", () {
      final Map<String, Object?> json = studentWithoutTraining.toJson();
      json.remove(TextRes.typeJson);
      final expectedJson = trainingDirectionsEmpty;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });

    test ("Test adding books", () {
      studentWithoutBooks.addBooks([book1, book2]);
      expect(studentWithoutBooks.books, [book1, book2]);
    });

    test("Test adding books of same type", () {
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1]);
      expect(studentWithoutBooks.books.map((e) => e.name), [
        book1.name, book1.name
      ]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer), [
        null, 2
      ]);
    });

    test("Test adding books of same and different types", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1, book3]);
      expect(studentWithoutBooks.books.map((e) => e.name), [
        book1.name, book2.name, book1.name, book3.name
      ]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer), [
        null, null, 2, null
      ]);
    });

    test("Test removing books basic", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([book1], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books, [book2]);
    });
    test("Test removing multiple books of different type", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([book1, book2], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books, []);
    });

    test("Test removing book when multiple of the same type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.removeBooks([book1], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name), [book1.name, book2.name]);
    });

    test("Test removing book when multiple of the same and different type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([book1], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name, book2.name, book1.name, book2.name]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer),
          [null, null, 2, 2]);
    });

    test("Test removing multiple books when multiple of the same and different type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([book1, book2], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name, book2.name, book1.name]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer),
          [null, null, 2]);
      verify(() => mockFunction.onRemoveBook(book1)).called(1);
      verify(() => mockFunction.onRemoveBook(book2)).called(1);
    });

    test("Test removing multiple books of different satz when multiple of the same and different type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, book1.name, book1.subject, book1.classLevel, satzNummer: 2),
        book2], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name, book2.name, book1.name]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer),
          [null, null, 2]);
      verify(() => mockFunction.onRemoveBook(book1)).called(1);
      verify(() => mockFunction.onRemoveBook(book2)).called(1);
    });

    test("Test removing multiple same books when multiple of the same and different type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, book1.name, book1.subject, book1.classLevel, satzNummer: 2),
        book1], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name, book2.name, book2.name]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer),
          [null, null, 2]);
      verify(() => mockFunction.onRemoveBook(book1)).called(2);
    });

    test("Test removing multiple same and different books when multiple of the same and different type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, book1.name, book1.subject, book1.classLevel, satzNummer: 2),
        book1, book2], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name, book2.name]);
      expect(studentWithoutBooks.books.map((e) => e.satzNummer),
          [null, null]);
      verify(() => mockFunction.onRemoveBook(book1)).called(2);
      verify(() => mockFunction.onRemoveBook(book2)).called(1);
    });

    test("Test removing multiple same and different books when multiple of the same and different type are available", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, "${book1.name} 2. Satz", book1.subject, book1.classLevel),
        book1, book2, book2], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name]);
      verify(() => mockFunction.onRemoveBook(book1)).called(2);
      verify(() => mockFunction.onRemoveBook(book2)).called(2);
    });
    test("Test removing books until empty", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, book1.name, book1.subject, book1.classLevel, satzNummer: 2),
        book1, book2, book2, book1], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          []);
      verify(() => mockFunction.onRemoveBook(book1)).called(3);
      verify(() => mockFunction.onRemoveBook(book2)).called(2);
    });
    test("Test removing books until empty in chunks", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, book1.name, book1.subject, book1.classLevel, satzNummer: 2),
        book1], (book) => mockFunction.onRemoveBook(book));
      studentWithoutBooks.removeBooks([book2, book2, book1], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          []);
      verify(() => mockFunction.onRemoveBook(book1)).called(3);
      verify(() => mockFunction.onRemoveBook(book2)).called(2);
    });

    test("Test removing book that does not exist", () {
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.addBooks([book1]);
      studentWithoutBooks.addBooks([book1, book2]);
      studentWithoutBooks.removeBooks([
        BookLite(book1.bookId, "${book1.name} 2. Satz", book1.subject, book1.classLevel),
        book1], (book) => mockFunction.onRemoveBook(book));
      studentWithoutBooks.removeBooks([book2, book2, book4], (book) => mockFunction.onRemoveBook(book));
      expect(studentWithoutBooks.books.map((e) => e.name),
          [book1.name]);
      verify(() => mockFunction.onRemoveBook(book1)).called(2);
      verify(() => mockFunction.onRemoveBook(book2)).called(2);
      verifyNever(() => mockFunction.onRemoveBook(book4));
    });

  });
}