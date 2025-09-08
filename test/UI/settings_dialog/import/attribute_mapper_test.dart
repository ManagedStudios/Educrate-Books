import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/Data/settings/student_excel_mapper_attributes.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import/attribute_mapper.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/tag_dropdown/chip_wrap.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/tag_dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions<T extends LfgChip> extends Mock {
  void onItemSelected(T? item);
}

void main() {
  late ExcelData excelDataKey;

  setUp(() {
    excelDataKey = ExcelData(row: 1, column: 1, content: "Test Excel Data");
  });

  Widget createWidgetUnderTest<T extends LfgChip>({
    required MockFunctions<T> mockFunctions,
    required List<T> availableAttributes,
    T? selectedAttribute,
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
          child: AttributeMapper<T>(
            excelDataKey: excelDataKey,
            availableAttributes: availableAttributes,
            selectedAttribute: selectedAttribute,
            width: width*0.5,
            onItemSelected: mockFunctions.onItemSelected,
          ),
        ),
      ),
    );
  }


  testWidgets(
      'AttributeMapper displays Excel data, equals sign, and dropdown correctly', (
      WidgetTester tester) async {
    MockFunctions<TrainingDirectionsData> mockFunctions = MockFunctions();
    List<TrainingDirectionsData> av = List.generate(
        5, (i) => TrainingDirectionsData("nr: $i"));

    await tester.pumpWidget(createWidgetUnderTest<TrainingDirectionsData>(
        availableAttributes: av,
        mockFunctions: mockFunctions
    ));

    // Verify that the Excel data is displayed
    expect(find.text('Test Excel Data'), findsOneWidget);

    // Verify that the equals sign is displayed
    expect(find.text('='), findsOneWidget);

    // Verify that the dropdown is displayed
    expect(find.byType(Dropdown<TrainingDirectionsData>), findsOneWidget);
  });

  testWidgets('Selecting an TrainingDirections item from the dropdown triggers onItemSelected', (WidgetTester tester) async {

    MockFunctions<TrainingDirectionsData> mockFunctions = MockFunctions();
    List<TrainingDirectionsData> av = List.generate(
        5, (i) => TrainingDirectionsData("nr: $i"));

    await tester.pumpWidget(createWidgetUnderTest<TrainingDirectionsData>(
      availableAttributes: av,
      mockFunctions: mockFunctions
    ));

    // Find and tap the dropdown to open it
    final dropdownFinder = find.byType(Dropdown<TrainingDirectionsData>);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Verify that the dropdown menu opens with options
    final optionFinder = find.text('nr: 0').first;
    expect(optionFinder, findsOneWidget);

    // Select an option from the dropdown
    await tester.tap(optionFinder);
    await tester.pumpAndSettle();

    // Verify that the onItemSelected callback was called with the correct attribute
    verify(() => mockFunctions.onItemSelected(av[0])).called(1);
  });

  testWidgets('Selecting an StudentAttr item from the dropdown triggers onItemSelected', (WidgetTester tester) async {

    MockFunctions<StudentAttributes> mockFunctions = MockFunctions();
    List<StudentAttributes> av = StudentAttributes.values;

    await tester.pumpWidget(createWidgetUnderTest<StudentAttributes>(
        availableAttributes: av,
        mockFunctions: mockFunctions
    ));

    // Find and tap the dropdown to open it
    final dropdownFinder = find.byType(Dropdown<StudentAttributes>);
    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // Verify that the dropdown menu opens with options
    final optionFinder = find.text(av[0].getLabelText()).first;
    expect(optionFinder, findsOneWidget);

    // Select an option from the dropdown
    await tester.tap(optionFinder);
    await tester.pumpAndSettle();

    // Verify that the onItemSelected callback was called with the correct attribute
    verify(() => mockFunctions.onItemSelected(av[0])).called(1);
  });

  testWidgets('AttributeMapper handles empty availableAttributes list', (WidgetTester tester) async {

    MockFunctions<StudentAttributes> mockFunctions = MockFunctions();

    await tester.pumpWidget(createWidgetUnderTest<StudentAttributes>
      (
        availableAttributes: <StudentAttributes>[],
        mockFunctions: mockFunctions
    ));

    // Verify that the dropdown is still displayed but with no options
    expect(find.byType(Dropdown<StudentAttributes>), findsOneWidget);

    final dropdown = find.byType(Dropdown<StudentAttributes>);
    await tester.tap(dropdown);

    expect(find.byType(ChipWrap<StudentAttributes>), findsNothing); // Assuming the Dropdown widget shows a placeholder when empty
  });

  testWidgets('AttributeMapper displays predefined selected attribute correctly', (WidgetTester tester) async {

    MockFunctions<StudentAttributes> mockFunctions = MockFunctions();
    List<StudentAttributes> av = StudentAttributes.values;

    final predefinedAttribute = av.first;

    await tester.pumpWidget(createWidgetUnderTest<StudentAttributes>
      (
        mockFunctions: mockFunctions,
        availableAttributes: av,
        selectedAttribute: predefinedAttribute
      )
    );

    // Verify that the predefined selected attribute is shown in the dropdown
    expect(find.text(predefinedAttribute.getLabelText()), findsOneWidget); // Assuming label is a property of LfgChip
  });

  testWidgets('onItemSelected is not called on initialization', (WidgetTester tester) async {

    MockFunctions<StudentAttributes> mockFunctions = MockFunctions();
    List<StudentAttributes> av = StudentAttributes.values;

    await tester.pumpWidget(createWidgetUnderTest<StudentAttributes>(
      mockFunctions: mockFunctions,
      availableAttributes: av
    ));

    // Verify that onItemSelected was not called during initialization
    for (StudentAttributes studentAttribute in StudentAttributes.values) {
      verifyNever(() => mockFunctions.onItemSelected(studentAttribute));
    }

  });




}