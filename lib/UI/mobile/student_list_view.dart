

import 'package:buecherteam_2023_desktop/UI/mobile/students/student_card.dart';
import 'package:buecherteam_2023_desktop/Util/stringUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/studentListState.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({super.key, required this.classLevel, required this.classChar});
  final int classLevel;
  final String classChar;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<StudentListState>(context, listen: false)
        .streamStudents(getQueryFromSearchText("$classLevel$classChar"), null),
        builder: (context, change) {
          final int dataLength = change.data?.length ?? 0;

          return Expanded(
            child: ListView.builder(
                itemCount: dataLength,
                itemBuilder: (context, index) {
                  return StudentCard(
                      student: change.data![index],
                      onClick: (student) => {});
                }),
          );

        });
  }
}
