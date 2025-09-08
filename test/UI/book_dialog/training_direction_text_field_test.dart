

import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/book_dialog/training_direction_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onChangedText(String text);
}


void main () {

  late MockFunctions mockFunctions;
  late TextEditingController controller;
  late String errorText;
  late String hint;

  setUp(() {
    mockFunctions = MockFunctions();
    controller = TextEditingController();
    errorText = TextRes.trainingDirectionsNameError;
    hint = TextRes.classLevelHint;

  });
  Widget createWidgetUnderTest (String? errorText,
      String hint,  {Key? key}) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme
        ),
        home: Row(
          children: [
            Expanded(
              child: Card(
                child: TrainingDirectionTextField(
                  controller: controller,
                  errorText: errorText,
                  hint: hint,
                  onTextChanged: mockFunctions.onChangedText),
              ),
            ),
          ]
        )
    );
  }

  testWidgets("Error text is shown", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(errorText, hint));
    expect(find.text(errorText), findsOneWidget);
  });

  testWidgets("Error text is updated", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(errorText, hint));
    await tester.pumpWidget(createWidgetUnderTest(null, hint));
    expect(find.text(errorText), findsNothing);
  });

  testWidgets("Correct callbacks", (tester) async {
    String someText = "fjwoioffwo";
    await tester.pumpWidget(createWidgetUnderTest(errorText, hint));
    await tester.enterText(find.byType(TextField), someText);
    await tester.pumpAndSettle();
    verify(() => mockFunctions.onChangedText(someText.toUpperCase())).called(1);
  });

  testWidgets("text is updated correctly", (tester) async {
    String someText = "fjwoioffwo";
    await tester.pumpWidget(createWidgetUnderTest(errorText, hint));
    await tester.enterText(find.byType(TextField), someText);
    await tester.pumpAndSettle();
    expect(find.text(someText.toUpperCase()), findsOneWidget);
  });

  testWidgets("changing the text of the controller outside changes the textField text", (tester) async {
    String someText = "fjwoioffwo";
    await tester.pumpWidget(createWidgetUnderTest(errorText, hint));
    await tester.enterText(find.byType(TextField), someText);
    await tester.pumpAndSettle();
    expect(find.text(someText.toUpperCase()), findsOneWidget);

    String newText = "newText";
    controller.text = newText;
    await tester.pump();

    expect(find.text(newText), findsOneWidget);
  });


}