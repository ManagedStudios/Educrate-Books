
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_add_section.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockFunctions extends Mock {
  void onTrainingDirectionsUpdated (List<TrainingDirectionsData?> trainingDirections);
}
void main () {

  late MockFunctions mockFunctions;
  late int? currClass1;
  late int? currClass2;
  late int? currClassError;
  late String currSubject1;
  late String currSubject2;
  late String currSubjectEmpty;
  late List<TrainingDirectionsData?> initialTrainingDirections;

  setUp(() {
    mockFunctions = MockFunctions();
    currClass1 = 7;
    currClass2 = 9;
    currClassError = null;
    currSubject1 = "subejct";
    currSubject2 = "Mathe";
    currSubjectEmpty = "  ";
    initialTrainingDirections = [
      TrainingDirectionsData("$currSubject2${TextRes.trainingDirectionHyphen}$currClass1"),
      TrainingDirectionsData("$currSubject1${TextRes.trainingDirectionHyphen}$currClass2")
    ];
  });


  Widget createWidgetUnderTest (int? currClass,
      String currSubject,  {Key? key, List<TrainingDirectionsData?>? initialTrainingDirections}) {
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
                  child: TrainingDirectionAddSection(
                      currClass: currClass,
                      currSubject: currSubject,
                      onTrainingDirectionUpdated: mockFunctions.onTrainingDirectionsUpdated,
                      initialTrainingDirections: initialTrainingDirections,)
                ),
              ),
            ]
        )
    );
  }

  testWidgets("Test onTrainingDirectionUpdated call with selectionRow only", (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(currClass1, currSubject1));

    await tester.tap(find.text(currSubject1));
    await tester.pump();

    verify(() => mockFunctions.onTrainingDirectionsUpdated([TrainingDirectionsData(
      "$currSubject1${TextRes.trainingDirectionHyphen}$currClass1"
    )]
    )
    ).called(1);
  });

  testWidgets("onTrainingDirectionUpdated with incorrect creationRow", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest(currClass1, currSubject1));

    await tester.tap(find.text(currSubject1));
    verify(() => mockFunctions.onTrainingDirectionsUpdated([TrainingDirectionsData(
        "$currSubject1${TextRes.trainingDirectionHyphen}$currClass1"
    )])).called(1);
    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();

    verify(() => mockFunctions.onTrainingDirectionsUpdated([TrainingDirectionsData(
        "$currSubject1${TextRes.trainingDirectionHyphen}$currClass1"
    ), null])).called(1);
  });


  testWidgets("onTrainingDirectionUpdated with incorrect SelectionRow", (tester)  async {
    await tester.pumpWidget(createWidgetUnderTest(currClass1, currSubject1));

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    verify(() => mockFunctions.onTrainingDirectionsUpdated([null, null])).called(1);
    await tester.pump();
    await tester.enterText(find.ancestor(
        of: find.text(TextRes.trainingDirectionsNameError),
        matching: find.byType(TextField)), currSubject2);
    verify(() => mockFunctions.onTrainingDirectionsUpdated([null, null])).called(1);
    await tester.enterText(find.ancestor(
        of: find.text(TextRes.classLevelError),
        matching: find.byType(TextField)), currClass1.toString());
    await tester.pump();
    var captured = verify(() => mockFunctions.onTrainingDirectionsUpdated(captureAny())).captured.single as List<TrainingDirectionsData?>;
    List<TrainingDirectionsData?> res = [null, TrainingDirectionsData("$currSubject2${TextRes.trainingDirectionHyphen}$currClass1")];
    for (int i = 0; i<res.length; i++) {
      expect(captured[i]?.label, (res[i]?.label)?.toUpperCase());
    }

  });

  testWidgets("inititalTrainingDirections rendered", (tester)  async {
    await tester.pumpWidget(createWidgetUnderTest(currClass1, currSubject2,
        initialTrainingDirections: initialTrainingDirections));

    for(var t in initialTrainingDirections) {
      List<String> splitted = t!.label.split(TextRes.trainingDirectionHyphen);
      expect(find.text(splitted[0]), findsOneWidget);
      expect(find.text(splitted[1]), findsOneWidget);
    }

  });

  testWidgets("deletetion of initialTrainingDirection works", (tester)  async {
    await tester.pumpWidget(createWidgetUnderTest(currClass1, currSubject2,
        initialTrainingDirections: initialTrainingDirections));

    for(var t in initialTrainingDirections) {
      List<String> splitted = t!.label.split(TextRes.trainingDirectionHyphen);
      expect(find.text(splitted[0]), findsOneWidget);
      expect(find.text(splitted[1]), findsOneWidget);
    }

  });

}