



import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/student_dialog/student_dialog.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main () {

  late Student student;
  late String id;
  late String firstName;
  late String lastName;
  late int classLevel;
  late String classChar;
  late List<String> studentTrainingDirections;
  late List<BookLite> books;
  late int amountOfBooks;

  late List<ClassData> classes;
  late List<TrainingDirectionsData> trainingDirections;

  late String title;
  late String actionText;
  setUp(() {

    title = "Add student";
    actionText = "Save";
    id = "123";
    firstName = "Dibbo-Mrinmoy";
    lastName = "Saha";
    classLevel = 10;
    classChar = "K";
    studentTrainingDirections = ["BASIC-10", "ETH-LAT-10"];
    books = [BookLite("book1", "Green Line New 5", "Englisch", 10)];
    amountOfBooks = 1;

    student = Student(id, firstName: firstName, lastName: lastName,
        classLevel: classLevel, classChar: classChar,
        trainingDirections: studentTrainingDirections, books: books, amountOfBooks: amountOfBooks);

    List<String> classStrings = ["A", "B", "C", "D"];
    int level = 5;
    classes = List.generate(6*classStrings.length, (index) => ClassData(index%classStrings.length==3?level++:level, classStrings[index%classStrings.length]));
    trainingDirections = [const TrainingDirectionsData("REL-LAT-10"), const TrainingDirectionsData("REL-FR-10")];

  });

  Widget createWidgetUnderTest ({Student? studentParam}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: StudentDialog(title: title,
            classes: classes,
            actionText: actionText,
            trainingDirections: trainingDirections,
          student: studentParam,loading: false,)
    );
  }


  testWidgets('Dialog displays correct title and action button text', (WidgetTester tester) async {
    // Render the widget.
    await tester.pumpWidget(createWidgetUnderTest());

    // Locate the title widget and action button.
    final titleWidget = find.text(title);
    final actionButtonWidget = find.widgetWithText(FilledButton, actionText);

    // Verify that the title and action button display the correct texts.
    expect(titleWidget, findsOneWidget);
    expect(actionButtonWidget, findsOneWidget);
  });

  testWidgets('Displays error messages for empty or invalid inputs after clicking the Save button', (WidgetTester tester) async {
    // Render the widget without providing a student.
    await tester.pumpWidget(createWidgetUnderTest());

    // Find the "Save" button and tap it to trigger the validation.
    final saveButton = find.text(actionText);
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);

    // Rebuild the widget to reflect the changes.
    await tester.pump();

    // Find the error messages.
    final firstNameErrorMsg = find.text(TextRes.firstNameError);
    final lastNameErrorMsg = find.text(TextRes.lastNameError);
    final classErrorMsg = find.text(TextRes.classError);

    // Verify that the error messages are displayed.
    expect(firstNameErrorMsg, findsOneWidget);
    expect(lastNameErrorMsg, findsOneWidget);
    expect(classErrorMsg, findsOneWidget);
  });

  testWidgets('Error messages disappear after correcting inputs and clicking the Save button', (WidgetTester tester) async {
    // Render the widget without providing a student.
    await tester.pumpWidget(createWidgetUnderTest());

    // Find and tap the "Save" button to trigger the validation.
    final saveButton = find.text(actionText);
    await tester.tap(saveButton);
    await tester.pump();

    // Confirm that the error messages appear.
    expect(find.text(TextRes.firstNameError), findsOneWidget);
    expect(find.text(TextRes.lastNameError), findsOneWidget);
    expect(find.text(TextRes.classError), findsOneWidget);

    // Correct the errors.
    // Let's start with the first name:
    final firstNameField = find.byType(TextField).at(0); // Assuming first TextField corresponds to the first name.
    await tester.enterText(firstNameField, 'John');
    await tester.pump();

    // Now, the last name:
    final lastNameField = find.byType(TextField).at(1); // Assuming the second TextField corresponds to the last name.
    await tester.enterText(lastNameField, 'Doe');
    await tester.pump();

    // For class data, let's assume the Dropdown widget is used to select the class:
    // Locate and tap on the Dropdown to trigger the class selection.
    // Note: Adjust this section according to the actual implementation of class selection.
    final classDropdown = find.byType(ChipWrap).first;
    await tester.tap(classDropdown);
    await tester.pumpAndSettle(); // Wait for the dropdown menu to fully expand.

    // Select the first class from the dropdown menu.
    final firstClassOption = find.text(classes[0].getLabelText()).first;
    await tester.tap(firstClassOption);
    await tester.pumpAndSettle();

    //close overlay
    await tester.tapAt(Offset(0, 0));
    await tester.pumpAndSettle();


    // Verify that the error messages have disappeared.
    expect(find.text(TextRes.firstNameError), findsNothing);
    expect(find.text(TextRes.lastNameError), findsNothing);
    expect(find.text(TextRes.classError), findsNothing);
  });

  testWidgets("test if correct data is passed", (tester) async {
    final router = GoRouter(initialLocation: '/', routes: [
      GoRoute(path: '/', builder: (context, state) => FilledButton(
              onPressed: () {
                showDialog<Student>(context: context,
                    builder: (context) => createWidgetUnderTest(studentParam: student))
                    .then((Student? value) {
                  expect(value?.id, student.id);
                });
              },
              child: Text("Click"),
            )
      )
    ]);

    await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        )
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text(actionText));
    await tester.pumpAndSettle();

  });

  testWidgets("test if updated student is correctly passed", (tester) async {
    String newName = "Arda";
    final router = GoRouter(initialLocation: '/', routes: [
      GoRoute(path: '/', builder: (context, state) => FilledButton(
        onPressed: () {
          showDialog<Student>(context: context,
              builder: (context) => createWidgetUnderTest(studentParam: student))
              .then((Student? value) {
            expect(value?.id, student.id);
            expect(value?.lastName, student.lastName);
            expect(value?.books, student.books);
            expect(value?.firstName, newName);
          });
        },
        child: Text("Click"),
      )
      )
    ]);

    await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        )
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();


    await tester.enterText(find.byType(TextField).first, newName);
    await tester.pumpAndSettle();

    await tester.tap(find.text(actionText));
    await tester.pumpAndSettle();

  });

  testWidgets("test if created student is correctly passed", (tester) async {

    final router = GoRouter(initialLocation: '/', routes: [
      GoRoute(path: '/', builder: (context, state) => FilledButton(
        onPressed: () {
          showDialog<List<Object?>>(context: context,
              builder: (context) => createWidgetUnderTest())
              .then((List<Object?>? value) {
            final firstName = value?[0] as String;
            final lastName = value?[1] as String;
            final classLevel = value?[2] as int;
            final classChar = value?[3] as String;
            final trainingDirections = value?[4] as List<String>;

            expect(firstName, student.firstName);
            expect(lastName, student.lastName);
            expect(classLevel, classes[0].classLevel);
            expect(classChar, classes[0].classChar);
            expect(trainingDirections, []);
          });
        },
        child: Text("Click"),
      )
      )
    ]);

    await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        )
    );

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();


    await tester.enterText(find.byType(TextField).first, student.firstName);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, student.lastName);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ChipWrap).first);
    await tester.pump();
    await tester.tap(find.text(classes[0].getLabelText()));
    await tester.pumpAndSettle();

    await tester.tap(find.text(actionText));
    await tester.pumpAndSettle();

  });


}

