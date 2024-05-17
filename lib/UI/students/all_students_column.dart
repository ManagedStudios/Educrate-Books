
import 'package:buecherteam_2023_desktop/Data/student.dart';

import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/UI/filter/filter_row.dart';

import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';
import 'package:buecherteam_2023_desktop/UI/right_click_actions/actions_overlay.dart';
import 'package:buecherteam_2023_desktop/UI/right_click_actions/delete_dialog.dart';
import 'package:buecherteam_2023_desktop/UI/searchbar.dart';
import 'package:buecherteam_2023_desktop/UI/students/student_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';
import '../all_students_column_util/all_students_dialog_builder.dart';
import '../all_students_column_util/revert_student_delete_snackbar.dart';
import '../all_students_column_util/selection_process_all_students.dart';

class AllStudentsColumn extends StatefulWidget {
  const AllStudentsColumn({super.key, required this.onFocusChanged, required this.pressedKey});

  final Function (bool searchFocused) onFocusChanged;
  final Keyboard pressedKey;

  @override
  State<AllStudentsColumn> createState() => _AllStudentsColumnState();
}

class _AllStudentsColumnState extends State<AllStudentsColumn> {

  ValueNotifier<int> amountOfFilteredStudents = ValueNotifier(0);
  String? ftsQuery;
  bool isOverlayOpen = false;

  /*
  studentAddedId and clearanceNeeded are both used to control the selected
  Students. When a new student has been added, his index is not known.
  In this case we use the id of the student and then add the index to the
  Providers studentList and studentDetail.
  ClearanceNeeded clears the selected Students of studentList and studentDetail
  to avoid memory leaks when the stream changes because of deletions or filtering.
   */
  String? studentAddedId;
  bool clearanceNeeded = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) { //right click actions
        var state = Provider.of<StudentDetailState>(context, listen: false);
        var studentListState = Provider.of<StudentListState>(context, listen: false);
        if (studentListState.selectedStudentIds.isNotEmpty && !isOverlayOpen) { //are there any students? Check StudentListState as StudentDetail can differ! Dont open an overlay twice
          setState(() {
            isOverlayOpen = true;
          });
          var overlay = ActionsOverlay(
              selectedItems: state.selectedStudentIdObjects.toList(), //make copy of selected students to avoid side effects
              width: Dimensions.widthRightClickActionMenu,
              actions: { //inflate actions
                TextRes.delete:(actions) {
                  openDeleteDialog(context, actions.map((e) => e.getDocId()!).toList(), TextRes.student);
                  clearanceNeeded = true;
                }
              },
              onOverlayClosed: () {
                setState(() {
                  isOverlayOpen = false;
                });
              },
              offset: details.globalPosition,
              context: context);
          overlay.showOverlayEntry();
        }
      },
      child: IgnorePointer( //avoid unexpected tap behavior when overlay is opened
        ignoring: isOverlayOpen,
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: ValueListenableBuilder(
                        valueListenable: amountOfFilteredStudents,
                        builder: (context, value, _) =>
                            LfgSearchbar(onChangeText: (text) {
                              searchForStudents(text);
                            },
                                amountOfFilteredItems: amountOfFilteredStudents.value,
                                amountType: TextRes.student,
                              onFocusChange: (searched) {
                              widget.onFocusChanged(searched);
                              clearanceNeeded = true; //when searching delete selection
                              },

                              onTap: () {

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

                FilterRow(),

                StreamBuilder(
                    stream: Provider.of<StudentListState>(context, listen: false)
                        .streamStudents(ftsQuery, null),
                    builder: (context, change) {
                      if (change.hasData &&
                          change.data!.length != amountOfFilteredStudents.value) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          amountOfFilteredStudents.value = change.data!.length;
                          //reset selection to initial state: no students selected
                          if(clearanceNeeded) {
                            clearanceNeeded = false;
                            studentAddedId = null;
                            clearSelectedStudents(context);
                          }
                        });
                      }

                  final int dataLength = change.data?.length ?? 0;

                      return Expanded(child: ListView.builder(
                        itemCount: dataLength,
                        itemBuilder: (context, index) {
                          return Consumer<StudentListState>(
                            builder: (context, state, _) {
                              return StudentCard(change.data![index],
                                  isSelected( //method that checks if student is selected
                                      studentListState: state,
                                      studentDetailState:
                                      Provider.of<StudentDetailState>(
                                          context, listen: false),
                                      index: index,
                                      students: change.data!,
                                      studentId: studentAddedId
                                  ),
                                  setClickedStudent: (student) {
                                    if (studentAddedId !=
                                        null) clearStudentAddedId();
                                    selectStudents(
                                        pressedKey: widget.pressedKey,
                                        studentListState: state,
                                        studentDetailState:
                                        Provider.of<StudentDetailState>(
                                            context, listen: false),
                                        index: index,
                                        students: change.data!);
                                  },
                                  notifyDetailPage: (student) => {}, //dead code
                                  onDeleteStudent: (student) {
                                    clearanceNeeded = true;
                                    Provider.of<StudentListState>(
                                        context, listen: false)
                                        .deleteStudent(student);
                                    showRevertStudentDeleteSnackBar(student, //make action reversible
                                        Provider.of<StudentListState>(
                                            context, listen: false),
                                        context);
                                  },
                                  openEditDialog: (student) {
                                    updateStudent(student, context);
                                  });
                            },
                          );
                        }
                      )
                      );
                    }),
                      const SizedBox(height: Dimensions.spaceSmall,)
              ],
            ),
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
          widget.onFocusChanged(false); //turn on cmd/shift after leaving dialog
        if (value == null) return;
      //parse all student details passed from the altertDialog
      final String firstName = value[0] as String;
      final String lastName = value[1] as String;
      final int classLevel = value[2] as int;
      final String classChar = value[3] as String;
      final List<String> trainingDirections = value[4] as List<String>;

      //save the student to db
      String id = await studentListState.saveStudent(firstName, lastName, classLevel,
          classChar, trainingDirections);
      studentAddedId = id; //do not use setState to avoid race conditions betweens stream changes and setState changes
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


  void updateStudent(Student student, BuildContext context) {
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
    ).then((value) async {
      if(value == null) return;
      String id = await studentListState.updateStudent(value);
      widget.onFocusChanged(false); //turn on keyboard for cmd/shift
      studentAddedId = id; // do not use setState to avoid race conditions with stream changes
    });
  }

  bool isSelected({required StudentListState studentListState,
    required StudentDetailState studentDetailState,
    required int index, required List<Student> students, String? studentId}) {

    //firstly check if a new student has been added to clear former selection if required
    if(studentId != null && students[index].id == studentId) { //student recently added
      /*
      if new student has been added then select this student immediately
       */
      SchedulerBinding.instance.addPostFrameCallback((_) { //use postFrame to enable notifying
        studentListState.clearSelectedStudents();
        studentDetailState.clearSelectedStudents();
        studentListState.addSelectedStudent(index);
        studentDetailState.addSelectedStudent(students[index]);
        studentAddedId = null;
      });

      return true;
    }

    //then the normal check via studentListState if student has been selected
    if (studentListState.selectedStudentIds.contains(index)) return true;

    return false;
  }

  void clearStudentAddedId() {
    studentAddedId = null;
  }

  void clearSelectedStudents(BuildContext context) {
    Provider.of<StudentListState>(context, listen: false)
        .clearSelectedStudents();
    Provider.of<StudentDetailState>(context, listen: false)
        .clearSelectedStudents();
  }

}
