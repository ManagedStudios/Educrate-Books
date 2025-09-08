import 'package:flutter/material.dart';

import '../../../Data/student.dart';
import '../../../Resources/dimensions.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.onClick});

  final Student student;
  final Function(Student clickedStudent) onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
    borderRadius:
        BorderRadius.circular(Dimensions.cornerRadiusSmall)))),
        onPressed: onClick(student),
        child: Text(
          "${student.firstName} ${student.lastName}",
          style: Theme.of(context).textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ));
  }
}
