
import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:cbl_dart/cbl_dart.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
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

  setUpAll(() async{
    await CouchbaseLiteDart.init(edition: Edition.community);
  });

  setUp(() {
    student1 = Student("jfiwoejfoiwjeiof", firstName: "Dibbo-Mrinmoy",
        lastName: "Saha", classLevel: 11, classChar: "Q",
        trainingDirections: ["BASIC-11, ETH-LAT-11"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11),
          BookLite("321", "Lambacher Schweizer", "Mather", 11)]);
    student2 = Student("fiweohfoiwf", firstName: "Arda",
        lastName: "Stigler", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10, ETH-LAT-10, KUNST-10"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)]);
    studentWithoutTraining = Student("fhuiwewfpihu", firstName: "Thomas",
        lastName: "Arbogast", classLevel: 10, classChar: "K",
        trainingDirections: [],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)]);
    studentWithoutBooks = Student("flkajdwjqod", firstName: "Elias",
        lastName: "Kandemir", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10, ETH-LAT-10, KUNST-10"],
        books: []);

    validJson1 = {
      'id': student1.id,
      'firstName': student1.firstName,
      'lastName': student1.lastName,
      'classLevel': student1.classLevel,
      'classChar': student1.classChar,
      'trainingDirections': student1.trainingDirections,
      'books': [
        student1.books[0].toJson(),
        student1.books[1].toJson()
      ]
    };
    validJson2 = {
      'id': student2.id,
      'firstName': student2.firstName,
      'lastName': student2.lastName,
      'classLevel': student2.classLevel,
      'classChar': student2.classChar,
      'trainingDirections': student2.trainingDirections,
      'books': [
        student2.books[0].toJson()
      ]
    };

    classLevelStringJson = {
      'id': student1.id,
      'firstName': student1.firstName,
      'lastName': student1.lastName,
      'classLevel': "${student1.classLevel}",
      'classChar': student1.classChar,
      'trainingDirections': student1.trainingDirections,
      'books': [
        student1.books[0].toJson(),
        student1.books[1].toJson()
      ]
    };

    noBooksJson = {
      'id': studentWithoutBooks.id,
      'firstName': studentWithoutBooks.firstName,
      'lastName': studentWithoutBooks.lastName,
      'classLevel': studentWithoutBooks.classLevel,
      'classChar': studentWithoutBooks.classChar,
      'trainingDirections': studentWithoutBooks.trainingDirections,
      'books': []
    };

    wrongBooksJson = {
      'id': student2.id,
      'firstName': student2.firstName,
      'lastName': student2.lastName,
      'classLevel': student2.classLevel,
      'classChar': student2.classChar,
      'trainingDirections': student2.trainingDirections,
      'books': [
        {
          'id': '321',
          'name': 'Green Line New 4'
        }
      ]
    };

    trainingDirectionsEmpty = {
      'id': studentWithoutTraining.id,
      'firstName': studentWithoutTraining.firstName,
      'lastName': studentWithoutTraining.lastName,
      'classLevel': studentWithoutTraining.classLevel,
      'classChar': studentWithoutTraining.classChar,
      'trainingDirections': studentWithoutTraining.trainingDirections,
      'books': [
        studentWithoutTraining.books[0].toJson()
      ]
    };

    emptyJson = {};

    missingFields = {
      'firstName': studentWithoutTraining.firstName,
      'lastName': studentWithoutTraining.lastName,
      'classLevel': studentWithoutTraining.classLevel,
      'classChar': studentWithoutTraining.classChar,
      'trainingDirections': studentWithoutTraining.trainingDirections,
      'books': [
        studentWithoutTraining.books[0].toJson()
      ]
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
      final expectedJson = validJson1;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });

    test("Test student 2 to Json", () {
      final Map<String, Object?> json = student2.toJson();
      final expectedJson = validJson2;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });

    test("Test student withoutBooks to Json", () {
      final Map<String, Object?> json = studentWithoutBooks.toJson();
      final expectedJson = noBooksJson;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });

    test("Test student withoutTraining to Json", () {
      final Map<String, Object?> json = studentWithoutTraining.toJson();
      final expectedJson = trainingDirectionsEmpty;
      expect(areMapsEqualForStudents(json, expectedJson), true);
    });


  });
}