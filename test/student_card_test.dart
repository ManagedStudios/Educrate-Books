
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/students/student_card.dart';
import 'package:flutter/gestures.dart';
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
      student = Student("Dibbo", firstName: "Dibbo-Mrinmoy", lastName: "Saha Von XY", classLevel: 10, classChar: "K", trainingDirections: ["ETH-LAT-10", "BASIC-10"], books: [], amountOfBooks: 0, tags: []);
      mockFunctions = MockFunctions();
    });

    Widget createWidgetUnderTest ({bool isClicked = false}) {
      return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme),
        home: StudentCard(
          student,
          isClicked,
          key: Key(student.id),
          setClickedStudent: mockFunctions.setClickedStudent,
          notifyDetailPage: mockFunctions.notifyDetailPage,
          openEditDialog: mockFunctions.openEditDialog,
          onDeleteStudent: mockFunctions.openDeleteDialog,
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
      expect(find.text("${student.classLevel.toString()}${student.classChar} – "), findsOneWidget);
      expect(find.text(student.trainingDirections.join("  ")), findsOneWidget);

    });

    testWidgets("Icon sizes increase on hover", (tester) async{
      await tester.pumpWidget(createWidgetUnderTest());
      // Ensure the icons are not visible initially
      final editFinder = find.widgetWithIcon(IconButton, Icons.edit);
      final closeFinder = find.widgetWithIcon(IconButton, Icons.close);

      expect(tester.widget<IconButton>(editFinder).style!.iconSize!.resolve({}), 0.0);
      expect(tester.widget<IconButton>(closeFinder).style!.iconSize!.resolve({}), 0.0);

      // Trigger a hover event
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(StudentCard)));

      // Check if the icons are visible now
      expect(tester.widget<IconButton>(editFinder).style!.iconSize!.resolve({}), 16.0);
      expect(tester.widget<IconButton>(closeFinder).style!.iconSize!.resolve({}), 16.0);

    });

    testWidgets("Test if icons sizes decrease after hover", (tester) async{

      await tester.pumpWidget(createWidgetUnderTest());
      final editFinder = find.widgetWithIcon(IconButton, Icons.edit);
      final closeFinder = find.widgetWithIcon(IconButton, Icons.close);
      // Trigger a hover event
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(StudentCard)));
      await tester.pumpAndSettle();
      // Check if the icons are visible now
      expect(tester.widget<IconButton>(editFinder).style!.iconSize!.resolve({}), 16.0);
      expect(tester.widget<IconButton>(closeFinder).style!.iconSize!.resolve({}), 16.0);
      await gesture.moveBy(const Offset(0, -500));
      await tester.pumpAndSettle();
      // Check if the icons are hidden now
      expect(tester.widget<IconButton>(editFinder).style!.iconSize!.resolve({}), 0.0);
      expect(tester.widget<IconButton>(closeFinder).style!.iconSize!.resolve({}), 0.0);
    });

    testWidgets("Test edit button click", (tester)  async{
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.widgetWithIcon(IconButton, Icons.edit));

      verify(() => mockFunctions.openEditDialog(student)).called(1);
    });

    testWidgets("Test close button click", (tester)  async{
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.widgetWithIcon(IconButton, Icons.close));

      verify(() => mockFunctions.openDeleteDialog(student)).called(1);
    });

    testWidgets("Test student card click actions", (tester)  async{
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(StudentCard));

      verify(() => mockFunctions.setClickedStudent(student.id)).called(1);
      verify(() => mockFunctions.notifyDetailPage(student)).called(1);
    });

    testWidgets("Test StudentCard styling", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(isClicked: true));

      // Test background color when isClicked is true
      final textbutton = find.byType(TextButton);

      expect(
          (tester.widget<TextButton>(textbutton).style!.backgroundColor!.resolve({}))!,
          tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!.colorScheme.tertiaryContainer
      );
      // Test border radius of the TextButton
      final border = tester.widget<TextButton>(textbutton).style!.shape!.resolve({});
      expect(
          (border as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(20)
      );
    });

  });
}