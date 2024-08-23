


import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/navigation/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunction extends Mock {
  void onClickButton();
}
void main () {
  late MockFunction mockFunction;
  late String text;

  setUp(() {
    mockFunction = MockFunction();
    text = "NavTest";
  });

  Widget createWidgetUnderTest (Key key, bool isClicked) {
      return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            fontFamily: 'Helvetica Neue',
            textTheme: textTheme,
          ),
        home: NavigationButton(
          key: key,
          isClicked: isClicked,
          onClickAction: mockFunction.onClickButton,
          text: text,
        ),
      );
  }

  testWidgets("Test if widget renders correct and initial values are true", (tester) async{
    Key key = UniqueKey();
    await tester.pumpWidget(createWidgetUnderTest(key, false));
    var button = find.byType(OutlinedButton);
    var text = find.byType(Text);
    expect(button, findsOneWidget);
    expect(text, findsOneWidget);
    final OutlinedButton outlineButton = tester.firstWidget(button);
    final Text buttonText = tester.firstWidget(text);
    expect(outlineButton.style?.fixedSize?.resolve({})?.width, Dimensions.navButtonWidthNotClicked);
    expect(outlineButton.style?.backgroundColor?.resolve({}), Colors.transparent);
    expect(outlineButton.style?.side?.resolve({})?.width, 1);
    expect(outlineButton.style?.side?.resolve({})?.color, lightColorScheme.outline);
    expect(buttonText.style?.color, lightColorScheme.onSurface);
  });

  testWidgets("Test if animation starts when isClicked true", (tester) async {
    Key key = UniqueKey();
    await tester.pumpWidget(createWidgetUnderTest(key, true));
    await tester.pumpAndSettle(const Duration(milliseconds: 260));

    var button = find.byType(OutlinedButton);
    var text = find.byType(Text);
    expect(button, findsOneWidget);
    expect(text, findsOneWidget);
    final OutlinedButton outlineButton = tester.firstWidget(button);
    final Text buttonText = tester.firstWidget(text);
    expect(outlineButton.style?.fixedSize?.resolve({})?.width, Dimensions.navButtonWidthClicked);
    expect(outlineButton.style?.backgroundColor?.resolve({}), lightColorScheme.primary);
    expect(outlineButton.style?.side?.resolve({})?.width, 0);
    expect(buttonText.style?.color, lightColorScheme.onPrimary);
  });

  testWidgets("Test if reverse animation works", (tester) async{
    Key key = UniqueKey();
    await tester.pumpWidget(createWidgetUnderTest(key, true));
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    await tester.pumpWidget(createWidgetUnderTest(key, false));
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    var button = find.byType(OutlinedButton);
    var text = find.byType(Text);
    expect(button, findsOneWidget);
    expect(text, findsOneWidget);
    final OutlinedButton outlineButton = tester.firstWidget(button);
    final Text buttonText = tester.firstWidget(text);
    expect(outlineButton.style?.fixedSize?.resolve({})?.width, Dimensions.navButtonWidthNotClicked);
    expect(outlineButton.style?.backgroundColor?.resolve({}), Colors.transparent);
    expect(outlineButton.style?.side?.resolve({})?.width, 1);
    expect(outlineButton.style?.side?.resolve({})?.color, lightColorScheme.outline);
    expect(buttonText.style?.color, lightColorScheme.onSurface);
  });

  testWidgets("test if config changes with same values trigger animation", (tester) async{
    Key key = UniqueKey();
    await tester.pumpWidget(createWidgetUnderTest(key, true));
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    await tester.pumpWidget(createWidgetUnderTest(key, true));
    await tester.pumpAndSettle(const Duration(milliseconds: 30));

    var button = find.byType(OutlinedButton);
    var text = find.byType(Text);
    expect(button, findsOneWidget);
    expect(text, findsOneWidget);
    final OutlinedButton outlineButton = tester.firstWidget(button);
    final Text buttonText = tester.firstWidget(text);
    expect(outlineButton.style?.fixedSize?.resolve({})?.width, Dimensions.navButtonWidthClicked);
    expect(outlineButton.style?.backgroundColor?.resolve({}), lightColorScheme.primary);
    expect(outlineButton.style?.side?.resolve({})?.width, 0);
    expect(buttonText.style?.color, lightColorScheme.onPrimary);

  });
  
  testWidgets("test if onClick is triggered", (tester) async{
    Key key = UniqueKey();
    await tester.pumpWidget(createWidgetUnderTest(key, false));
    final button = find.byKey(key);
    await tester.tap(button);
    await tester.pumpAndSettle();
    verify(() => mockFunction.onClickButton()).called(1);
  });

 }