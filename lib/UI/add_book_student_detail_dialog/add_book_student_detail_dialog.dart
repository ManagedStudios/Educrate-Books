

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';

import 'package:buecherteam_2023_desktop/UI/add_book_student_detail_dialog/add_book_student_detail_list.dart';
import 'package:flutter/material.dart';

import '../../Data/student.dart';

void openAddBookStudentDetailDialog (
    BuildContext context,
    List<Student> selectedStudents) {

  showDialog(context: context, builder: (context) {
    double dialogWidth =
    MediaQuery.of(context).size.width*0.5>500?MediaQuery.of(context).size.width*0.5:500;
    double dialogHeight =
        MediaQuery.of(context).size.height*0.7;
    return AlertDialog(
      content: SizedBox(
        height: dialogHeight,
        width: dialogWidth,
        child: AddBookStudentDetailList(books: [BookLite("_bookId", "Green Line", "English", 10)]),
      ),
    );
  });
}