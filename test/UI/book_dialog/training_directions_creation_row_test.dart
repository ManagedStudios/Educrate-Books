
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_creation_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onEveryInputChange (String changes);
  void onTrainingDirectionChanged(TrainingDirectionsData? update);
  void onDeleteTrainingDirection ();
}

void main () {

  late MockFunctions mockFunctions;
  late String currTrainingDirection1;
  late String currTrainingDirection2;
  late String currClassLevel1;
  late String currClassLevel2;
  late String currTrainingDirectionEmpty;
  late String currClassLevelError;
  late String currTrainingDirectionWhiteSpace;
  late String currClassLevelWhiteSpace;

  setUp(() {
    mockFunctions = MockFunctions();
    currTrainingDirection1 = "ETH";
    currTrainingDirection2 = "BASIC";
    currClassLevel1 = "10";
    currClassLevel2 = "9";
    currTrainingDirectionEmpty = "   ";
    currClassLevelError = "fjei";
    currTrainingDirectionWhiteSpace = "   ETH";
    currClassLevelWhiteSpace = "5    ";
  });

  Widget createWidgetUnderTest (
      String currTrainingDirection, String currClassLevel, {Key? key}) {
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
                  child: TrainingDirectionCreationRow(
                      onEveryInputChange: mockFunctions.onEveryInputChange,
                      onDeleteTrainingDirection: mockFunctions.onDeleteTrainingDirection,
                      currTrainingDirection: currTrainingDirection,
                      currClassLevel: currClassLevel,
                      onTrainingDirectionChanged: mockFunctions.onTrainingDirectionChanged),
                )
              ),
            ]
        )
    );
  }

  testWidgets("shows error when initial trainingDirection is empty ", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevel2));

    expect(find.text(TextRes.classLevelError), findsNothing);
    expect(find.text(TextRes.trainingDirectionsNameError), findsOneWidget);
  });

  testWidgets("shows error when initial class is incorrect", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirection2, currClassLevelError));

    expect(find.text(TextRes.classLevelError), findsOneWidget);
    expect(find.text(TextRes.trainingDirectionsNameError), findsNothing);
  });

  testWidgets("shows errors when initial class is incorrect and currTrainingDirection is empty", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    expect(find.text(TextRes.classLevelError), findsOneWidget);
    expect(find.text(TextRes.trainingDirectionsNameError), findsOneWidget);
  });

  testWidgets("errors are updated when correct text is entered", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    expect(find.text(TextRes.classLevelError), findsOneWidget);
    expect(find.text(TextRes.trainingDirectionsNameError), findsOneWidget);

    /*
    enter text into the trainingDirection textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currTrainingDirection1);
    await tester.pump();
    expect(find.text(currTrainingDirection1), findsOneWidget);
    expect(find.text(TextRes.trainingDirectionsNameError), findsNothing);

    /*
    enter text into the classLevel textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClassLevel1);
    await tester.pump();

    expect(find.text(currClassLevel1), findsOneWidget);
    expect(find.text(TextRes.classLevelError), findsNothing);
  });

  testWidgets("correct onEveryUpdate callbacks", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    /*
    enter text into the trainingDirection textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currTrainingDirection1);
    await tester.pump();
    verify(() => mockFunctions.onEveryInputChange("$currTrainingDirection1${TextRes.trainingDirectionHyphen}$currClassLevelError")).called(1);

    /*
    enter text into the classLevel textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClassLevel1);
    await tester.pump();
    verify(() => mockFunctions.onEveryInputChange("$currTrainingDirection1${TextRes.trainingDirectionHyphen}$currClassLevel1")).called(1);
  });

  testWidgets("onEveryUpdate callbacks with whitespace trainingDirections and classLevels", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    /*
    enter text into the trainingDirection textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currTrainingDirectionWhiteSpace);
    await tester.pump();
    verify(() => mockFunctions.onEveryInputChange("$currTrainingDirectionWhiteSpace${TextRes.trainingDirectionHyphen}$currClassLevelError")).called(1);

    /*
    enter text into the classLevel textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClassLevelWhiteSpace);
    await tester.pump();
    verify(() => mockFunctions.onEveryInputChange("$currTrainingDirectionWhiteSpace${TextRes.trainingDirectionHyphen}$currClassLevelWhiteSpace")).called(1);
  });

  testWidgets("onTrainingDirectionUpdated callback correctly called", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    /*
    enter text into the trainingDirection textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currTrainingDirection1);
    await tester.pump();
    verify(() => mockFunctions.onTrainingDirectionChanged(null)).called(1);

    /*
    enter text into the classLevel textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClassLevel1);
    await tester.pump();
    verify(() => mockFunctions.onTrainingDirectionChanged(TrainingDirectionsData(
      "$currTrainingDirection1${TextRes.trainingDirectionHyphen}$currClassLevel1"
    )
    )
    ).called(1);
  });

  testWidgets("show error when textField wrong again", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    /*
    enter text into the trainingDirection textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currTrainingDirection1);
    await tester.pump();

    /*
    enter text into the classLevel textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClassLevel1);
    await tester.pump();

    expect(find.text(TextRes.trainingDirectionsNameError), findsNothing);
    expect(find.text(TextRes.classLevelError), findsNothing);

    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelHint),
        matching: find.byType(TextField)), currClassLevelError);
    await tester.pump();

    expect(find.text(TextRes.classLevelError), findsOneWidget);

    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionLabelInput),
        matching: find.byType(TextField)), currTrainingDirectionEmpty);
    await tester.pump();

    expect(find.text(TextRes.trainingDirectionsNameError), findsOneWidget);
  });

  testWidgets("onTrainingDirection Update null callback when trainingDirection wrong again", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));
    /*
    enter text into the trainingDirection textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currTrainingDirection1);
    await tester.pump();

    verify(() => mockFunctions.onTrainingDirectionChanged(null)).called(1);

    /*
    enter text into the classLevel textField
     */
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClassLevel1);
    await tester.pump();

    verify(() => mockFunctions.onTrainingDirectionChanged(
      TrainingDirectionsData(
        "$currTrainingDirection1${TextRes.trainingDirectionHyphen}$currClassLevel1"
      )
    )).called(1);
    await tester.enterText(find.ancestor(of: find.text(TextRes.classLevelHint),
        matching: find.byType(TextField)), currClassLevelError);
    await tester.pump();
    verify(() => mockFunctions.onTrainingDirectionChanged(null)).called(1);
  });

  testWidgets("textFields update when class and trainingDirection is updated by parent", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirectionEmpty, currClassLevelError));

    await tester.pumpWidget(createWidgetUnderTest(currTrainingDirection1, currClassLevel2));

    expect(find.text(currTrainingDirection1), findsOneWidget);
    expect(find.text(currClassLevel2), findsOneWidget);
  });




}