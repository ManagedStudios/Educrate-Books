
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/student_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Data/student.dart';
import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';

class StudentDetail extends StatelessWidget {
  static String routeName = "/student-detail";
  const StudentDetail({super.key, required this.currStudentId});
  final String currStudentId;

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentListState>(
      builder: (context, state, _)
      {
        int currStudentIndex =
            state.students.indexWhere((student) => student.id == currStudentId);
        Student currStudent = state.students[currStudentIndex];
             return Column(
                children: [
                  Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () =>
                                    context.pop(),
                                icon: const Icon(Icons.arrow_back)),
                            Text(
                              "${currStudent.classLevel}${currStudent.classChar}",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              TextRes.next,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            IconButton(
                                onPressed: () {
                                  if (currStudentIndex < state.students.length-1) {
                                    context.go("${StudentListView.routeName}/${currStudent.classLevel.toString()}/${currStudent.classChar}/${state.students[currStudentIndex+1].id}");
                                  } else {
                                    context.pop();
                                  }
                                },

                                icon: const Icon(Icons.arrow_forward)),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${currStudent.firstName} \n ${currStudent.lastName}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  ]),

                ],
              );
            });
  }
}
