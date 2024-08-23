

import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';

import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_tag.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockFunction extends Mock{
  void onClickChipRow(List<LfgChip> chips);
}

void main () {
  late List<LfgChip> chips;
  late double width;
  late List<String> labels;
  late MockFunction mockFunction;


  setUp(() {
    String lorem = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
    labels = lorem.split(" ");
    chips = [];
    for (int i = 0; i<labels.length; i++){
      chips.add(TrainingDirectionsData(labels[i]));
    }

    mockFunction = MockFunction();

  });

  Widget createWidgetUnderTest (List<LfgChip> listChip, {double w = 400, Color? color}) {
    width = w;
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: ChipWrap(chips: listChip,
            onClickChipRow: mockFunction.onClickChipRow,
            width: width, color: color,)
    );
  }

  testWidgets("test if everything renders correctly with normal amount of chips", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(chips.sublist(0, 5)));
    expect(find.byType(ChipWrap), findsOneWidget);
    expect(find.byType(ChipTag), findsNWidgets(5));
  });

  testWidgets("test if onClick is triggered", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(chips.sublist(0, 5)));
    await tester.tap(find.byType(TextButton));
    verify(() => mockFunction.onClickChipRow(chips.sublist(0, 5))).called(1);
  });

  testWidgets("test if empty wrap shows hint text", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest([]));
    expect(find.text(TextRes.addChipsHint), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets("test if everything renders correctly with a lot of chips", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(chips));
    expect(find.byType(ChipWrap), findsOneWidget);
    expect(find.byType(ChipTag), findsNWidgets(chips.length));
  });


}