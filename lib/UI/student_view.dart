
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/UI/student_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentView extends StatelessWidget {
  static String routeName = '/studentView';

  const StudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FilledButton(onPressed: () => Provider.of<StudentListState>(context, listen: false).saveStudent("Tom", "Arbogast", 11, "Q", ["ETH-LAT-11, BASIC-11"]),
              child: Text("Add Student")),
          StreamBuilder(stream: Provider.of<StudentListState>(context, listen: false).streamStudents(null, null),
              builder: (context, change) {
                return Expanded(child: ListView(
                  children: [
                    for (Student student in change.data??[])
                      StudentCard(student, false, key: Key(student.id), setClickedStudent: (student)=>{}, notifyDetailPage: (student) => {},
                          openDeleteDialog: (student) => Provider.of<StudentListState>(context, listen: false).deleteStudent(student),
                          openEditDialog: (student) => {})
                  ],
                )
                );
              })
        ],
      ),
    );
  }
}
