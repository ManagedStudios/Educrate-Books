import 'dart:math';

import 'package:buecherteam_2023_desktop/UI/students/all_students_column.dart';

import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';
import 'package:buecherteam_2023_desktop/UI/student_detail/student_detail_column.dart';

import 'package:flutter/material.dart';

import '../Data/book.dart';
import '../Resources/dimensions.dart';

class StudentView extends StatefulWidget {
  static String routeName = '/studentView';

  const StudentView({super.key, required this.filterBook});

  final Book? filterBook;

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  late FocusNode lfgKeyboardFocus;
  late Keyboard pressedKey;

  @override
  void initState() {
    super.initState();
    lfgKeyboardFocus = FocusNode();
    lfgKeyboardFocus.requestFocus();
    pressedKey = Keyboard.nothing;
    if (widget.filterBook != null) {
      print(widget.filterBook!.subject);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    /*
    use sigmoid function for a smooth margin/space transitioning
     */
    final double marginWidth = mediaQuery.width *
        (0.03 + 0.07 / (1 + pow(2.71, -0.005 * (mediaQuery.width - 1150))));
    final double space = mediaQuery.width *
        (0.02 + 0.05 / (1 + pow(2.71, -0.005 * (mediaQuery.width - 1150))));
    return LFGKeyboard(
      focus: lfgKeyboardFocus,
      changePress: (Keyboard pressed) {
        setState(() {
          pressedKey = pressed;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingVeryBig),
        child: Row(
          children: [
            SizedBox(
              width: marginWidth,
            ),
            Expanded(
                child: AllStudentsColumn(
              onFocusChanged: (searchFocused) {
                if (!searchFocused) {
                  lfgKeyboardFocus.requestFocus();
                }
              },
              pressedKey: pressedKey,
            )),
            SizedBox(width: space),
            Container(
              width: Dimensions.lineWidth,
              height: MediaQuery.of(context).size.height * 0.7,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(width: space),
            Expanded(
                child: StudentDetailColumn(
              pressedKey: pressedKey,
              onFocusChanged: (focused) {
                if (!focused) {
                  lfgKeyboardFocus.requestFocus();
                }
              },
            )), //studentDetail
            SizedBox(
              width: marginWidth,
            )
          ],
        ),
      ),
    );
  }
}
