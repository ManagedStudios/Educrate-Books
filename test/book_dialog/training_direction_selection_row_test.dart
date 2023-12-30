




import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_selection_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onBasicClicked();
  void onSubjectClicked(String text);
}

void main () {
  late MockFunctions mockFunctions;


  setUp(() {
    mockFunctions = MockFunctions();

  });

  Widget createWidgetUnderTest (String currSubjectText, int currClass,
      bool isBasicClicked, bool isSubjectClicked, {Key? key}) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          fontFamily: 'Helvetica Neue',
          textTheme: textTheme
      ),
      home: TrainingDirectionSelectionRow(
          key: key,
          onBasicClicked: mockFunctions.onBasicClicked,
          onSubjectClicked: mockFunctions.onSubjectClicked,
          currSubjectText: currSubjectText,
          currClass: currClass,
          isBasicClicked: isBasicClicked,
          isSubjectClicked: isSubjectClicked)
    );
  }

  testWidgets("Test Error is shown when no button is clicked", (tester) async {



    await tester.pumpWidget(createWidgetUnderTest("currSubjectText", 0, false, false));

    expect(find.text(TextRes.trainingDirectionSelectionRowError), findsOneWidget);

  });

  testWidgets("Test Button click callbacks", (tester) async {

    String subject = "currSubejct";
    await tester.pumpWidget(createWidgetUnderTest(subject, 0, false, false));

    await tester.tap(find.text(TextRes.basicTrainingDirection));
    verify(() => mockFunctions.onBasicClicked()).called(1);

    await tester.tap(find.text(subject));
    verify(() => mockFunctions.onSubjectClicked(subject)).called(1);


  });

  testWidgets("error is not shown when initialized like so", (tester) async {

    String subject = "currSubejct";

    await tester.pumpWidget(createWidgetUnderTest(subject, 0, true, false));
    await tester.pump();

    expect(find.text(TextRes.trainingDirectionSelectionRowError), findsNothing);

  });

  testWidgets("error disappears when button is clicked", (tester) async {

    String subject = "currSubejct";

    await tester.pumpWidget(createWidgetUnderTest(subject, 0, false, false));

    await tester.tap(find.text(TextRes.basicTrainingDirection));
    await tester.pump();

    expect(find.text(TextRes.trainingDirectionSelectionRowError), findsNothing);

  });

  testWidgets("text and class updates", (tester) async{
    String subject = "c";
    int currClass = 0;

    await tester.pumpWidget(createWidgetUnderTest(subject, currClass, false, false));
    expect(find.text(currClass.toString()), findsOneWidget);
    expect(find.text(subject), findsOneWidget);

    subject = "cjow";
    currClass = 4;
    await tester.pumpWidget(createWidgetUnderTest(subject, currClass, false, false));
    expect(find.text(currClass.toString()), findsOneWidget);
    expect(find.text(subject), findsOneWidget);
  });

}