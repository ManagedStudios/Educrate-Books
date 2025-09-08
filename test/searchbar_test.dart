

import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunction extends Mock {
  void onChangeText(String text);
}

void main () {

  late MockFunction mockFunction;
  late int amountOfFilteredStudents;

  setUp(() {
    mockFunction = MockFunction();
    amountOfFilteredStudents = 0;
  });

  Widget createWidgetUnderTest () {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          fontFamily: 'Helvetica Neue',
          textTheme: textTheme
      ),
      home: LfgSearchbar(
        onChangeText: mockFunction.onChangeText,
        amountOfFilteredItems: amountOfFilteredStudents,
        amountType: TextRes.student,
        onFocusChange: (bool focused) {  },
        onTap: () {  },

      ),
    );
  }

  testWidgets("Test if widget renders correctly", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(LfgSearchbar), findsOneWidget);
  });

  testWidgets("Test if onChangeText is triggered when typing", (tester) async{
    String typedValue = "hello";
    await tester.pumpWidget(createWidgetUnderTest());
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, typedValue);
    await tester.pumpAndSettle();
    verify(() => mockFunction.onChangeText(typedValue)).called(1);
  });

  testWidgets("Test if amount of Students is displayed", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text("$amountOfFilteredStudents ${TextRes.student}"), findsOneWidget);
  });
  
  testWidgets("Searchbar is cleared on enter", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest());

    final Finder finderTextField = find.byType(TextField);

    // Simulate typing into the TextField
    await tester.enterText(finderTextField, "John");
    await tester.pump();

    expect(find.text("John"), findsOneWidget);
    
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    
    expect(find.text(""), findsOneWidget);
    
  });

}