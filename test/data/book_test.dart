

import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, Object?> validBookJson;
  late Map<String, Object?> missingFieldsBookJson;
  late Map<String, Object?> classLevelStringJson;
  late Map<String, Object?> bookStringJson;
  late Map<String, Object?> emptyJson;
  late Book validBook;

  setUp(() {
    validBook = Book(
        bookId: "12345",
        name: "Green Line New 5",
        subject: "Englisch",
        classLevel: 11,
        trainingDirection: ["BASIC-11"],
        expectedAmountNeeded: 50,
        nowAvailable: 10,
        totalAvailable: 60);

    validBookJson = {
      TextRes.idJson: validBook.id,
      TextRes.bookNameJson: validBook.name,
      TextRes.bookSubjectJson: validBook.subject,
      TextRes.bookClassLevelJson: validBook.classLevel,
      TextRes.bookTrainingDirectionJson: validBook.trainingDirection,
      TextRes.bookExpectedAmountNeededJson: validBook.expectedAmountNeeded,
      TextRes.bookNowAvailableJson: validBook.nowAvailable,
      TextRes.bookTotalAvailableJson: validBook.totalAvailable,
      TextRes.typeJson:TextRes.bookTypeJson
    };

    classLevelStringJson = {...validBookJson, TextRes.bookClassLevelJson: "${validBook.classLevel}"};

    missingFieldsBookJson = {...validBookJson};
    missingFieldsBookJson.remove(TextRes.bookNameJson);  // remove one field for this test

    bookStringJson = {...validBookJson, TextRes.bookTrainingDirectionJson: "BASIC-11"};

    emptyJson = {};
  });

  group("Test Book.fromJson()", () {

    test("Valid JSON to Book object", () {
      final bookFromJson = Book.fromJson(validBookJson);
      expect(bookFromJson, validBook);  // assuming you have equality operator implemented in Book class
    });

    test("Class Level as String but convertible", () {
      final bookFromJson = Book.fromJson(classLevelStringJson);
      expect(bookFromJson, validBook);
    });

    test("Incomplete JSON throws exception", () {
      expect(() => Book.fromJson(missingFieldsBookJson), throwsA((e) => e.toString() == "Exception: Incomplete JSON"));
    });

    test("Empty JSON throws exception", () {
      expect(() => Book.fromJson(emptyJson), throwsA((e) => e.toString() == "Exception: Incomplete JSON"));
    });

    // Add more tests as needed, for instance for negative numbers, invalid strings, etc.

    // Negative numbers
    test("Negative classLevel throws exception", () {
      final invalidJson = {...validBookJson, TextRes.bookClassLevelJson: -1};
      expect(() => Book.fromJson(invalidJson), throwsA(isA<Exception>())); // Assuming you're validating values in the constructor or fromJson method
    });

    test("Negative expectedAmountNeeded throws exception", () {
      final invalidJson = {...validBookJson, TextRes.bookExpectedAmountNeededJson: -5};
      expect(() => Book.fromJson(invalidJson), throwsA(isA<Exception>()));
    });

    // ... similarly for other integer fields


    test("Invalid type for bookId throws exception", () {
      final invalidJson = {...validBookJson, TextRes.idJson: 12345};  // passing an integer instead of a string
      expect(() => Book.fromJson(invalidJson), throwsA(isA<TypeError>())); // This should throw a type error when trying to cast
    });

    // Invalid JSON structure for complex fields
    test("Invalid JSON structure for nested JSON throws exception", () {
      final invalidJson = {...validBookJson, TextRes.bookTotalAvailableJson: "invalidValue"};
      expect(() => Book.fromJson(invalidJson), throwsA(isA<FormatException>()));
    });

    test("Only a String not a List was passed for TrainingDirections", () {
      final bookFromJson = Book.fromJson(bookStringJson);
      expect(bookFromJson, validBook);
    });

  });

  group("Test Book.toJson()", ()
  {
    // Basic test
    test("Valid Book object to JSON", () {
      final json = validBook.toJson();
      expect(json,
          validBookJson); // Directly compare the generated JSON to the expected JSON
    });

    // Test for each field
    test("Check bookId in JSON", () {
      final json = validBook.toJson();
      expect(json[TextRes.idJson], validBook.id);
    });

    test("Check name in JSON", () {
      final json = validBook.toJson();
      expect(json[TextRes.bookNameJson], validBook.name);
    });

    test("Check subject in JSON", () {
      final json = validBook.toJson();
      expect(json[TextRes.bookSubjectJson], validBook.subject);
    });

  });

  // You can add more groups for other methods of the Book class if needed.
}
