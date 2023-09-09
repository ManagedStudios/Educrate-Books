


import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_available_container.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_selected_wrap.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_tag.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock{
  void onAddChip(LfgChip chip);
  void onDeleteChip(LfgChip chip);
  void onCloseOverlay(List<LfgChip> chips);
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
      List<LfgChip> selectedChipList, {double width = 400, String? hintText,
      bool multiSelect = true}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: Padding(
          padding: EdgeInsets.all(30),
          child: Dropdown(availableChips: availableChipList,
          selectedChips: selectedChipList,
    onAddChip: mockFunctions.onAddChip,
    onDeleteChip: mockFunctions.onDeleteChip,
    multiSelect: multiSelect, width: width,
    onCloseOverlay: mockFunctions.onCloseOverlay),
        )
    );
  }

  testWidgets('Tapping on ChipWrap opens ActionDropdown overlay', (WidgetTester tester) async {
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));
    // Find the ChipWrap widget
    final chipWrapFinder = find.byType(ChipWrap);

    // Simulate a tap on ChipWrap
    await tester.tap(chipWrapFinder);

    // Call pump to trigger a rebuild
    await tester.pumpAndSettle();

    // Check if the ActionDropdown overlay is present in the widget tree
    expect(find.byType(ActionDropdown), findsOneWidget);
  });

  testWidgets('Clicking outside of ActionDropdown overlay closes it', (WidgetTester tester) async {
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

    // Find the ChipWrap widget
    final chipWrapFinder = find.byType(ChipWrap);

    // Simulate a tap on ChipWrap to open the overlay
    await tester.tap(chipWrapFinder);

    // Call pump to trigger a rebuild
    await tester.pumpAndSettle();

    // Verify the ActionDropdown overlay is present in the widget tree
    expect(find.byType(ActionDropdown), findsOneWidget);

    // Now, simulate tapping outside to close the overlay
    await tester.tapAt(Offset(0, 0)); // tapping at the top-left corner
    await tester.pumpAndSettle();

    // Verify the ActionDropdown overlay is no longer present in the widget tree
    expect(find.byType(ActionDropdown), findsNothing);
  });

  testWidgets('Overlay is positioned correctly relative to ChipWrap', (WidgetTester tester) async {
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

    // Find the ChipWrap widget
    final chipWrapFinder = find.byType(ChipWrap);
    // Fetch positions of ChipWrap and ActionDropdown overlay
    final chipWrapBox = tester.renderObject<RenderBox>(chipWrapFinder);
    final chipWrapOffset = chipWrapBox.localToGlobal(Offset.zero);

    // Simulate a tap on ChipWrap to open the overlay
    await tester.tap(chipWrapFinder);

    // Call pump to trigger a rebuild
    await tester.pump();


    final actionDropdownFinder = find.byType(ActionDropdown);
    final actionDropdownBox = tester.renderObject<RenderBox>(actionDropdownFinder);
    final actionDropdownOffset = actionDropdownBox.localToGlobal(Offset.zero);

    // Verify that overlay's top-left corner's position matches ChipWrap's (or however you've defined its position)
    // This assumes the overlay is positioned right below the ChipWrap, but you may adjust accordingly
    expect(actionDropdownOffset.dx, chipWrapOffset.dx);
    expect(actionDropdownOffset.dy, closeTo(chipWrapOffset.dy, 4.0)); // We use closeTo here to account for potential small variations

  });

  testWidgets('Selecting a chip in the overlay calls onAddChip and updates state', (WidgetTester tester) async {
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

    // Find the ChipWrap widget and open the overlay
    final chipWrapFinder = find.byType(ChipWrap);
    await tester.tap(chipWrapFinder);
    await tester.pump();

    // Find the first chip in the ActionDropdownAvailableContainer and tap it
    final firstAvailableChipFinder = find.descendant(
      of: find.byType(ActionDropdownAvailableContainer),
      matching: find.byType(ChipTag),
    ).first;

    final chipContent = (firstAvailableChipFinder.evaluate().first.widget as ChipTag).chipContent;
    final chipContentInAvailable = find.descendant(of:
    find.byType(ActionDropdownAvailableContainer),
        matching: find.text(chipContent.getLabelText()));

    expect(chipContentInAvailable, findsOneWidget);

    await tester.tap(firstAvailableChipFinder);
    await tester.pump();

    // Verify the onAddChip mock method was called with the appropriate chip
    verify(() => mockFunctions.onAddChip(chipContent)).called(1);

    // Verify that the internal state has been updated
    // This assumes you have a way to access the current state of the widget or can determine it by other means
    // For instance, the chip should no longer be in the availableChips and should be in the selectedChips

    final chipSelected = find.descendant(of:
    find.byType(ActionDropdownSelectedWrap),
        matching: find.text(chipContent.getLabelText()));

    final chipAvailable = find.descendant(of:
    find.byType(ActionDropdownAvailableContainer),
        matching: find.text(chipContent.getLabelText()));


    expect(chipSelected, findsOneWidget);
    expect(chipAvailable, findsNothing);
  });

  testWidgets('When multiSelect is false, selecting a new chip deselects the previously selected chip', (WidgetTester tester) async {
    // Load the main widget with multiSelect set to false
    await tester.pumpWidget(createWidgetUnderTest([availableChips[0]], selectedChips, multiSelect: false));

    // Verify that initially all passed selectedChips are in the selectedChips
    for(LfgChip selectedChip in selectedChips) {
      expect(find.text(selectedChip.getLabelText()), findsOneWidget);
    }

    // Find the ChipWrap widget and open the overlay
    final chipWrapFinder = find.byType(ChipWrap);
    await tester.tap(chipWrapFinder);
    await tester.pump();

    // Find the first chip in the ActionDropdownAvailableContainer (which should be different from the initialSelectedChip) and tap it
    final firstAvailableChipFinder = find.descendant(
      of: find.byType(ActionDropdownAvailableContainer),
      matching: find.byType(ChipTag),
    ).first;

    final newChipContent = (firstAvailableChipFinder.evaluate().first.widget as ChipTag).chipContent;

    await tester.tap(firstAvailableChipFinder);
    await tester.pump();

    // Verify that the initially selected chip is back in the availableChips and the new chip is now in the selectedChips
    final newSelectedChip = find.descendant(of:
    find.byType(ActionDropdownSelectedWrap),
        matching: find.text(newChipContent.getLabelText()));
    expect(newSelectedChip, findsOneWidget);

    for (LfgChip selectedChip in selectedChips) {
      final newAvailableChip = find.descendant(of:
      find.byType(ActionDropdownAvailableContainer),
          matching: find.text(selectedChip.getLabelText()), skipOffstage: false);
      expect(newAvailableChip, findsOneWidget);
    }
  });

  testWidgets('Deleting a chip in the overlay triggers onDeleteChip callback and updates internal state', (WidgetTester tester) async {
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest([availableChips[0]], selectedChips));

    final initialSelectedChip = selectedChips.first;

    // Open the overlay by tapping the ChipWrap
    final chipWrapFinder = find.byType(ChipWrap);
    await tester.tap(chipWrapFinder);
    await tester.pump();

    // Verify that there is initially a chip in the selectedChips
    expect(find.descendant(of: find.byType(ActionDropdownSelectedWrap),
        matching: find.text(initialSelectedChip.getLabelText())), findsOneWidget);
    expect(find.descendant(of: find.byType(ActionDropdownAvailableContainer),
        matching: find.text(initialSelectedChip.getLabelText())), findsNothing);

    // Find a deletable chip within the overlay's ActionDropdownSelectedWrap and delete it
    final deleteIconFinder = find.descendant(
      of: find.byType(ActionDropdownSelectedWrap),
      matching: find.byIcon(Icons.close), // Assuming Icons.close is the delete icon in ChipTag
    ).first;

    await tester.tap(deleteIconFinder);
    await tester.pump();

    // Check if onDeleteChip was called with the right chip
    verify(() => mockFunctions.onDeleteChip(initialSelectedChip)).called(1);

    // Verify that the chip is now in the list of availableChips and not in the selectedChips anymore
    expect(find.descendant(of: find.byType(ActionDropdownSelectedWrap),
        matching: find.text(initialSelectedChip.getLabelText())), findsNothing);
    expect(find.descendant(of: find.byType(ActionDropdownAvailableContainer),
        matching: find.text(initialSelectedChip.getLabelText())), findsOneWidget);

  });

  testWidgets('Adding and removing a chip updates availableChips and selectedChips correctly', (WidgetTester tester) async {
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest(availableChips.sublist(0,2), selectedChips));

    // Open the overlay by tapping the ChipWrap
    final chipWrapFinder = find.byType(ChipWrap);
    await tester.tap(chipWrapFinder);
    await tester.pump();

    // Add a chip from availableChips
    final chipToAdd = availableChips.first;
    final chipToAddFinder = find.text(chipToAdd.getLabelText()).first; // Assuming the chip's display is its label text
    await tester.tap(chipToAddFinder);
    await tester.pump();

    expect(find.descendant(of: find.byType(ActionDropdownSelectedWrap),
        matching: find.text(chipToAdd.getLabelText())), findsOneWidget);
    expect(find.descendant(of: find.byType(ActionDropdownAvailableContainer),
        matching: find.text(chipToAdd.getLabelText())), findsNothing);

    // Delete a chip from selectedChips
    final chipToDelete = selectedChips.first;
    final deleteIconFinder = find.descendant(
      of: find.byKey(Key(chipToDelete.getLabelText())),
      matching: find.byIcon(Icons.close), // Assuming Icons.close is the delete icon in ChipTag
    ).first;
    await tester.tap(deleteIconFinder);
    await tester.pump();


    expect(find.descendant(of: find.byType(ActionDropdownSelectedWrap),
        matching: find.text(chipToDelete.getLabelText())), findsNothing);
    expect(find.descendant(of: find.byType(ActionDropdownAvailableContainer),
        matching: find.text(chipToDelete.getLabelText())), findsOneWidget);
  });

  testWidgets("deselecting all selected chips should return empty list", (tester) async{
    // Load the main widget
    await tester.pumpWidget(createWidgetUnderTest(availableChips, selectedChips));

    //open the overlay
    final chipWrap = find.byType(ChipWrap);
    await tester.tap(chipWrap);
    await tester.pump();

    //deselect all selectedChips
    for (LfgChip selectedChip in selectedChips) {
      final chipTag = find.byKey(Key(selectedChip.getLabelText()));
      final deleteIcon = find.descendant(of: chipTag, matching: find.byType(IconButton));
      await tester.tap(deleteIcon);
      await tester.pump();
    }

    //close overlay
    await tester.tapAt(Offset(0, 0));
    await tester.pump();

    verify(() => mockFunctions.onCloseOverlay([])).called(1);

  });



}