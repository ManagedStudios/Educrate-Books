
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/classes/classes_row.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/student_list_view.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:buecherteam_2023_desktop/Util/transformer/grouper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class ClassView extends StatelessWidget {
  static String routeName = '/classView';
  const ClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllClasses(DB()),
        builder: (context, data) {
          if (!data.hasData) return const CircularProgressIndicator();
          final classRows = groupClassesByLevel(data.data!);

          return ListView(
            children: [
              for (MapEntry<int, List<ClassData>> classRow in classRows.entries)
                ClassesRow(classRow: classRow,
                    onClassClicked: (clickedClass) => {
                    context.go(StudentListView.routeName, extra: clickedClass)
                    })
            ],
          );
        });
  }
}
