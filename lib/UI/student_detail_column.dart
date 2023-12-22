
import 'dart:collection';
import 'dart:math';

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/add_book_student_detail_dialog/add_book_student_detail_dialog.dart';
import 'package:buecherteam_2023_desktop/UI/books/student_detail_book_section.dart';
import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';
import 'package:buecherteam_2023_desktop/UI/student_detail_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Data/student.dart';


/*
this widget contains the detail section for students and uses a self-sufficient
stream to update the data of the students
 */
class StudentDetailColumn extends StatelessWidget {
  const StudentDetailColumn({super.key, required this.pressedKey, required this.onFocusChanged});

  final Keyboard pressedKey;
  final Function(bool focused) onFocusChanged;

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentDetailState>(
      builder: (BuildContext context, StudentDetailState studentDetailState, _) {
        return StreamBuilder(
            stream: studentDetailState.streamStudentsDetails(
              studentDetailState.selectedStudentIdObjects
                  .map((e) => e.id)
                  .toList()
            ),
            builder: (context, change) {

              List<Student> currStudents = change.data ?? [];

              return currStudents.isEmpty
                  ? Container()
                  : Column(
                children: [
                  StudentDetailInfo(students: currStudents, onAddWarning: addWarning),

                  /*
                Here comes the tag dropdown menu
                 */

                  const SizedBox(
                    height: Dimensions.spaceMedium,
                  ),

                  Expanded(
                    child: StudentDetailBookSection(
                        pressedKey: pressedKey,
                        books: getBooks(currStudents),
                        onAddBooks: () {
                           openAddBookStudentDetailDialog(context, currStudents,
                              studentDetailState, onFocusChanged);
                        }, currStudents: currStudents,
                    ),
                  )

                ],
              );
            }
        );
      },

    );
  }

  void addWarning(List<Student> students) {

  }

  List<BookLite> getBooks(List<Student> currStudents) {
    List<BookLite> result = [];
    HashMap<BookLite, int> amountBooks = HashMap(); //track the amount of books that should be added to the result

    /*
    every student can have n books of type x.
    the student with the highest n is the amount of one book type of x that will be
    added to the result list.
    this facilitates the granular deletion of books. If n students are selected
    and one student owns one book twice you might not want to delete both books
    of this student at the same time.
    To properly reflect this in UI two separate BookCards are created in such a
    case.
     */

    for (Student student in currStudents) {
      HashMap<BookLite, int> oneStudentBookAmounts = HashMap();

      for (BookLite bookLite in student.books) {
        oneStudentBookAmounts[bookLite] = (oneStudentBookAmounts[bookLite] ?? 0) + 1; //local track of amount of book types of one student
        amountBooks[bookLite] = max(amountBooks[bookLite]??0, oneStudentBookAmounts[bookLite]!); //check new maximum of one booktype
      }

    }

    //generate the result list from the amountOfBooks Map that contains book types
    // and its respective amount
    for (MapEntry<BookLite, int> entry in amountBooks.entries) {
      result.addAll(List.generate(entry.value, (index) => entry.key));
    }

    result.sort();

    return result;
  }


}
