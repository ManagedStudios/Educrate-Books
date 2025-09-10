
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/classes/classes_row.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/student_list_view.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:buecherteam_2023_desktop/Util/transformer/grouper.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class ClassView extends StatelessWidget {
  static String routeName = '/';
  const ClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllClasses(DB()),
        builder: (context, data) {
          if (!data.hasData || DB().replicatorStatus.value?.activity == ReplicatorActivityLevel.busy) return const CircularProgressIndicator();
          final classRows = groupClassesByLevel(data.data!);

          return ListView(
            children: [
              for (MapEntry<int, List<ClassData>> classRow in classRows.entries)
                ClassesRow(classRow: classRow,
                    onClassClicked: (clickedClass) => {
                    context.push("${StudentListView.routeName}/${clickedClass.classLevel.toString()}/${clickedClass.classChar}")
                    })
            ],
          );
        });
  }
}
