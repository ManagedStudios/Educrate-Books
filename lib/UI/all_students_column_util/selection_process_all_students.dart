import '../../Data/student.dart';
import '../../Models/studentListState.dart';
import '../../Models/student_detail_state.dart';
import '../keyboard_listener/keyboard_listener.dart';

void selectStudents(
    {required Keyboard pressedKey,
    required StudentListState studentListState,
    required StudentDetailState studentDetailState,
    required int index,
    required List<Student> students}) {
  /*
    depending on the pressed keys cmd/shift/nothing the selection behavior differs.
    The selection behavior is similar to Finder/Explorer.
     */
  switch (pressedKey) {
    case Keyboard.nothing:
      {
        //select only one student
        studentListState.clearSelectedStudents();
        studentListState.addSelectedStudent(index);

        studentDetailState.clearSelectedStudents();
        studentDetailState.addSelectedStudent(students[index]);
      }
    case Keyboard.cmd:
      {
        //add or remove student from selection

        if (studentListState.selectedStudentIds.contains(index)) {
          studentListState.removeSelectedStudent(index);
          studentDetailState.removeSelectedStudent(students[index]);
        } else {
          studentListState.addSelectedStudent(index);
          studentDetailState.addSelectedStudent(students[index]);
        }
      }
    case Keyboard.shift:
      {
        //select all intermediary options of students.

        if (studentListState.selectedStudentIds.isEmpty) {
          for (int i = 0; i <= index; i++) {
            studentListState.addSelectedStudent(i);
            studentDetailState.addSelectedStudent(students[i]);
          }
          return;
        }

        if (index > studentListState.selectedStudentIds.last) {
          for (int i = studentListState.selectedStudentIds.last + 1;
              i <= index;
              i++) {
            studentListState.addSelectedStudent(i);
            studentDetailState.addSelectedStudent(students[i]);
          }
        } else if (index < studentListState.selectedStudentIds.first) {
          for (int i = studentListState.selectedStudentIds.first - 1;
              i >= index;
              i--) {
            studentListState.addSelectedStudent(i);
            studentDetailState.addSelectedStudent(students[i]);
          }
        } else {
          for (int i = studentListState.selectedStudentIds.first + 1;
              i <= index;
              i++) {
            studentListState.addSelectedStudent(i);
            studentDetailState.addSelectedStudent(students[i]);
          }
        }
      }
  }
}
