
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/keys.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_available_container.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunction extends Mock {
  void onAddChip(LfgChip chip);
}

void main () {
  late List<LfgChip> availableChips;
  late MockFunction mockFunction;

  setUp(() {
    mockFunction = MockFunction();
    String str = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod";
    availableChips = str.split(" ").map((e) => TrainingDirectionsData(e, 0)).toList();

  });

  Widget createWidgetUnderTest(List<LfgChip> avChips, {double width = 400, String? hintText}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: ActionDropdownAvailableContainer(availableChips: avChips,
            onAddChip: mockFunction.onAddChip, width: width, hintText: hintText,)
    );
  }

  testWidgets('SizedBox inside Card respects Dimensions.overlayHeight', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(availableChips));

    final sizedBox = tester.widget<SizedBox>(find.byKey(Key(Keys.ActionDropdownAvailableContainerSizedBoxKey)));
    expect(sizedBox.height, Dimensions.overlayHeight);
  });

  testWidgets('Card has proper shape, color, and margin properties', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(availableChips));
    final card = tester.widget<Card>(find.byKey(Key(Keys.ActionDropdownAvailableCardKey)));
    // Check shape of the Card
    final shape = card.shape as RoundedRectangleBorder;
    expect(
      shape.borderRadius,
      const BorderRadius.only(
        bottomLeft: Radius.circular(Dimensions.cornerRadiusSmall),
        bottomRight: Radius.circular(Dimensions.cornerRadiusSmall),
      ),
    );
    // Check color of the Card
    final cardColor = Theme.of(tester.element(find.byKey(Key(Keys.ActionDropdownAvailableCardKey)))).colorScheme.surface;
    expect(card.surfaceTintColor, cardColor);
    // Check margin of the Card
    expect(card.margin, const EdgeInsets.only(top: 0));
  });

  testWidgets('ListView is present and scrollable when availableChips list is long enough', (WidgetTester tester) async {
    // Ensure a long list of availableChips to make the ListView scrollable
    final longList = List.generate(100, (index) => availableChips[0]); // Duplicating the first LfgChip for simplicity
    await tester.pumpWidget(createWidgetUnderTest(longList));
    // Ensure ListView is present
    expect(find.byType(ListView), findsOneWidget);
    // Find an item in the ListView to check its position
    final listViewItemFinder = find.byType(ChipWrap).first;
    final initialOffset = tester.getTopLeft(listViewItemFinder);
    // Attempt to scroll the ListView
    await tester.drag(find.byType(ListView), const Offset(0, -300)); // Try dragging upward by 300 pixels
    await tester.pumpAndSettle();
    final afterDragOffset = tester.getTopLeft(listViewItemFinder);
    expect(initialOffset.dy, greaterThan(afterDragOffset.dy)); // Check if content inside ListView scrolled upwards
  });

  testWidgets('hintText renders correctly when provided', (WidgetTester tester) async {
    const testHintText = 'Test hint text';

    await tester.pumpWidget(createWidgetUnderTest(availableChips, hintText: testHintText));

    // Verify hintText is present
    expect(find.text(testHintText), findsOneWidget);
  });

  testWidgets('Tapping ChipWrap triggers onAddChip with correct LfgChip', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(availableChips));
    // Assume you want to tap the first chip
    final chipToTap = availableChips.first;
    // Tap on the first ChipWrap
    await tester.tap(find.byType(ChipWrap).first);
    await tester.pump();
    // Verify that onAddChip was called with the correct chip
    verify(() => mockFunction.onAddChip(chipToTap)).called(1);
  });

  testWidgets('Widget behaves correctly with an empty list of LfgChip', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest([])); // Passing empty list

    // Verify that no ChipWrap is present
    expect(find.byType(ChipWrap), findsNothing);

    // If there are any specific behaviors or UI elements that should appear
    // when the list is empty (like a placeholder text or an icon),
    // you can check for their presence here.
    // Example: expect(find.text('No chips available'), findsOneWidget);
  });

  testWidgets('Very long hintText does not break layout', (WidgetTester tester) async {
    const longHintText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
        'Vestibulum sed urna eget velit euismod tincidunt. Mauris venenatis accumsan ex, '
        'at vehicula turpis auctor nec. Praesent quis nunc quis elit aliquet aliquam. '
        'Aliquam erat volutpat. Sed quis elit at nunc feugiat efficitur.';

    await tester.pumpWidget(createWidgetUnderTest(availableChips, hintText: longHintText));

    // Check for any overflow errors in the layout
    expect(tester.takeException(), isNull);

    // Optionally, check if the very long hintText is present in the widget tree
    expect(find.text(longHintText), findsOneWidget);
  });



}