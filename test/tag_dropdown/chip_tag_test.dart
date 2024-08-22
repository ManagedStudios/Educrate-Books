
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';



class MockChipContentGeneral extends Mock implements LfgChip{}

class MockChipContentSubtype extends Mock implements TrainingDirectionsData{}

class MockFunction extends Mock {
  void onDelete(LfgChip chip);
}

void main () {
  late String label;
  late Color color;
  late MockFunction mockFunction;
  late MockChipContentGeneral mockChipContentGeneral;
  late MockChipContentSubtype mockChipContentSubtype;


  setUp(() {
    label = "label";
    color = Colors.white70;
    mockFunction = MockFunction();
    mockChipContentGeneral = MockChipContentGeneral();
    mockChipContentSubtype = MockChipContentSubtype();
    when(() => mockChipContentGeneral.getLabelText()).thenReturn(label);
    when(() => mockChipContentSubtype.getLabelText()).thenReturn(label);
  });

  Widget createWidgetUnderTest<T extends LfgChip>(T chipContent, bool deletable) {
        return MaterialApp(
          theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
              fontFamily: 'Helvetica Neue',
              textTheme: textTheme
          ),
          home: ChipTag(chipContent: chipContent,
              color: color,
              deletable: deletable,
              onDelete: (chip) => mockFunction.onDelete(chip))
        );
  }

  testWidgets("Renders correctly with base of T", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest<LfgChip>(mockChipContentGeneral, false));
    final text = find.text(label);
    final chipTag = find.byType(ChipTag);
    final card = find.byType(Card);
    final iconButton = find.byType(IconButton);

    expect(text, findsOneWidget);
    expect(chipTag, findsOneWidget);
    expect(card, findsOneWidget);
    expect(iconButton, findsNothing);
  });

  testWidgets("Renders correctly with subtype of T", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest<LfgChip>(mockChipContentSubtype, false));
    final text = find.text(label);
    final chipTag = find.byType(ChipTag);
    final card = find.byType(Card);
    final iconButton = find.byType(IconButton);

    expect(text, findsOneWidget);
    expect(chipTag, findsOneWidget);
    expect(card, findsOneWidget);
    expect(iconButton, findsNothing);
  });

  testWidgets("Styling correct", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(mockChipContentSubtype, false));
    final text = find.text(label);
    final card = find.byType(Card);

    final textWidget = tester.widget<Text>(text);
    final cardWidget = tester.widget<Card>(card);

    expect(textWidget.style?.fontSize, textTheme.labelSmall?.fontSize);
    expect(cardWidget.color, color);
    expect(cardWidget.shape, RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall)));
  });

  testWidgets("Icon rendered on deletable true", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest<TrainingDirectionsData>(mockChipContentSubtype, true));
    final iconButton = find.byType(IconButton);

    expect(iconButton, findsOneWidget);
  });

  testWidgets("onDelete called correctly", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest<TrainingDirectionsData>(mockChipContentSubtype, true));
    final iconButton = find.byType(IconButton);

    await tester.tap(iconButton);
    await tester.pumpAndSettle();

    verify(() => mockFunction.onDelete(mockChipContentSubtype)).called(1);
  });

  testWidgets("renders empty container if empty text", (tester) async{
    when(() => mockChipContentSubtype.getLabelText()).thenReturn("");
    await tester.pumpWidget(createWidgetUnderTest<TrainingDirectionsData>(mockChipContentSubtype, true));
    expect(find.byType(Container), findsOneWidget);
  });

}