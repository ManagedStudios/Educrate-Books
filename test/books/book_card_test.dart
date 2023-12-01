
import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFunctions extends Mock {
  void onClick(BookLite bookLite);
  void onDelete(BookLite bookLite);
}
void main () {
  late MockFunctions mockFunctions;
  late BookLite bookLite;
  late BookLite book;

  setUp(() {
    mockFunctions = MockFunctions();
    bookLite = BookLite("_bookId", "Green Line New 5", "Englisch", 10);
    book = Book(bookId: "bookId", name: "Lambacher", subject: "subject", classLevel: 8, trainingDirection: [], expectedAmountNeeded: 100, nowAvailable: 290, totalAvailable: 91);
  });

  Widget createWidgetUnderTest(bool isClicked, int? studentOwnerNum,
      int? bookAmount, bool isDeletable, BookLite book1
      ) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          fontFamily: 'Helvetica Neue',
          textTheme: textTheme
      ),
      home: BookCard(clicked: isClicked, onClick: mockFunctions.onClick,
          onDeleteBook: mockFunctions.onDelete,
          bookLite: book1,
          studentOwnerNum: studentOwnerNum,
          isDeletable: isDeletable,
          bookAvailableAmount: bookAmount),
    );
  }

  group("Widget tests", () {
    testWidgets("Student_detail book card correctly shown without amount",
            (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(false, null, null, true, bookLite)
      );

      await tester.pump();

      expect(find.text(bookLite.name), findsOneWidget);
      expect(find.text("${bookLite.subject} ${bookLite.classLevel}  "), findsOneWidget);

      expect(find.byIcon(Icons.close), findsOneWidget);

            });

    testWidgets("test clickChange", (tester) async {

      var widget = createWidgetUnderTest(false, null, null, true, bookLite);

      await tester.pumpWidget(widget);

      expect(find.byWidgetPredicate((widget) =>
          widget is Card
          && widget.shape is RoundedRectangleBorder
          && (widget.shape as RoundedRectangleBorder).side == BorderSide.none),
      findsOneWidget);

      widget = createWidgetUnderTest(true, null, null, true, bookLite);

      await tester.pumpWidget(widget);

      expect(find.byWidgetPredicate((widget) =>
      widget is Card
      && widget.shape is RoundedRectangleBorder
      && (widget.shape as RoundedRectangleBorder).side ==
          const BorderSide(width: Dimensions.borderWidthMedium)),
          findsOneWidget);

    });

    testWidgets("Test with all parameters enabled ", (tester) async {
      var widget = createWidgetUnderTest(true, 10, 8, true, book);
      await tester.pumpWidget(widget);

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text("| 8"), findsNothing);
      expect(find.text("10 | "), findsOneWidget);
    });

    testWidgets("test click", (tester) async {
      var widget = createWidgetUnderTest(true, 10, 8, true, book);
      await tester.pumpWidget(widget);

      await tester.tap(find.byType(Card));
      await tester.pump();

      verify(() => mockFunctions.onClick(book)).called(1);
    });

    testWidgets("test delete", (tester) async {
      var widget = createWidgetUnderTest(true, 10, 8, true, book);
      await tester.pumpWidget(widget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      verify(() => mockFunctions.onDelete(book)).called(1);
    });

  });
}