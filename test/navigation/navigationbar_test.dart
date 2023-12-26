
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/book_depot_view.dart';
import 'package:buecherteam_2023_desktop/UI/book_stack_view.dart';
import 'package:buecherteam_2023_desktop/UI/navigation/navigation_button.dart';
import 'package:buecherteam_2023_desktop/UI/student_view.dart';
import 'package:buecherteam_2023_desktop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main () {

  Widget createWidgetUnderTest () {
    final _router = GoRouter(
        initialLocation: StudentView.routeName,
        routes: [
          ShellRoute(builder: (BuildContext context, GoRouterState state, Widget child) {
            return Homepage(child: child);
          },routes: [
            GoRoute(path: StudentView.routeName,
                pageBuilder: (context, state) => CustomTransitionPage(
                    child: Container(),
                    transitionsBuilder: (context, animation, _, child) {
                      return FadeTransition(
                          opacity:
                          CurveTween(curve: Curves.easeInCirc).animate(animation),
                          child: child);
                    })
            ),
            GoRoute(path: BookDepotView.routeName,
                pageBuilder: (context, state) => CustomTransitionPage(
                    child:  Container(),
                    transitionsBuilder: (context, animation, _, child) {
                      return FadeTransition(
                          opacity:
                          CurveTween(curve: Curves.easeInCirc).animate(animation),
                          child: child);
                    })
            ),
            GoRoute(path: BookStackView.routeName,
                pageBuilder: (context, state) => CustomTransitionPage(
                    child: Container(),
                    transitionsBuilder: (context, animation, _, child) {
                      return FadeTransition(
                          opacity:
                          CurveTween(curve: Curves.easeInCirc).animate(animation),
                          child: child);
                    })
            )
          ])
        ]);
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        fontFamily: 'Helvetica Neue',
        textTheme: textTheme,
      ),
      routerConfig: _router,
    );
  }

  testWidgets("test if rendered correctly and initial states", (tester) async{
   await tester.pumpWidget(createWidgetUnderTest());
   await tester.pumpAndSettle(const Duration(milliseconds: 260));
   final studentButton = find.byKey(const Key(TextRes.student));
   final bookButton = find.byKey(const Key(TextRes.books));
   expect(studentButton, findsOneWidget);
   expect(bookButton, findsOneWidget);

   final NavigationButton studentNavButton = tester.widget(studentButton);
   final NavigationButton bookNavButton = tester.widget(bookButton);
   expect(studentNavButton.isClicked, true);
   expect(bookNavButton.isClicked, false);

  });

  testWidgets("test if switching buttons works", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    final studentButton = find.byKey(const Key(TextRes.student));
    final bookButton = find.byKey(const Key(TextRes.books));
    await tester.tap(bookButton);
    await tester.pumpAndSettle();
    final NavigationButton studentNavButton = tester.widget(studentButton);
    final NavigationButton bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, false);
    expect(bookNavButton.isClicked, true);

  });

  testWidgets("test if tapping the same buttons changes something", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    final studentButton = find.byKey(const Key(TextRes.student));
    final bookButton = find.byKey(const Key(TextRes.books));
    await tester.tap(studentButton);
    await tester.pumpAndSettle();
    final NavigationButton studentNavButton = tester.widget(studentButton);
    final NavigationButton bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, true);
    expect(bookNavButton.isClicked, false);

  });

  testWidgets("test if some switches in a row work", (tester) async{
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(const Duration(milliseconds: 260));

    final studentButton = find.byKey(const Key(TextRes.student));
    final bookButton = find.byKey(const Key(TextRes.books));

    NavigationButton studentNavButton = tester.widget(studentButton);
    NavigationButton bookNavButton = tester.widget(bookButton);

    await tester.tap(bookButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    studentNavButton = tester.widget(studentButton);
    bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, false);
    expect(bookNavButton.isClicked, true);

    await tester.tap(studentButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    studentNavButton = tester.widget(studentButton);
    bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, true);
    expect(bookNavButton.isClicked, false);

    await tester.tap(bookButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    studentNavButton = tester.widget(studentButton);
    bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, false);
    expect(bookNavButton.isClicked, true);

    await tester.tap(studentButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    studentNavButton = tester.widget(studentButton);
    bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, true);
    expect(bookNavButton.isClicked, false);

    await tester.tap(studentButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 260));
    studentNavButton = tester.widget(studentButton);
    bookNavButton = tester.widget(bookButton);
    expect(studentNavButton.isClicked, true);
    expect(bookNavButton.isClicked, false);

  });





}