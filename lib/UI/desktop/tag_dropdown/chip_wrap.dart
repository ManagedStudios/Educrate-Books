import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/chip_colors.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/tag_dropdown/chip_tag.dart';
import 'package:flutter/material.dart';

/*
ChipWrap acts as container for chips; it is used for the availableChips in
ActionDropdown and to show the static
selectedChips in the Dropdown before ActionDropdown opens
 */
class ChipWrap<T extends LfgChip> extends StatelessWidget {
  const ChipWrap(
      {super.key,
      required this.chips,
      required this.onClickChipRow,
      this.color,
      required this.width, this.prefix});

  final List<T> chips;
  final String? prefix;
  final void Function(List<T>) onClickChipRow; //delegate the onClickChipRow
  final Color? color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        //base container - enables clicks
        onPressed: () => onClickChipRow(chips),
        style: ButtonStyle(
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.cornerRadiusSmall))),
            alignment: Alignment.centerLeft),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (chips.isEmpty) ...[
              //when no chips show helper text
              const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: Dimensions.spaceSmall,
                  ),
                  Expanded(
                      child: Text(
                    TextRes.addChipsHint,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              )
            ],
            if (prefix != null)
              Padding(
                padding: const EdgeInsets.only(left: Dimensions.paddingMedium),
                child: Text(prefix!, style: Theme.of(context).textTheme.bodySmall,),
              ),
            for (int chipIndex = 0;
                chipIndex < (chips.length);
                chipIndex++) //render all chips
              ChipTag<T>(
                  chipContent: chips[chipIndex],
                  color: chips[chipIndex].getChipColor()
                        ?? color
                        ?? ChipColors
                          .chipColors[chipIndex % ChipColors.chipColors.length],
                  deletable: false,
                  onDelete: (_) {})
            /*
            use chipIndex%ChipColors.chipColors.length to iterate through chipColors based on chipIndex
             */
          ],
        ),
      ),
    );
  }
}
