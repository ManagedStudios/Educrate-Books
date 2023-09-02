


import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:cbl/cbl.dart';
import 'package:cbl_dart/cbl_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDB extends Mock implements DB {}
class MutableDictionaryFake extends Fake implements MutableDictionaryInterface {}


void main (){
  late MockDB mockDB;
  late StudentListState sut;

  setUpAll(() async{
    await CouchbaseLiteDart.init(edition: Edition.community);
    registerFallbackValue(MutableDictionaryFake());
  });

  setUp(() {
    mockDB = MockDB();
    sut = StudentListState(mockDB);
  });

  group("test the createNewStudentDoc function", () {
    late String firstName;
    late String lastName;
    late int classLevel;
    late String classChar;
    late List<String> trainingDirectionsFull;
    late List<String> trainingDirectionsEmpty;

    setUp(() {
      firstName = "Dibbo-Mrinmoy";
      lastName = "Saha";
      classLevel = 11;
      classChar = "Q";
      trainingDirectionsFull = ["BASIC-11", "ETH-LAT-11"];
      trainingDirectionsEmpty = [];
      when(() => mockDB.updateDocFromEntity(any(), any())).thenAnswer((invocation) {
            final student = invocation.positionalArguments[0] as Student;
            final document = invocation.positionalArguments[1] as MutableDocument;
            var json = student.toJson();
            json.remove(TextRes.studentIdJson);
            document.setData(json);
      });
    });

    test("normal arguments", (){
      final res = sut.createNewStudentDoc(firstName, lastName, classLevel, classChar, trainingDirectionsFull);
      expect(res.toPlainMap()[TextRes.studentFirstNameJson], firstName);
      expect(res.toPlainMap()[TextRes.typeJson], TextRes.studentTypeJson);
      expect(res.toPlainMap()[TextRes.studentLastNameJson], lastName);
      expect(res.toPlainMap()[TextRes.studentIdJson], null);
      expect(res.toPlainMap()[TextRes.studentClassLevelJson], classLevel);
      expect(res.toPlainMap()[TextRes.studentClassCharJson], classChar);
      expect(res.toPlainMap()[TextRes.studentTrainingDirectionsJson], trainingDirectionsFull);
      expect(res.toPlainMap()[TextRes.studentBooksJson], []);
    });

    test("empty training Directions", (){
      final res = sut.createNewStudentDoc(firstName, lastName, classLevel, classChar, trainingDirectionsEmpty);
      expect(res.toPlainMap()[TextRes.studentTrainingDirectionsJson], trainingDirectionsEmpty);
    });

  });



}