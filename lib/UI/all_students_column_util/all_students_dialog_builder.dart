import 'package:flutter/material.dart';

import '../../Data/class_data.dart';
import '../../Data/student.dart';
import '../../Data/training_directions_data.dart';
import '../../Models/studentListState.dart';
import '../student_dialog/student_dialog.dart';

Widget studentDialogFutureBuilder({
  required StudentListState studentListState,
  required String title,
  required String actionText,
  Student? student,
}) {
  return FutureBuilder(
    future: Future.wait([
      studentListState.getAllClasses(),
      studentListState.getAllTrainingDirections()
    ]),
    initialData: const [[], []],
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData) {
        List<dynamic> rawClassList = snapshot.data?[0] ?? [];
        List<ClassData> classList =
            rawClassList.map((e) => e as ClassData).toList();

        List<dynamic> rawTrainingDirectionsList = snapshot.data?[1] ?? [];
        List<TrainingDirectionsData> trainingDirectionsList =
            rawTrainingDirectionsList
                .map((e) => e as TrainingDirectionsData)
                .toList();

        return StudentDialog(
          key: UniqueKey(),
          title: title,
          classes: classList,
          actionText: actionText,
          trainingDirections: trainingDirectionsList,
          loading: false,
          student: student,
        );
      } else {
        return StudentDialog(
          key: UniqueKey(),
          title: title,
          classes: const [],
          actionText: actionText,
          trainingDirections: const [],
          loading: true,
        );
      }
    },
  );
}
