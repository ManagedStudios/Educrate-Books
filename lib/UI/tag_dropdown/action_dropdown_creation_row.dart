

import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';

import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:flutter/material.dart';

class ActionDropdownCreationRow<T extends LfgChip>
    extends StatelessWidget {
  const ActionDropdownCreationRow({super.key, required this.chipToBeCreated, required this.onCreateChip, required this.width});

  final T chipToBeCreated;
  final Function(T) onCreateChip;
  final double width;


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.cornerRadiusSmall))),
      margin: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
            ChipWrap<T>(
                prefix: TextRes.create,
                chips: <T>[chipToBeCreated],
                onClickChipRow: (_) {
                  onCreateChip(chipToBeCreated);
                },
                width: width)
        ],
      ),
    );
  }
}
