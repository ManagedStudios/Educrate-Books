
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/UI/searchbar.dart';
import 'package:buecherteam_2023_desktop/UI/student_card.dart';
import 'package:buecherteam_2023_desktop/UI/student_dialog/student_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Resources/dimensions.dart';
import '../Resources/text.dart';

class AllStudentsColumn extends StatelessWidget {
  const AllStudentsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: LfgSearchbar(onChangeText: (_){}, amountOfFilteredStudents: 12)),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSmall),
              child: IconButton(onPressed: (){
                addStudent(context);
              }, icon: const Icon(
                Icons.person_add_alt,
                size: Dimensions.iconSizeVeryBig,)
              ),
            )
          ],
        ),

        /*
        FILTER ROW INSERT HERE
         */

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
    );
  }

  void addStudent(BuildContext context) {
    final studentListState = Provider.of<StudentListState>(context, listen: false);
    showDialog<List<Object?>>(context: context, barrierDismissible: false,
        builder: (context) {
      return FutureBuilder(
        future: Future.wait([studentListState.getAllClasses(), studentListState.getAllTrainingDirections()]),
        builder: (context, snapshot) {
          List<ClassData> classList = snapshot.hasData
              ?snapshot.data![0] as List<ClassData>
              :[];
          List<TrainingDirectionsData> trainingDirectionsList = snapshot.hasData
              ?snapshot.data![1] as List<TrainingDirectionsData>
              :[];
         return StudentDialog(title: TextRes.addStudentTitle,
              classes: classList, actionText: TextRes.saveActionText,
              trainingDirections: trainingDirectionsList);
        }
      );
    });
  }
}
