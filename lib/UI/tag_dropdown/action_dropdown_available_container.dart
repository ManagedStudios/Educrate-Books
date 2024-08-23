import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/chip_colors.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/keys.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:flutter/material.dart';

/*
ActionDropdownAvailableContainer shows the options you can select in a dropdownAction
 */

class ActionDropdownAvailableContainer<T extends LfgChip> extends StatelessWidget {
  const ActionDropdownAvailableContainer({super.key, required this.availableChips,
    required this.onAddChip, required this.width, this.hintText});

  final List<T> availableChips;
  final Function(T chip) onAddChip;
  final double width;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    availableChips.sort();
    return Card( //base container providing color and shape
      key: Key(Keys.ActionDropdownAvailableCardKey),
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius:
      BorderRadius.only(bottomLeft: Radius.circular(Dimensions.cornerRadiusSmall),
          bottomRight: Radius.circular(Dimensions.cornerRadiusSmall)
      )
      ),
      margin: const EdgeInsets.only(top: 0),
      child: SizedBox( //limiting the height of the AvailableContainer
        key: Key(Keys.ActionDropdownAvailableContainerSizedBoxKey),
        height: Dimensions.overlayHeight,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSmall),
          child: ListView( //Scrollable List of options
            children: [
              /*
              Explaining Text for selecting options
               */
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingBetweenVerySmallAndSmall),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(TextRes.selectChipHelper, style:
                    Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant
                      )
                    ),
                    if(hintText != null) ...[
                      Text(hintText!, style:
                      Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                      )
                    ]
                  ],
                ),
              ),

              /*
              use ChipWrap with fixed width to use as optionButtons
               */
              for (int chipIndex = 0; chipIndex<availableChips.length; chipIndex++)
                ChipWrap<T>(chips: [availableChips[chipIndex]],
                  onClickChipRow: (List<T> chip) {
                    onAddChip(chip[0]);
                  },
                  width: width,
                  color: ChipColors.chipColors[ChipColors.chipColors.length-1-chipIndex%ChipColors.chipColors.length],)
            ],
          ),
        ),
      ),
    );
  }

}
