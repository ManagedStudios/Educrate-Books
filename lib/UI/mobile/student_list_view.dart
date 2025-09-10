

import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/students/student_card.dart';
import 'package:buecherteam_2023_desktop/Util/stringUtil.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Models/studentListState.dart';
import '../../Resources/text.dart';

class StudentListView extends StatelessWidget {
  static String routeName = '/studentListView';
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

          return Column(
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => context.go(ClassView.routeName),
                            icon: const Icon(Icons.arrow_back)),
                        Text(TextRes.classes, style: Theme.of(context).textTheme.labelSmall,),
                      ],
                    ),

                    IconButton(onPressed: (){},
                        icon: const Icon(Icons.person_add_alt_1))
                  ],
                ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                      Text(
                        "${TextRes.classText} ${classLevel.toString()}$classChar",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],),
                  )
                ]
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingMedium),
                  child: ListView.builder(
                      itemCount: dataLength,
                      itemBuilder: (context, index) {
                        return StudentCard(
                            student: change.data![index],
                            onClick: (student) => {
                              if(classChar.isNotEmpty) {
                                context.go("${StudentListView.routeName}/$classLevel/$classChar/${student.id}")
                              } else {
                                context.go("${StudentListView.routeName}/$classLevel/${student.id}")
                              }

                            });
                      }),
                ),
              ),
            ],
          );

        });
  }
}
