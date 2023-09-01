
import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:cbl_dart/cbl_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookLite extends Mock implements BookLite {}

void main () {
  late BookLite book1;
  late BookLite book2;
  
  late Object validJson1;
  late Object missingIdJson;
  late Object emptyJson;
  late Object missingNameJson;
  late Object missingIdNameJson;
  late Object wrongTypeName;
  late Object StringClassLevelType;
  late Object validJson2;

  setUpAll(() async{
    await CouchbaseLiteDart.init(edition: Edition.community);
  });
  
  setUp(() async{
      book1 = BookLite("1234-bookLite", "Green Line New 5", "Englisch", 10);
      book2 = BookLite("-H7oR-QBBOkFWAmRhvZUbYZ", "Lambacher Schweizer", "Mathe", 9);
      validJson1 = {TextRes.bookIdJson: book1.bookId, TextRes.bookNameJson: book1.name, TextRes.bookSubjectJson: book1.subject, TextRes.studentClassLevelJson: book1.classLevel};
      missingIdJson = {TextRes.bookNameJson: book1.name, TextRes.bookSubjectJson: book1.subject, TextRes.studentClassLevelJson: book1.classLevel};
      emptyJson = {};
      missingNameJson = {TextRes.bookIdJson: book1.bookId, TextRes.bookSubjectJson: book1.subject, TextRes.studentClassLevelJson: book1.classLevel};
      missingIdNameJson = {TextRes.bookSubjectJson: book1.subject, TextRes.studentClassLevelJson: book1.classLevel};
      wrongTypeName = {TextRes.bookIdJson: book1.bookId, TextRes.bookNameJson: 22, TextRes.bookSubjectJson: book1.subject, TextRes.studentClassLevelJson: book1.classLevel};
      StringClassLevelType = {TextRes.bookIdJson: book1.bookId, TextRes.bookNameJson: book1.name, TextRes.bookSubjectJson: book1.subject, TextRes.studentClassLevelJson: "${book1.classLevel}"};
      validJson2 = {TextRes.bookIdJson: book2.bookId, TextRes.bookSubjectJson: book2.subject, TextRes.bookNameJson: book2.name, TextRes.studentClassLevelJson: book2.classLevel};
  });

  group("Test the JSON serialization", () {
    test("test valid JSON to Book object", () {
      final BookLite bookObject = BookLite.fromJson(validJson1);
      expect(bookObject.equals(book1), true);
    });

    test("is able to detect incomplete JSON - missing id", () {
        expect(() => BookLite.fromJson(missingIdJson), throwsA((exception) => exception.toString()=="Exception: Incomplete JSON"));
    });

    test("is able to detect empty JSON as incomplete JSON ", () {
      expect(() => BookLite.fromJson(emptyJson), throwsA((exception) => exception.toString()=="Exception: Incomplete JSON"));
    });

    test("is able to detect incomplete JSON - missing name", () {
      expect(() => BookLite.fromJson(missingNameJson), throwsA((exception) => exception.toString()=="Exception: Incomplete JSON"));
    });

    test("is able to detect incomplete JSON - missing id and name", () {
      expect(() => BookLite.fromJson(missingIdNameJson), throwsA((exception) => exception.toString()=="Exception: Incomplete JSON"));
    });

    test("is able to deal with wrong types that can't be converted correctly", () {
      expect(() => BookLite.fromJson(wrongTypeName), throwsException);
    });

    test("is able to deal with wrong type of classLevel that can be converted", () {
      final bookObject = BookLite.fromJson(StringClassLevelType);
      expect(bookObject.equals(book1), true);
    });

    test("test valid JSON to Book object", () {
      final BookLite bookObject = BookLite.fromJson(validJson2);
      expect(bookObject.equals(book2), true);
    });

  });

  group("Test JSON deserialization", () {



    test("Test book 1 to Json", () {
      final json = book1.toJson();
      final expectedJson = validJson1 as Map<String, Object?>;
      expect(areMapsEqual(json, expectedJson), true);
    });
    test("Test book 2 to Json", () {
      final json = book2.toJson();
      final expectedJson = validJson2 as Map<String, Object?>;
      expect(areMapsEqual(json, expectedJson), true);
    });
  });


}