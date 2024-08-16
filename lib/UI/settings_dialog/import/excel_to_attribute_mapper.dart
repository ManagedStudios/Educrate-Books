
import 'package:buecherteam_2023_desktop/Data/student_excel_mapper_attributes.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExcelToAttributeMapper extends StatelessWidget {
  const ExcelToAttributeMapper({super.key, required this.excelKey, required this.availableAttributes, required this.width});
  final String excelKey;
  final List<StudentAttributes> availableAttributes;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              excelKey,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: Dimensions.spaceLarge,),
            Text(
              TextRes.equals,
            style: Theme.of(context).textTheme.displayLarge,),
            const SizedBox(width: Dimensions.spaceLarge,),
            Dropdown(
                availableChips: availableAttributes,
                selectedChips: [],
                onAddChip: (_){},
                onDeleteChip: (_){},
                multiSelect: false,
                width: width,
                onCloseOverlay: (_){}
            )
          ],
        ),
      ],
    );
  }
}
