


import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';
import 'package:buecherteam_2023_desktop/UI/searchbar.dart';
import 'package:buecherteam_2023_desktop/UI/student_card.dart';
import 'package:buecherteam_2023_desktop/UI/student_dialog/student_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../Resources/dimensions.dart';
import '../Resources/text.dart';

class AllStudentsColumn extends StatefulWidget {
  const AllStudentsColumn({super.key});

  @override
  State<AllStudentsColumn> createState() => _AllStudentsColumnState();
}

class _AllStudentsColumnState extends State<AllStudentsColumn> {

  ValueNotifier<int> amountOfFilteredStudents = ValueNotifier(0);
  String? ftsQuery;
  Keyboard pressedKey = Keyboard.nothing;

  late FocusNode focusLFGKeyboard;

  @override
  void initState () {
    super.initState();
    focusLFGKeyboard = FocusNode();
    focusLFGKeyboard.requestFocus();
  }
  @override
  Widget build(BuildContext context) {
    return LFGKeyboard(
      changePress: (Keyboard pressed) {
        pressedKey = pressed;
      },
      focus: focusLFGKeyboard,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: ValueListenableBuilder(
                    valueListenable: amountOfFilteredStudents,
                    builder: (context, value, _) =>
                        LfgSearchbar(onChangeText: (text) {
                          Provider.of<StudentListState>(context, listen: false)
                              .clearSelectedStudents();
                          searchForStudents(text);
                        },
                            amountOfFilteredStudents: amountOfFilteredStudents.value,
                          onFocusChange: (focused) {
                          if (!focused) {
                            focusLFGKeyboard.requestFocus();
                            }
                          },
                        )
                )
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSmall),
                  child: IconButton(onPressed: () {
                    addStudent(context);
                  }, icon: const Icon(
                    Icons.person_add_alt,
                    size: Dimensions.iconSizeVeryBig,),
                    tooltip: TextRes.addStudentTitle,
                  ),
                )
              ],
            ),

            /*
            FILTER ROW INSERT HERE
             */

            StreamBuilder(
                stream: Provider.of<StudentListState>(context, listen: false)
                    .streamStudents(ftsQuery, null),
                builder: (context, change) {
                  if (change.hasData &&
                      change.data!.length != amountOfFilteredStudents.value) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      amountOfFilteredStudents.value = change.data!.length;
                    });
                  }
                  final int dataLength = change.data?.length ?? 0;
                  return Expanded(child: ListView(
                    children: [
                      for (int index = 0; index<dataLength; index++)
                        ...[
                          Consumer<StudentListState>(
                            builder: (context, state, _) {
                              return StudentCard(change.data![index],
                                  state.selectedStudentIds.contains(index),
                                  setClickedStudent: (student) {
                                    selectStudents(pressedKey, state, index);
                                  },
                                  notifyDetailPage: (student) => {},
                                  onDeleteStudent: (student) {
                                    Provider.of<StudentListState>(context, listen: false)
                                        .deleteStudent(student);
                                    showSnackBar(student);
                                  },
                                  openEditDialog: (student) {
                                    updateStudent(student);
                                  });
                            },
                          ),

                          const SizedBox(height: Dimensions.spaceSmall,)
                        ]

                    ],
                  )
                  );
                })
          ],
        ),
    );
  } //END OF WIDGET

  /*
  show Dialog to add Students
   */

  void addStudent(BuildContext context) {
    final studentListState = Provider.of<StudentListState>(
        context, listen: false);
    showDialog<List<Object?>>(context: context, barrierDismissible: false,
        builder: (context) {
          return studentDialogFutureBuilder(
              studentListState: studentListState,
              title: TextRes.addStudentTitle,
              actionText: TextRes.saveActionText);
        }).then((List<Object?>? value) async {
        if (value == null) return;
      //parse all student details passed from the altertDialog
      final String firstName = value[0] as String;
      final String lastName = value[1] as String;
      final int classLevel = value[2] as int;
      final String classChar = value[3] as String;
      final List<String> trainingDirections = value[4] as List<String>;

      //save the student to db
      await studentListState.saveStudent(firstName, lastName, classLevel,
          classChar, trainingDirections);
    });
  }


  void searchForStudents(String text) {
    if (text == "") {
      setState(() {
        ftsQuery = null;
      });
    } else {
      List<String> parts = text
          .replaceAll("*",
          "") //"*" can lead to crashes of couchbase lite since it is a command
          .trim() //delete all whitespace to avoid "word AND  *" queries leading to crashes
          .split(RegExp(
          r'(?<=[0-9])(?=[A-Za-z])|\s+')); //use a regex to split up words and classLevel from classChar
      final query = '${parts.join(' AND ')}*';
      setState(() {
        ftsQuery = query;
      });
    }
  }

  /*
  showSnackbar is used to undo a delete of a student
   */

  void showSnackBar(Student student) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            "${student.firstName} ${student.lastName} ${TextRes.wasDeleted}"),
          action: SnackBarAction(label: TextRes.undo,
              onPressed: () => //save the student passed from the deletion process
              Provider.of<StudentListState>(context, listen: false)
                  .saveStudent(
                  student.firstName, student.lastName, student.classLevel,
                  student.classChar, student.trainingDirections,
                  books: student.books)),
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

  void updateStudent(Student student) {
    final studentListState = Provider.of<StudentListState>(
        context, listen: false);
    showDialog<Student?>(context: context, barrierDismissible: false,
        builder: (context) {
          return studentDialogFutureBuilder(
              studentListState: studentListState,
              title: "${student.firstName} ${student.lastName} ${TextRes.updateTitle}",
              actionText: TextRes.updateActionText,
              student: student);
        }
    ).then((value) {
      if(value == null) return;
      studentListState.updateStudent(value);
    });
  }

  Widget studentDialogFutureBuilder({
    required StudentListState studentListState,
    required String title,
    required String actionText,
    Student? student,
  }) {
    return FutureBuilder(
      future: Future.wait([
        studentListState.getAllClasses(),
        studentListState.getAllTrainingDirections()
      ]),
      initialData: const [[], []],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List<dynamic> rawClassList = snapshot.data?[0] ?? [];
          List<ClassData> classList = rawClassList.map((e) => e as ClassData)
              .toList();

          List<dynamic> rawTrainingDirectionsList = snapshot.data?[1] ?? [];
          List<TrainingDirectionsData> trainingDirectionsList =
          rawTrainingDirectionsList.map((e) => e as TrainingDirectionsData)
              .toList();

          return StudentDialog(
            key: UniqueKey(),
            title: title,
            classes: classList,
            actionText: actionText,
            trainingDirections: trainingDirectionsList,
            loading: false,
            student: student,
          );
        } else {
          return StudentDialog(
            key: UniqueKey(),
            title: title,
            classes: const [],
            actionText: actionText,
            trainingDirections: const [],
            loading: true,
          );
        }
      },
    );
  }


  void selectStudents (Keyboard pressedKey, StudentListState state, int index) {
    /*
    depending on the pressed keys cmd/shift/nothing the selection behavior differs.
    The selection behavior is similar to Finder/Explorer.
     */
    switch(pressedKey) {
      case Keyboard.nothing : { //select only one student
        state.clearSelectedStudents();
        state.addSelectedStudent(index);
      }
      case Keyboard.cmd : { //add or remove student from selection
        if(state.selectedStudentIds.contains(index)) {
          state.removeSelectedStudent(index);
        } else {
          state.addSelectedStudent(index);
        }
      }
      case Keyboard.shift : { //select all intermediary options of students.
        if(index>state.selectedStudentIds.last) {
          for (int i = state.selectedStudentIds.last+1; i<=index; i++) {
            state.addSelectedStudent(i);
          }
        } else {
          for (int i = state.selectedStudentIds.first-1; i>=index; i--) {
            state.addSelectedStudent(i);
          }
        }
      }
    }
  }

}
