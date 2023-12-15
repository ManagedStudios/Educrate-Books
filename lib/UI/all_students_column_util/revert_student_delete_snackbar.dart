/*
  showSnackbar is used to undo a delete of a student
   */

import 'package:flutter/material.dart';

import '../../Data/student.dart';
import '../../Models/studentListState.dart';
import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';

void showSnackBar(Student student, StudentListState studentListState,
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