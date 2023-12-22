import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

import '../Data/student.dart';


/*
shows basic information of one or multiple students and contains the button
to add a warning (Standard-Mahnung) to your clipboard and the selected students
 */
class StudentDetailInfo extends StatelessWidget {
  const StudentDetailInfo({super.key, required this.students, required this.onAddWarning});

  final List<Student> students; //data
  final Function(List<Student> students) onAddWarning; //propagate

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*
                  student name or information about multiple students
                   */
                  SelectableText(
                    students.length==1
                        ? "${students.first.firstName} ${students.first.lastName}"
                        : "${students.length} ${TextRes.severalStudents}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  /*
                  warning button
                   */
                  Tooltip(
                    message: TextRes.standardWarningAdd,
                    child: TextButton(onPressed: (){
                      onAddWarning(students);
                    },
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusMedium)
                          )
                        )
                      ),
                        child: const Row(
                          children: [
                            Icon(Icons.add),
                            Text(TextRes.warning)
                          ],
                        ),
                    ),
                  )
                ],
              ),

               /*
               show class and training directions if one student is selected
               else show information how to interact with multiple students
                */
               Wrap(
                  children: [
                    Text(
                        students.length == 1
                            ? "${students.first.classLevel}${students.first.classChar} | "
                            : TextRes.severalStudentsInfo,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    if(students.length == 1) 
                      for (String trainingDirection in students.first.trainingDirections)
                        Text("$trainingDirection  ",
                        style: Theme.of(context).textTheme.labelLarge,)
                  ]
                ),
            ],
          );
  }
}
