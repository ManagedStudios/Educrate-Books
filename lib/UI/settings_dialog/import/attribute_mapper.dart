
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/dropdown.dart';

import 'package:flutter/material.dart';

class AttributeMapper<T extends LfgChip> extends StatelessWidget {
  const AttributeMapper({super.key, required this.excelDataKey, required this.availableAttributes, required this.width, required this.onItemSelected});
  final ExcelData excelDataKey;
  final List<T> availableAttributes;
  final double width;
  final Function(T item) onItemSelected;

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
              excelDataKey.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: Dimensions.spaceLarge,),
            Text(
              TextRes.equals,
            style: Theme.of(context).textTheme.displayLarge,),
            const SizedBox(width: Dimensions.spaceLarge,),
            Dropdown<T>(
                availableChips: availableAttributes,
                selectedChips: <T>[], //don't put const [] in here since it leads to type conflicts (Dart treats const [] as List<Never>)
                onAddChip: (item){
                  onItemSelected(item);
                },
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
