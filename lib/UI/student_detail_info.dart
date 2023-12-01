import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

import '../Data/student.dart';

class StudentDetailInfo extends StatelessWidget {
  const StudentDetailInfo({super.key, required this.students, required this.onAddWarning});

  final List<Student> students;
  final Function(List<Student> students) onAddWarning;

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    students.length==1
                        ? "${students.first.firstName} ${students.first.lastName}"
                        : TextRes.severalStudents,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextButton(onPressed: (){
                    onAddWarning(students);
                  },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall)
                        )
                      )
                    ),
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          Text(TextRes.warning)
                        ],
                      ),
                  )
                ],
              ),
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
