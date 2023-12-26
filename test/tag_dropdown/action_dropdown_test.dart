



import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onAddChip(LfgChip chip);
  void onDeleteChip(LfgChip chip);
}

class MockLfgChip extends Mock implements LfgChip {
  MockLfgChip({required this.label});
  final String label;

  @override
  getLabelText() {
    return label;
  }
}
void main () {
  late List<LfgChip> availableChips;
  late List<LfgChip> selectedChips;
  late MockFunctions mockFunctions;
  setUp(() {
    mockFunctions = MockFunctions();
    String strA = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod ETH-0";
    String strS = "Stet clita kasd gubergren";
    availableChips = strA.split(" ").map((e) => TrainingDirectionsData(e)).toList();
    selectedChips = strS.split(" ").map((e) => TrainingDirectionsData(e)).toList();
  });

  Widget createWidgetUnderTest (List<LfgChip> availableChipList,
      List<LfgChip> selectedChipList, {double width = 400, String? hintText}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: ActionDropdown(width: width, selectedChips: selectedChipList,
            onDeleteChip: mockFunctions.onDeleteChip,
            availableChips: availableChipList, onAddChip: mockFunctions.onAddChip)
    );
  }

  group("Test widget", () {
    testWidgets('Typing a filter text correctly filters chips in ActionDropdownAvailableContainer', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

      // Example filter text
      const filterText = "Lorem";

      // Type the filter text into the TextField of ActionDropdownSelectedWrap
      await tester.enterText(find.byType(TextField), filterText);

      // Rebuild the widget with the state change
      await tester.pumpAndSettle();

      // Fetch the list of chips that should be visible based on the filter
      final expectedChips = availableChips.where((chip) => chip.getLabelText().contains(filterText)).toList();

      // Confirm that the expected chips are visible
      for (final chip in expectedChips) {
        expect(find.text(chip.getLabelText()), findsOneWidget);
      }

      // Confirm that other chips are not visible
      final unexpectedChips = availableChips.where((chip) => !chip.getLabelText().contains(filterText)).toList();
      for (final chip in unexpectedChips) {
        expect(find.text(chip.getLabelText()), findsNothing);
      }
    });

    testWidgets('Filters chips based on number', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

      // Example number for filtering
      const filterNumber = "0";

      // Type the filter number into the TextField of ActionDropdownSelectedWrap
      await tester.enterText(find.byType(TextField), filterNumber);

      // Rebuild the widget with the state change
      await tester.pump();

      // Fetch the list of chips that should be visible based on the number
      final expectedChips = availableChips.where((chip) => chip.getLabelText().contains(filterNumber)).toList();

      // Confirm that the expected chips are visible
      for (final chip in expectedChips) {
        expect(find.text(chip.getLabelText()), findsOneWidget);
      }

      // Confirm that other chips are not visible
      final unexpectedChips = availableChips.where((chip) => !chip.getLabelText().contains(filterNumber)).toList();
      for (final chip in unexpectedChips) {
        expect(find.text(chip.getLabelText()), findsNothing);
      }
    });

    testWidgets('Deleting a chip triggers onDeleteChip with the correct chip', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));
      // For this example, let's try to delete the first chip in ActionDropdownSelectedWrap
      final firstSelectedChipLabel = selectedChips.first.getLabelText();

      // Since it's not directly mentioned how the deletion is triggered, let's assume there's a close icon next to the chip label
      final deleteIconFinder = find.descendant(of: find.byKey(Key(firstSelectedChipLabel)), matching: find.byType(IconButton));

      // Tap on the delete icon/close icon
      await tester.tap(deleteIconFinder);
      await tester.pump();

      // Verify that the onDeleteChip callback was called with the correct chip
      verify(() => mockFunctions.onDeleteChip(selectedChips.first)).called(1);
    });
  });


  group("Test filter function", () {

    late List<LfgChip> classes1;
    late List<LfgChip> trainingDirections1;
    late List<LfgChip> books;



    setUp(() {
      classes1 = [ClassData(10, "K"), ClassData(10, "A"), ClassData(10, "B"),
        ClassData(9, "A"),ClassData(9, "B"), ClassData(8, "A"), ClassData(7, "K"), ClassData(7, "C"),
        ClassData(7, "D"), ClassData(6, "A"), ClassData(6, "i"), ClassData(5, "a"),
        ClassData(5, "B"),];
      trainingDirections1 = [const TrainingDirectionsData("Basic-10"),
        const TrainingDirectionsData("ETHIK-10"),
        const TrainingDirectionsData("BASIC-5"), const TrainingDirectionsData("BASIC-6"),
        const TrainingDirectionsData(""),
      ];
      books = [
      Book(
      bookId: "12345",
      name: "Green Line New 5",
      subject: "Englisch",
      classLevel: 11,
      trainingDirection: ["BASIC-11"],
      amountInStudentOwnership: 50,
      nowAvailable: 10,
      totalAvailable: 60),
        Book(
            bookId: "12346",
            name: "Math Foundations",
            subject: "Mathematics",
            classLevel: 11,
            trainingDirection: ["BASIC-11"],
            amountInStudentOwnership: 45,
            nowAvailable: 8,
            totalAvailable: 53),
        Book(
            bookId: "12347",
            name: "Historical Epochs",
            subject: "History",
            classLevel: 11,
            trainingDirection: ["BASIC-11"],
            amountInStudentOwnership: 40,
            nowAvailable: 12,
            totalAvailable: 52),
        Book(
            bookId: "12348",
            name: "Chemistry Elements",
            subject: "Chemistry",
            classLevel: 11,
            trainingDirection: ["BASIC-11"],
            amountInStudentOwnership: 55,
            nowAvailable: 15,
            totalAvailable: 70),
        Book(
            bookId: "12349",
            name: "Biology of Life",
            subject: "Biology",
            classLevel: 11,
            trainingDirection: ["BASIC-11"],
            amountInStudentOwnership: 60,
            nowAvailable: 20,
            totalAvailable: 80),
        Book(
            bookId: "12350",
            name: "Art and Culture",
            subject: "Art",
            classLevel: 10,
            trainingDirection: ["BASIC-11"],
            amountInStudentOwnership: 65,
            nowAvailable: 25,
            totalAvailable: 90),
        Book(
            bookId: "12351",
            name: "Physical Realms",
            subject: "Physics",
            classLevel: 10,
            trainingDirection: ["BASIC-11"],
            amountInStudentOwnership: 70,
            nowAvailable: 30,
            totalAvailable: 100)
      ];


    });

    testWidgets("Test empty filter", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(classes1, []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(classes1, "");
      expect(filtered, classes1);
    });

    testWidgets("Test filtering classes 1 with only number", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(classes1.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(classes1, "10");
      expect(areListsEqualIgnoringOrder(filtered.map((e) => e.getLabelText()).toList(),
          [ClassData(10, "K"), ClassData(10, "A"), ClassData(10, "B")].map((e) => e.getLabelText()).toList()), true);
    });

    testWidgets("Test filtering classes 1 with only uppercase char", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(classes1.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(classes1, "A");
      expect(areListsEqualIgnoringOrder(filtered.map((e) => e.getLabelText()).toList(),
          [ClassData(10, "A"), ClassData(9, "A"),
            ClassData(8, "A"), ClassData(6, "A"),
            ClassData(5, "a")].map((e) => e.getLabelText()).toList()), true);
    });

    testWidgets("Test filtering classes 1 with number and char", (tester) async{
      await tester.pumpWidget(createWidgetUnderTest(classes1.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(classes1, "10K");
      expect(areListsEqualIgnoringOrder(filtered.map((e) => e.getLabelText()).toList(),
          [ClassData(10, "K")].map((e) => e.getLabelText()).toList()), true);
    });

    testWidgets("Test filtering trainingDirections with only beginning", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(trainingDirections1.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(trainingDirections1, "BA");
      expect(filtered.map((e) => e.getLabelText()).toList(),
          [const TrainingDirectionsData("Basic-10"),  const TrainingDirectionsData("BASIC-5"),
            const TrainingDirectionsData("BASIC-6")].map((e) => e.getLabelText()).toList());
    });

    testWidgets("Test filtering trainingDirections with only number", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(trainingDirections1.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(trainingDirections1, "10");
      expect(filtered.map((e) => e.getLabelText()).toList(),
      [const TrainingDirectionsData("Basic-10"),
        const TrainingDirectionsData("ETHIK-10")].map((e) => e.getLabelText()).toList());
    });

    testWidgets("Test filtering Books with only number", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(books.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(books, "10");
      expect(filtered.map((e) => e.getLabelText()).toList(),
          [Book(
              bookId: "12350",
              name: "Art and Culture",
              subject: "Art",
              classLevel: 10,
              trainingDirection: ["BASIC-11"],
              amountInStudentOwnership: 65,
              nowAvailable: 25,
              totalAvailable: 90),
          Book(
              bookId: "12351",
              name: "Physical Realms",
              subject: "Physics",
              classLevel: 10,
              trainingDirection: ["BASIC-11"],
              amountInStudentOwnership: 70,
              nowAvailable: 30,
              totalAvailable: 100)
          ].map((e) => e.getLabelText()).toList());
    });

    testWidgets("Test filtering Books with only chars", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(books.toList(), []));
      ActionDropdown actionDropdown = tester.widget(find.byType(ActionDropdown));
      final filtered = actionDropdown.filterList(books, "phy");
      expect(filtered.map((e) => e.getLabelText()).toList(),
          [
            Book(
                bookId: "12351",
                name: "Physical Realms",
                subject: "Physics",
                classLevel: 10,
                trainingDirection: ["BASIC-11"],
                amountInStudentOwnership: 70,
                nowAvailable: 30,
                totalAvailable: 100)
          ].map((e) => e.getLabelText()).toList());
    });


  });

}