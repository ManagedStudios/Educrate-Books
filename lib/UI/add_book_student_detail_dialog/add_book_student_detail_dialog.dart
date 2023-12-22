

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/UI/add_book_student_detail_dialog/add_book_student_detail_dialog_content.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Data/student.dart';
import '../../Resources/text.dart';

void openAddBookStudentDetailDialog (
    BuildContext context,
    List<Student> selectedStudents,
    StudentDetailState studentDetailState,
    Function(bool focused) onFocusChanged) {

  showDialog<List<BookLite>>(context: context, builder: (context) {
    double dialogWidth =
    MediaQuery.of(context).size.width*0.5>500?MediaQuery.of(context).size.width*0.5:500;
    double dialogHeight =
        MediaQuery.of(context).size.height*0.7;
    List<BookLite> checkedBooks = [];
    return AlertDialog(
      content: SizedBox(
        height: dialogHeight,
        width: dialogWidth,
        child: AddBookStudentDetailDialogContent(
            onFocusChanged: onFocusChanged,
            onAddSelectedBook: (book) => checkedBooks.add(book),
            onRemoveSelectedBook: (book) => checkedBooks.remove(book),
        ),
      ),
      actions: [
        FilledButton(onPressed: () {
          context.pop(checkedBooks);
        }, child: const Text(
            TextRes.addBooks
          )
        )
      ],
    );
  }).then((books) async{
    if(books != null) {
      await Provider.of<StudentDetailState>(context, listen: false)
          .addBooksToStudent(books, selectedStudents);
    }

  });
}