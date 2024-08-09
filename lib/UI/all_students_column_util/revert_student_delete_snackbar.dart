/*
  showSnackbar is used to undo a delete of a student
   */

import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:flutter/material.dart';


import '../../Data/student.dart';
import '../../Models/studentListState.dart';
import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';
import '../../Util/lfg_snackbar.dart';

void showRevertStudentDeleteSnackBar(Student student, StudentListState studentListState,
    StudentDetailState studentDetailState,
    BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          "${student.firstName} ${student.lastName} ${TextRes.wasDeleted}"),
        action: SnackBarAction(label: TextRes.undo,
            onPressed: () => //save the student passed from the deletion process
            studentListState
                .saveStudent(
                student.firstName, student.lastName, student.classLevel,
                student.classChar, student.trainingDirections,
                onAddBooksToStudent: (books, student) {
                  studentDetailState
                      .addBooksToStudent(books??[],
                      [student], (message) {
                        showLFGSnackbar(context, message);
                      }
                  );
                },
                books: student.books, tags: student.tags)),
        margin: const EdgeInsets.only(left: Dimensions.largeMargin,
            right: Dimensions.largeMargin,
            bottom: Dimensions.minMarginStudentView
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.cornerRadiusSmall))),
        padding: const EdgeInsets.all(Dimensions.paddingMedium),
      )
  );
}