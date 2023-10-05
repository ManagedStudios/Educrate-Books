

import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/UI/student_dialog/student_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Resources/text.dart';

class StudentDialog extends StatefulWidget {
  const StudentDialog({super.key, required this.title, required this.classes,
    required this.actionText, required this.trainingDirections, this.student,
    required this.loading});

  final Student? student;

  final String title;
  final List<ClassData> classes;
  final String actionText;

  final bool loading;


  final List<TrainingDirectionsData> trainingDirections;

  @override
  State<StudentDialog> createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {

  String? firstNameError;
  String? lastNameError;
  String? classError;

  String? studentId;
  String studentFirstName = "";
  String studentLastName = "";
  int? studentClassLevel;
  String? studentClassChar;
  List<String>? studentTrainingDirections;

  @override
  void initState() {
    super.initState();
    studentId = widget.student?.id;
    studentFirstName = widget.student?.firstName ?? "";
    studentLastName = widget.student?.lastName ?? "";
    studentClassLevel = widget.student?.classLevel;
    studentClassChar = widget.student?.classChar;
    studentTrainingDirections = widget.student?.trainingDirections;
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title,
      style: Theme.of(context).textTheme.labelMedium,
      ),
      content: StudentDialogContent(classes: widget.classes,
          onStudentClassUpdated: onStudentClassUpdated,
        trainingDirections: widget.trainingDirections,
        onStudentTrainingDirectionsUpdated: onTrainingDirectionsUpdated,
        firstNameError: firstNameError,
        onFirstNameChanged: onFirstNameChanged,
        lastNameError: lastNameError,
        onLastNameChanged: onLastNameChanged,
        classError: classError,
        student: widget.student, loading: widget.loading,
      ),
      actions: [
        FilledButton.tonal(onPressed:(){
          context.pop();
        }, child: const Text(
            TextRes.cancel
          )
        ),
        FilledButton(onPressed: () {
          if(isDataValid()) {
            if(studentId != null) { //update student
              context.pop(Student(studentId!,
                  firstName: studentFirstName, lastName: studentLastName,
                  classLevel: studentClassLevel!, classChar: studentClassChar!,
                  trainingDirections: studentTrainingDirections!,
                  books: widget.student!.books,
                  amountOfBooks: widget.student!.amountOfBooks
                )
              );
            } else { //create new student
              /*
              IMPORTANT: When refactor make sure to update the receiver of the pop method!
               */
              context.pop([
                studentFirstName,
                studentLastName,
                studentClassLevel!,
                studentClassChar!,
                studentTrainingDirections??[]
              ]);
            }
          }
        },
            child: Text(widget.actionText))
      ],
    );
  }

  void onStudentClassUpdated(ClassData? classData) {
    if(classData != null) {
      setState(() {
        classError = null;
      });
      studentClassLevel = classData.classLevel;
      studentClassChar = classData.classChar;
    }

  }

  void onTrainingDirectionsUpdated (List<TrainingDirectionsData> trainingDirections) {
      studentTrainingDirections =
          trainingDirections.map((e) => e.getLabelText()).toList();
  }

  void onFirstNameChanged(String firstName) {
    if(firstName.isNotEmpty) {
      setState(() {
        firstNameError = null;
      });
    }
    studentFirstName = firstName;
  }

  void onLastNameChanged(String lastName) {
    if(lastName.isNotEmpty) {
      setState(() {
        lastNameError = null;
      });
    }
    studentLastName = lastName;
  }

  bool isDataValid () { //only one & to trigger all methods
    return isFirstNameValid(studentFirstName)
        &isLastNameValid(studentLastName)
        &isClassDataValid(studentClassLevel, studentClassChar);
  }

  bool isFirstNameValid(String firstName) {
    if(firstName.isNotEmpty) {
      return true;
    } else {
      setState(() {
        firstNameError = TextRes.firstNameError;
      });
      return false;
    }
  }

  bool isLastNameValid(String lastName) {
    if(lastName.isNotEmpty) {
      return true;
    } else {
      setState(() {
        lastNameError = TextRes.lastNameError;
      });
      return false;
    }
  }

  bool isClassDataValid(int? classLevel, String? classChar) {
    if(classLevel != null && classChar != null) {
      return true;
    } else {
      setState(() {
        classError = TextRes.classError;
      });
      return false;
    }
  }


}
