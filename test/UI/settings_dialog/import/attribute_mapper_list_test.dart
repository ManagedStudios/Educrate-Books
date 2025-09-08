import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import/attribute_mapper.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import/attribute_mapper_list.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/tag_dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions<T extends LfgChip> extends Mock {
  void onUpdatedMap(Map<ExcelData, T?> updatedItems);
}

void main() {
  late List<TrainingDirectionsData> availableDropdownItems;
  late Map<ExcelData, TrainingDirectionsData?> initialMap;
  late MockFunctions<TrainingDirectionsData> mockFunctions;

  setUp(() {
    mockFunctions = MockFunctions<TrainingDirectionsData>();

    // Define some sample ExcelData keys and corresponding TrainingDirectionsData items
    availableDropdownItems = List.generate(
      5,
          (i) => TrainingDirectionsData("Attribute $i"),
    );

    initialMap = {
      ExcelData(row: 1, column: 1, content: "Cell 1"): null,
      ExcelData(
          row: 2, column: 1, content: "Cell 2"): availableDropdownItems[1],
      ExcelData(
          row: 3, column: 1, content: "Cell 3"): availableDropdownItems[2],
    };
  });

  Widget createWidgetUnderTest({
    required Map<ExcelData, TrainingDirectionsData?> initialMap,
    required MockFunctions<TrainingDirectionsData> mockFunctions,
    double width = 400,
  }) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        fontFamily: 'Helvetica Neue',
        textTheme: textTheme,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: AttributeMapperList<TrainingDirectionsData>(
            availableDropdownItems: availableDropdownItems,
            initialMap: initialMap,
            onUpdatedMap: mockFunctions.onUpdatedMap,
            width: width * 0.7,
          ),
        ),
      ),
    );
  }

  testWidgets('AttributeMapperList displays all AttributeMappers correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      initialMap: initialMap,
      mockFunctions: mockFunctions,
    ));

    // Verify that all the AttributeMapper widgets are displayed
    expect(find.byType(AttributeMapper<TrainingDirectionsData>), findsNWidgets(initialMap.length));

    // Verify that ExcelData content is correctly displayed
    expect(find.text('Cell 1'), findsOneWidget);
    expect(find.text('Cell 2'), findsOneWidget);
    expect(find.text('Cell 3'), findsOneWidget);

    // Verify that the correct selected attributes are displayed in the dropdowns
    expect(find.text('Attribute 1'), findsOneWidget);
    expect(find.text('Attribute 2'), findsOneWidget);
  });

  testWidgets('Selecting an attribute triggers onUpdatedMap with updated map', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      initialMap: initialMap,
      mockFunctions: mockFunctions,
    ));

    // Find and tap the dropdown of the first AttributeMapper (corresponding to "Cell 1")
    final dropdownFinder = find.byType(Dropdown<TrainingDirectionsData>).first;
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Tap on the first available attribute in the dropdown
    final optionFinder = find.text('Attribute 0').first;
    await tester.tap(optionFinder);
    await tester.pumpAndSettle();

    // Verify that onUpdatedMap is called with the correct updated map
    Map<ExcelData, TrainingDirectionsData?> expectedMap = {
      ExcelData(row: 1, column: 1, content: "Cell 1"): availableDropdownItems[0],
      ExcelData(row: 2, column: 1, content: "Cell 2"): availableDropdownItems[1],
      ExcelData(row: 3, column: 1, content: "Cell 3"): availableDropdownItems[2],
    };

    verify(() => mockFunctions.onUpdatedMap(expectedMap)).called(1);
  });

  testWidgets('AttributeMapperList handles empty initial map correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      initialMap: {},
      mockFunctions: mockFunctions,
    ));

    // Verify that no AttributeMapper widgets are displayed
    expect(find.byType(AttributeMapper<TrainingDirectionsData>), findsNothing);

    // Verify that onUpdatedMap is not called since there's nothing to update
    verifyNever(() => mockFunctions.onUpdatedMap(any()));
  });

  testWidgets('AttributeMapperList handles a large number of entries in a ListView correctly', (WidgetTester tester) async {
    final largeInitialMap = Map<ExcelData, TrainingDirectionsData?>.fromIterable(
      List.generate(100, (i) => i),
      key: (i) => ExcelData(row: i, column: 1, content: "Cell $i"),
      value: (i) => null,
    );

    await tester.pumpWidget(createWidgetUnderTest(
      initialMap: largeInitialMap,
      mockFunctions: mockFunctions,
    ));

    // Initially, only a few items will be rendered due to lazy loading in ListView
    expect(find.byType(AttributeMapper<TrainingDirectionsData>), findsWidgets);

    // Scroll down the ListView to render more items
    final listViewFinder = find.byType(ListView);
    await tester.drag(listViewFinder, const Offset(0, -1000)); // scroll down
    await tester.pumpAndSettle();

    // Check if more AttributeMapper widgets are now visible
    expect(find.byType(AttributeMapper<TrainingDirectionsData>), findsWidgets);

    // Scroll all the way down to ensure the last item is rendered
    await tester.fling(listViewFinder, const Offset(0, -5000), 10000);
    await tester.pumpAndSettle();

    // Verify the last item ("Cell 99") is rendered
    expect(find.text('Cell 99'), findsOneWidget);
  });








}
