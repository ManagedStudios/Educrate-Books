
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

import '../../../Data/class_data.dart';

class ClassesRow extends StatelessWidget {
  const ClassesRow({super.key, required this.classRow, required this.onClassClicked});

  final MapEntry<int, List<ClassData>> classRow;
  final Function(ClassData classData) onClassClicked;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final double lineWidth = mediaQuery.width * 0.1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: lineWidth,
          height: Dimensions.lineWidth,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: Dimensions.spaceSmall,),
        Padding(
          padding: EdgeInsets.only(left: lineWidth*0.9),
          child: Text(
              "${classRow.key}${TextRes.classLevel}",
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ),
        const SizedBox(height: Dimensions.spaceSmall,),
        Padding(padding: EdgeInsets.only(left: lineWidth*1.1),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (ClassData classData in classRow.value)
                ...[
                  ElevatedButton(
                      onPressed: () => onClassClicked(classData),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(Dimensions.cornerRadiusSmall)
                              )
                          )
                      ),
                      child: Text(
                        classData.classChar.isEmpty?'Q':classData.classChar,
                        style: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                      )
                  ),
                  const SizedBox(width: Dimensions.spaceSmall,)
                ]

            ],
          ),
        )
        )
      ],
    );
  }
}
