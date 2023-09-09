
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/UI/all_students_column.dart';
import 'package:flutter/material.dart';


import '../Resources/dimensions.dart';


class StudentView extends StatelessWidget {
  static String routeName = '/studentView';

  const StudentView({super.key});


  @override
  Widget build(BuildContext context) {
    final double marginWidth =
    MediaQuery.of(context).size.width*0.15>Dimensions.minMarginStudentView?MediaQuery.of(context).size.width*0.15:Dimensions.minMarginStudentView;
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingVeryBig),
      child: Row(
        children: [
          SizedBox(width: marginWidth,),
          Expanded(child: AllStudentsColumn()),
          SizedBox(width: Dimensions.spaceMedium,),
          Expanded(child: Container()), //studentDetail
          SizedBox(width: marginWidth,)
        ],
      ),
    );
  }
}
