

import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onAddChip(LfgChip chip);
  void onDeleteChip(LfgChip chip);
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

  testWidgets('Selecting a chip triggers onAddChip with the correct chip', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

    // Let's tap on the first chip in ActionDropdownAvailableContainer as an example
    final firstChipLabel = availableChips.first.getLabelText();
    final firstChipFinder = find.text(firstChipLabel);

    // Tap on the chip
    await tester.tap(firstChipFinder);
    await tester.pump();

    // Verify that the onAddChip callback was called with the correct chip
    verify(() => mockFunctions.onAddChip(availableChips.first)).called(1);
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



}