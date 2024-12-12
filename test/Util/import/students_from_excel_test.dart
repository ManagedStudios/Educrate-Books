


import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/students_from_excel.dart';
import 'package:cbl/cbl.dart';
import 'package:cbl_dart/cbl_dart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Student student1;
  late Student student1a;
  late Student student1b;
  late Student student2;
  late Student student2a;
  late Student student3;


  setUpAll(() async{
    await CouchbaseLiteDart.init(edition: Edition.community);
  });

  setUp(() {

    student1 = Student("jfiwoejfoiwjeiof", firstName: "Dibbo-Mrinmoy",
        lastName: "Saha", classLevel: 11, classChar: "Q",
        trainingDirections: ["BASIC-11, ETH-LAT-11"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11),
          BookLite("321", "Lambacher Schweizer", "Mather", 11)], amountOfBooks: 0, tags: []);
    student1a = Student("jfiwoejfoiwjeiof", firstName: "Dibbo-Mrinmoy",
        lastName: "Saha", classLevel: 11, classChar: "Q",
        trainingDirections: ["xyz-12"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11),
          BookLite("321", "Lambacher Schweizer", "Mather", 11)], amountOfBooks: 0, tags: []);
    student1b = Student("jfiwoejfoiwjeiof", firstName: "Dibbo-Mrinmoy",
        lastName: "Saha", classLevel: 11, classChar: "Q",
        trainingDirections: ["x-7"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11),
          BookLite("321", "Lambacher Schweizer", "Mather", 11)], amountOfBooks: 0, tags: []);

    student2 = Student("fiweohfoiwf", firstName: "Arda",
        lastName: "Stigler", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10, ETH-LAT-10, KUNST-10"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)], amountOfBooks: 0, tags: []);
    student2a = Student("fiweohfoiwf", firstName: "Arda",
        lastName: "Stigler", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10, ETH-LAT-10, KUNST-10", "neue tr-direction"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)], amountOfBooks: 0, tags: []);

    student3 = Student("iwfeojiofwiofew", firstName: "Neumann",
        lastName: "Otto", classLevel: 10, classChar: "K",
        trainingDirections: ["BASIC-10", "ETH-LAT-10", "KUNST-10", "neue tr-direction"],
        books: [BookLite("123", "Green Line New 5", "Englisch", 11)], amountOfBooks: 0, tags: []);

  });


  group("test groupStudentsAccordingToName function", () {

    test("test students of same name are grouped with unique trainingDirections", () {
      List<Student> students = [student1, student1a, student1b];
      List<MutableDocument> docs = [];
      for (Student student in students) {
        final doc = MutableDocument();
        DB().updateDocFromEntity(student, doc);
        docs.add(doc);
      }
      List<MutableDocument> groupedStudents = groupStudentsAccordingToName(docs, DB());
      expect(groupedStudents.length, 1);


      final Student student = DB().toEntity(Student.fromJson, groupedStudents.first);
      final trainingDirectionsExpected = [];
      trainingDirectionsExpected.addAll(student1.trainingDirections);
      trainingDirectionsExpected.addAll(student1a.trainingDirections);
      trainingDirectionsExpected.addAll(student1b.trainingDirections);
      expect(areListsEqualIgnoringOrder(student.trainingDirections, trainingDirectionsExpected), true);

    });

    test("test students of same name are grouped with unique and non-unique trainingDirections", () {
      List<Student> students = [student1, student1a, student1b, student2, student2a];
      List<MutableDocument> docs = [];
      for (Student student in students) {
        final doc = MutableDocument();
        DB().updateDocFromEntity(student, doc);
        docs.add(doc);
      }
      List<MutableDocument> groupedStudents = groupStudentsAccordingToName(docs, DB());
      expect(groupedStudents.length, 2);


      final Student student = DB().toEntity(Student.fromJson, groupedStudents.first);
      final trainingDirectionsExpected = [];
      trainingDirectionsExpected.addAll(student1.trainingDirections);
      trainingDirectionsExpected.addAll(student1a.trainingDirections);
      trainingDirectionsExpected.addAll(student1b.trainingDirections);
      expect(areListsEqualIgnoringOrder(student.trainingDirections, trainingDirectionsExpected), true);

      final Student otherStudent = DB().toEntity(Student.fromJson, groupedStudents.last);
      List<String> trainingDirectionsExpected1 = [];
      trainingDirectionsExpected1.addAll(student2.trainingDirections);
      trainingDirectionsExpected1.addAll(student2a.trainingDirections);
      trainingDirectionsExpected1 = trainingDirectionsExpected1.toSet().toList();
      expect(areListsEqualIgnoringOrder(otherStudent.trainingDirections, trainingDirectionsExpected1), true);


    });

  });

}