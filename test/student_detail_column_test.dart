

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';
import 'package:buecherteam_2023_desktop/UI/student_detail_column.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockStudent extends Mock implements Student {
  MockStudent(this.books);

  @override
  final List<BookLite> books;
}

void main () {


  late BookLite book1;
  late BookLite book2 ;
  late BookLite book3;




  setUp(() {
    book1 = BookLite("123", "Green Line New 5 ", "English", 10);
    book2 = BookLite("567", "Lambacher", "Mathe", 10);
    book3 = BookLite("189", "Kollegstufen", "Ethik", 10);
  });

  Widget createWidgetUnderTest () {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
          fontFamily: 'Helvetica Neue',
          textTheme: textTheme
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => StudentDetailState(DB()))
        ],
          child: const StudentDetailColumn(pressedKey: Keyboard.nothing)),
    );
  }

  group("Test the getBooks method", () {
    testWidgets("all students have distinct list of books", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final widget = tester.widget<StudentDetailColumn>(find.byType(StudentDetailColumn));
      final students = [
        MockStudent([book1, book2]),
        MockStudent([book1]),
        MockStudent([book1, book2, book3])
      ];

      final expectedResult = [book1, book2, book3];

      expect(areListsEqualIgnoringOrder(widget.getBooks(students), expectedResult), isTrue);
    });

    testWidgets("Test with one student having multiple books of one type", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final widget = tester.widget<StudentDetailColumn>(find.byType(StudentDetailColumn));
      final students = [
        MockStudent([book1, book2, book1]),
        MockStudent([book1]),
        MockStudent([book1, book2, book3])
      ];

      final expectedResult = [book1, book1, book2, book3];

      expect(areListsEqualIgnoringOrder(widget.getBooks(students), expectedResult), isTrue);
    });

    testWidgets("Test negative example", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final widget = tester.widget<StudentDetailColumn>(find.byType(StudentDetailColumn));
      final students = [
        MockStudent([book1, book2]),
        MockStudent([book1]),
        MockStudent([book1, book2, book3])
      ];

      final expectedResult = [book1, book1, book2, book3];

      expect(areListsEqualIgnoringOrder(widget.getBooks(students), expectedResult), isFalse);
    });

    testWidgets("Test with multiple students having multiple books of one type, but same amount", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final widget = tester.widget<StudentDetailColumn>(find.byType(StudentDetailColumn));
      final students = [
        MockStudent([book1, book2, book1]),
        MockStudent([book1, book1]),
        MockStudent([book1, book2, book3])
      ];

      final expectedResult = [book1, book1, book2, book3];

      expect(areListsEqualIgnoringOrder(widget.getBooks(students), expectedResult), isTrue);
    });

    testWidgets("Test with multiple students having multiple books of one type", (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final widget = tester.widget<StudentDetailColumn>(find.byType(StudentDetailColumn));
      final students = [
        MockStudent([book1, book2, book1, book3, book3]),
        MockStudent([book1, book1, book1]),
        MockStudent([book1, book2, book3])
      ];

      final expectedResult = [book1, book1, book1, book2, book3, book3];

      expect(areListsEqualIgnoringOrder(widget.getBooks(students), expectedResult), isTrue);
    });

  });
}