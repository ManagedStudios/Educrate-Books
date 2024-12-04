import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/dropdown.dart';

import 'package:flutter/material.dart';

/*
Maps an Attribute detected in the imported excel sheet of a student
(e.g. name, trainingDirection) with an attribute that represents a real attribute
in Dart
Can also be used to Map any string/excel cell to some LFGChip
 */
class AttributeMapper<T extends LfgChip> extends StatelessWidget {
  const AttributeMapper(
      {super.key,
      required this.excelDataKey,
      required this.availableAttributes,
      required this.width,
      required this.onItemSelected,
      this.selectedAttribute});
  final ExcelData excelDataKey;
  final List<T> availableAttributes;
  final T? selectedAttribute;
  final double width;
  final Function(T? item) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width*0.35,
              child: Tooltip(
                message: excelDataKey.content,
                child: Text(
                  excelDataKey.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(
              width: Dimensions.spaceLarge,
            ),
            Text(
              TextRes.equals,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              width: Dimensions.spaceLarge,
            ),
            Dropdown<T>(
                availableChips: availableAttributes,
                selectedChips: selectedAttribute != null
                    ? <T>[selectedAttribute!]
                    : <T>[], //don't put const [] in here since it leads to type conflicts (Dart treats const [] as List<Never>)
                onAddChip: (_) {

                },
                onDeleteChip: (_) {},
                multiSelect: false,
                width: width*0.75,
                onCloseOverlay: (items) {
                  onItemSelected(items.firstOrNull);
                })
          ],
        ),
      ],
    );
  }
}
