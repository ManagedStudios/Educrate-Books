

import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_selected_wrap.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock{
  void onDeleteChip(LfgChip chip);
  void onFilterTextChange(String text);
}


void main () {
  late List<LfgChip> selectedChips;
  late MockFunctions mockFunctions;


  setUp(() {
    mockFunctions = MockFunctions();
    String str = "Lorem ipsum dolor sit amet";
    selectedChips = str.split(" ").map((e) => TrainingDirectionsData(e)).toList();
  });

  Widget createWidgetUnderTest (List<LfgChip> selectedChipsList, {double width = 400}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: ActionDropdownSelectedWrap(width: width, selectedChips: selectedChipsList,
            onDeleteChip: mockFunctions.onDeleteChip,
            onFilterTextChange: mockFunctions.onFilterTextChange, onFocusChanged: (bool focused) {  },)
    );
  }

  testWidgets('LfgChip items render correctly inside the Wrap widget', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));

    // Iterate over each selected chip to ensure it's present
    for (final chip in selectedChips) {
      // Use the .getLabelText() method for validation
      expect(find.text(chip.getLabelText()), findsOneWidget);
    }
  });

  testWidgets('Tapping the delete icon of a ChipTag triggers onDeleteChip with correct LfgChip', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));
    // Get the first chip for testing
    final chipToTest = selectedChips.first;
    // Assume ChipTag has a delete icon that can be identified, either by an Icon or other identifiable widget.
    // If there's a more specific way to identify the delete icon of ChipTag in your implementation, use that.
    final deleteIconFinder = find.byIcon(Icons.close).first;
    // Tap on the delete icon of the first ChipTag
    await tester.tap(deleteIconFinder);
    await tester.pump();
    // Verify that onDeleteChip was called with the correct chip
    verify(() => mockFunctions.onDeleteChip(chipToTest)).called(1);
  });

  testWidgets('TextField is present within ActionDropdownSelectedWrap', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));

    // Ensure TextField is present
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Text entered into TextField is converted to uppercase', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));
    // Find the TextField
    final textFieldFinder = find.byType(TextField);
    // Type a lowercase string into the TextField
    const inputText = 'testinput';
    await tester.enterText(textFieldFinder, inputText);
    // Pump to allow onChanged to be called
    await tester.pump();
    // Fetch the text from the TextEditingController
    final textField = tester.widget<TextField>(textFieldFinder);
    final TextEditingController controller = textField.controller!;
    // Verify the text is converted to uppercase
    expect(controller.text, inputText.toUpperCase());
  });

  testWidgets('onFilterTextChange is triggered with correct text when text changes', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));

    // Find the TextField
    final textFieldFinder = find.byType(TextField);
    // Set up the expectation for the onFilterTextChange callback
    const inputText = 'testinput';
    // Enter text into the TextField
    await tester.enterText(textFieldFinder, inputText);
    // Pump to process the onChanged event
    await tester.pump();

    // Verify that onFilterTextChange was called with the correct text
    verify(() => mockFunctions.onFilterTextChange(inputText.toUpperCase())).called(1);
  });

  testWidgets('TextField has autofocus enabled', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));

    // Find the TextField
    final textFieldFinder = find.byType(TextField);

    // Fetch the TextField widget
    final textField = tester.widget<TextField>(textFieldFinder);

    // Verify that the autofocus property is true
    expect(textField.autofocus, true);
  });

  testWidgets('TextField has correct styling as defined in ActionDropdownSelectedWrap', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));

    // Find the TextField
    final textFieldFinder = find.byType(TextField);

    // Fetch the TextField widget
    final textField = tester.widget<TextField>(textFieldFinder);

    // Check properties of InputDecoration
    expect(textField.decoration!.border, InputBorder.none);
    expect(textField.decoration!.focusedBorder, InputBorder.none);
    expect(textField.decoration!.enabledBorder, InputBorder.none);
    expect(textField.decoration!.errorBorder, InputBorder.none);
    expect(textField.decoration!.disabledBorder, InputBorder.none);
    expect(textField.decoration!.contentPadding, const EdgeInsets.all(0));
    expect(textField.decoration!.hintText, TextRes.search);
    expect(textField.decoration!.labelText, null);
    expect(textField.decoration!.counterText, '');

    // Validate the isDense property
    expect(textField.decoration!.isDense, true);
  });

  testWidgets('SizedBox respects the width specified by the width parameter', (WidgetTester tester) async {
    const testWidth = 400.0;  // Example width value

    await tester.pumpWidget(createWidgetUnderTest(selectedChips, width: testWidth));

    // Find the SizedBox using its key
    final sizedBoxFinder = find.byKey(const Key('ActionSeWrSBFCard'));

    // Fetch the SizedBox widget
    final sizedBox = tester.widget<SizedBox>(sizedBoxFinder);

    // Confirm the width
    expect(sizedBox.width, testWidth);
  });

  testWidgets('TextField controller is correctly initialized during initState', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(selectedChips));

    // Find the TextField
    final textFieldFinder = find.byType(TextField);

    // Fetch the TextField widget
    final textField = tester.widget<TextField>(textFieldFinder);

    // Confirm the controller is not null
    expect(textField.controller, isNotNull);
  });

  testWidgets('Widget behaves correctly with an empty list of LfgChip', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest([])); // Passing empty list
    // Verify that no ChipTag is present
    expect(find.byType(ChipTag), findsNothing);
    // Verify that the TextField is present
    expect(find.byType(TextField), findsOneWidget);
  });





}