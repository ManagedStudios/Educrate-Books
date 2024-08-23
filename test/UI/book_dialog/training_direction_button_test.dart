import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onClick();
}

void main () {
  late MockFunctions mockFunctions;

  setUp(() {
    mockFunctions = MockFunctions();
  });

  Widget createWidgetUnderTest (bool isClicked) {
     return MaterialApp(
      theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          fontFamily: 'Helvetica Neue',
          textTheme: textTheme
      ),
      home: TrainingDirectionButton(
          text: "text",
          isClicked: isClicked,
          onClick: mockFunctions.onClick),
    );
  }

  testWidgets("OnClick callback test", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(false));

    await tester.tap(find.byType(TrainingDirectionButton));

    verify(() => mockFunctions.onClick()).called(1);
  });
  
  testWidgets("Color changes when isClicked turns from false to true", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(false));

    Set<WidgetState> states = <WidgetState>{};
    final button = tester.widget<OutlinedButton>(find.descendant(of: find.byType(TrainingDirectionButton),
        matching: find.byType(OutlinedButton)));
    Color? color = button.style?.backgroundColor?.resolve(states);

    await tester.pumpWidget(createWidgetUnderTest(true));

    final newButton = tester.widget<OutlinedButton>(find.descendant(of: find.byType(TrainingDirectionButton),
        matching: find.byType(OutlinedButton)));
    Color? newColor = newButton.style?.backgroundColor?.resolve(states);

    expect(color?.value!= newColor?.value, isTrue);
    
  });
}