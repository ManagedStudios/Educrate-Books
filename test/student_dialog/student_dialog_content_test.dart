


import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/keys.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/student_dialog/student_dialog_content.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onFirstNameChanged(String firstName);
  void onLastNameChanged(String lastName);
  void onStudentDirectionsUpdated(List<TrainingDirectionsData> trainingDirections);
  void onStudentClassUpdated(ClassData? classData);
}

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

  late String firstNameError;
  late String lastNameError;
  late String classError;

  late MockFunctions mockFunctions;

  setUp(() {
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
    trainingDirections = [TrainingDirectionsData("REL-LAT-10"), TrainingDirectionsData("REL-FR-10")];

    firstNameError = "Select first name!";
    lastNameError = "Select last name!";
    classError = "Select class!";

    mockFunctions = MockFunctions();
  });

  Widget createWidgetUnderTest({Student? studentParam, required List<ClassData> classesList,
    required List<TrainingDirectionsData> trainingDirectionsList, String? firstNameErrorParam,
   String? lastNameErrorParam, String? classErrorParam, bool loading = false}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: AlertDialog(
          content: StudentDialogContent(classes: classesList,
                onStudentClassUpdated: mockFunctions.onStudentClassUpdated,
                trainingDirections: trainingDirectionsList,
                student: studentParam,
                onStudentTrainingDirectionsUpdated: mockFunctions.onStudentDirectionsUpdated,
                onFirstNameChanged: mockFunctions.onFirstNameChanged,
                onLastNameChanged: mockFunctions.onLastNameChanged,
                firstNameError: firstNameErrorParam,
                lastNameError: lastNameErrorParam,
                classError: classErrorParam,loading: loading,),

        )
    );
  }

  testWidgets('initializes controllers with student first name and last name when student is provided', (WidgetTester tester) async {
    // Provide the student to the widget.
    await tester.pumpWidget(createWidgetUnderTest(
      studentParam: student,
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    expect(student, isNotNull);


    // Find the TextField widgets.
    final firstNameField = find.byType(TextField).at(0);
    final lastNameField = find.byType(TextField).at(1);

    await tester.pumpAndSettle();
    // Fetch the current value of the TextField using TextEditingController.
    final firstNameValue = tester.widget<TextField>(firstNameField).controller?.text;
    final lastNameValue = tester.widget<TextField>(lastNameField).controller?.text;

    // Assert the values.
    expect(firstNameValue, equals(firstName));
    expect(lastNameValue, equals(lastName));
  });

  testWidgets('initializes controllers with empty strings when student is not provided', (WidgetTester tester) async {
    // Initialize without a student
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Find the TextField widgets.
    final firstNameField = find.byType(TextField).at(0);
    final lastNameField = find.byType(TextField).at(1);

    await tester.pumpAndSettle();

    // Fetch the current value of the TextField using TextEditingController.
    final firstNameValue = tester.widget<TextField>(firstNameField).controller?.text;
    final lastNameValue = tester.widget<TextField>(lastNameField).controller?.text;

    // Assert the values.
    expect(firstNameValue, equals(''));
    expect(lastNameValue, equals(''));
  });

  testWidgets('triggers onFirstNameChanged callback when first name is changed', (WidgetTester tester) async {
    // Provide the widget with necessary inputs
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Find the TextField for the first name.
    final firstNameField = find.byType(TextField).at(0);

    await tester.enterText(firstNameField, 'NewName');

    // Verify that the callback is called with the right value
    verify(() => mockFunctions.onFirstNameChanged('NewName')).called(1);
  });

  testWidgets('triggers onLastNameChanged callback when last name is changed', (WidgetTester tester) async {
    // Provide the widget with necessary inputs
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Find the TextField for the last name.
    final lastNameField = find.byType(TextField).at(1);

    await tester.enterText(lastNameField, 'LastNameChanged');

    // Verify that the callback is called with the right value
    verify(() => mockFunctions.onLastNameChanged('LastNameChanged')).called(1);
  });

  testWidgets('displays firstNameError message correctly', (WidgetTester tester) async {
    // Provide the widget with necessary inputs including the firstNameError
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
      firstNameErrorParam: firstNameError,
    ));

    // Find the error text on the screen
    final errorTextFinder = find.text(firstNameError);

    // Check if it's displayed correctly
    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('displays lastNameError message correctly', (WidgetTester tester) async {
    // Provide the widget with necessary inputs including the lastNameError
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
      lastNameErrorParam: lastNameError,
    ));

    // Find the error text on the screen
    final errorTextFinder = find.text(lastNameError);

    // Check if it's displayed correctly
    expect(errorTextFinder, findsOneWidget);
  });

  testWidgets('populates dropdown with provided list of classes', (WidgetTester tester) async {
    // Provide the widget with necessary inputs
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Simulate a tap on the dropdown to open it
    await tester.tap(find.byType(Dropdown<ClassData>));
    await tester.pumpAndSettle(); // Allow the dropdown items to render

    // Verify that each class in the provided list is present in the dropdown
    for (final classData in classes) {
      await tester.scrollUntilVisible(find.text(classData.getLabelText()), 10,
          scrollable: find.descendant(of: find.byKey(Key(Keys.ActionDropdownAvailableCardKey)), matching: find.byType(Scrollable)));
      expect(find.text(classData.getLabelText()), findsOneWidget);
    }
  });

  testWidgets('displays class error message when classError is provided', (WidgetTester tester) async {
    // Render the widget with the classError set
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
      classErrorParam: classError,
    ));

    // Verify that the error message is shown
    expect(find.text(classError), findsOneWidget);
  });

  testWidgets('onStudentClassUpdated callback is executed when a class is selected or deselected', (WidgetTester tester) async {
    // Render the widget
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Open the class dropdown
    await tester.tap(find.text(TextRes.addChipsHint).first);
    await tester.pumpAndSettle();

    // Simulate a tap on the first class in the dropdown
    final classItem = find.byKey(Key(classes.first.getLabelText()));
    await tester.tap(classItem);
    await tester.pumpAndSettle();

    verify(() => mockFunctions.onStudentClassUpdated(classes.first)).called(1);

    await tester.tapAt(Offset(0, 0));
    await tester.pumpAndSettle();

    // Check if the mock callback was called with the correct argument
    verify(() => mockFunctions.onStudentClassUpdated(classes.first)).called(1);

  });

  testWidgets('Training Directions dropdown populates with the provided training directions', (WidgetTester tester) async {
    // Render the widget
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Open the training directions dropdown
    await tester.tap(find.text(TextRes.addChipsHint).last);
    await tester.pumpAndSettle();

    // Check if each training direction is present within the widget tree
    for (TrainingDirectionsData trainingDirection in trainingDirections) {
      expect(find.text(trainingDirection.getLabelText()), findsOneWidget);
    }
  });

  testWidgets('onStudentTrainingDirectionsUpdated callback is executed correctly when training directions are added or removed', (WidgetTester tester) async {
    // Render the widget
    await tester.pumpWidget(createWidgetUnderTest(
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));
    // Open the training directions dropdown
    await tester.tap(find.text(TextRes.addChipsHint).last);
    await tester.pumpAndSettle();

    // Assume there's a way to select a training direction (e.g., by tapping on it). Here we tap on the first direction.
    await tester.tap(find.byKey(Key(trainingDirections[0].getLabelText())));
    await tester.pumpAndSettle();

    //close the overlay
    await tester.tapAt(Offset(0, 0));

    // Verify if the callback was executed with the selected training direction.
    verify(() => mockFunctions.onStudentDirectionsUpdated([trainingDirections[0]]));

    await tester.pumpAndSettle();

    // Open the training directions dropdown
    await tester.tap(find.text(trainingDirections[0].getLabelText()));
    await tester.pumpAndSettle();

    // Now, assume there's a way to deselect a training direction (e.g., by tapping on it again). Here we tap on the first direction to deselect.
    var chipTag = find.byKey(Key(trainingDirections[0].getLabelText()));
    var iconButton = find.descendant(of: chipTag, matching: find.byType(IconButton));
    await tester.tap(iconButton);
    await tester.pumpAndSettle();

    //close the overlay
    await tester.tapAt(Offset(0, 0));

    // Verify if the callback was executed with an empty list as the training direction was deselected.
    verify(() => mockFunctions.onStudentDirectionsUpdated([]));
  });


  testWidgets('Form elements are populated correctly in update scenario', (WidgetTester tester) async {
    // Render the widget with the provided student
    await tester.pumpWidget(createWidgetUnderTest(
      studentParam: student,
      classesList: classes,
      trainingDirectionsList: trainingDirections,
    ));

    // Check the initial values of the TextFields for first name and last name
    final firstNameField = find.byType(TextField).at(0);
    final lastNameField = find.byType(TextField).at(1);

    // Fetch the current value of the TextField using TextEditingController.
    final firstNameValue = tester.widget<TextField>(firstNameField).controller?.text;
    final lastNameValue = tester.widget<TextField>(lastNameField).controller?.text;

    // Assert the values match the provided student's first name and last name.
    expect(firstNameValue, equals(student.firstName));
    expect(lastNameValue, equals(student.lastName));

    // Additional checks for Dropdowns and other elements with initial values can be added similarly:
    // Example: Check if the correct class and training directions are selected in the dropdowns.

    // Assuming you have a way to identify selected classes and training directions, e.g., through `find.text()`.
    expect(find.text(student.classLevel.toString() + student.classChar), findsOneWidget);

    for (var direction in student.trainingDirections) {
      expect(find.text(direction), findsOneWidget);
    }
  });

  testWidgets("Changing loading state", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(classesList: [],
        trainingDirectionsList: [], loading: true));

    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await tester.pumpWidget(createWidgetUnderTest(classesList: classes,
        trainingDirectionsList: trainingDirections, loading: false));

    expect(find.byType(LinearProgressIndicator), findsNothing);
    await tester.tap(find.byType(ChipWrap).first);
    await tester.pumpAndSettle();
    expect(find.byKey(Key(classes[0].getLabelText())), findsOneWidget);
  });



}