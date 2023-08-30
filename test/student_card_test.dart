
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/UI/student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStudent extends Mock implements Student {}

class MockFunctions extends Mock {
  void setClickedStudent (String id);
  void notifyDetailPage(Student currStudent);
  void openEditDialog(Student currStudent);
  void openDeleteDialog(Student currStudent);
}

void main() {
  group("Test the student card", () {
    late Student student;
    late MockFunctions mockFunctions;
    setUp(() {
      student = Student("Dibbo", firstName: "Dibbo-Mrinmoy", lastName: "Saha Von XY", classLevel: 10, classChar: "K", trainingDirections: ["ETH-LAT-10", "BASIC-10"], books: []);
      mockFunctions = MockFunctions();
    });

    Widget createWidgetUnderTest () {
      return MaterialApp(
        home: StudentCard(
          student,
          false,
          key: Key(student.id),
          setClickedStudent: mockFunctions.setClickedStudent,
          notifyDetailPage: mockFunctions.notifyDetailPage,
          openEditDialog: mockFunctions.openEditDialog,
          openDeleteDialog: mockFunctions.openDeleteDialog,
        )
      );
    }

  testWidgets("Test if widget renders correctly", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(StudentCard), findsOneWidget);
  });

    testWidgets("Test if all children of studentCard are rendered", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("${student.firstName} ${student.lastName}"), findsOneWidget);
      expect(find.text("${student.classLevel.toString()}${student.classChar} — "), findsOneWidget);
      for (var training in student.trainingDirections) {
        expect(find.text("$training  "), findsOneWidget);
      }
    });




  });
}