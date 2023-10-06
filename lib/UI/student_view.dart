
import 'dart:math';


import 'package:buecherteam_2023_desktop/UI/all_students_column.dart';
import 'package:flutter/material.dart';


import '../Resources/dimensions.dart';


class StudentView extends StatelessWidget {
  static String routeName = '/studentView';

  const StudentView({super.key});


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final double marginWidth = mediaQuery.width * (0.03+0.12/(1+pow(2.71, -0.005*(mediaQuery.width-1150))));
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingVeryBig),
      child: Row(
        children: [
          SizedBox(width: marginWidth,),
          const Expanded(child: AllStudentsColumn()),
          SizedBox(width: Dimensions.spaceMedium,), //TODO make sizedbox width dynamic
          Container(
            width: Dimensions.lineWidth,
            height: MediaQuery.of(context).size.height*0.7,
            color: Theme.of(context).colorScheme.outline,
          ),
          Expanded(child: Container()), //studentDetail
          SizedBox(width: marginWidth,)
        ],
      ),
    );
  }
}
