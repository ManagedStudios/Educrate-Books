import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

/*
ChipTag is a customized chip widget with an optional delete button
 */
class ChipTag<T extends LfgChip> extends StatelessWidget {
  const ChipTag(
      {super.key,
      required this.chipContent,
      required this.color,
      required this.deletable,
      required this.onDelete});

  final T chipContent;
  final Color color;
  final bool deletable;
  final Function(T chip) onDelete; //delegate onDelete action

  @override
  Widget build(BuildContext context) {
    return chipContent.getLabelText() == ""
        ? Container()
        : Card(
            //return empty container if empty text
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.cornerRadiusSmall)),
            elevation: Dimensions.elevationZero,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: Dimensions.paddingSmall,
                  right: Dimensions.paddingSmall,
                  top: Dimensions.paddingVerySmall,
                  bottom: Dimensions.paddingVerySmall),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chipContent.getLabelText(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ), //finishs chip
                  /*
            optional delete iconButton
             */
                  if (deletable) ...[
                    //add the delete button to the chip
                    const SizedBox(
                      width: Dimensions.spaceVerySmall,
                    ),
                    IconButton.filledTonal(
                      onPressed: () => onDelete(chipContent),
                      icon: const Icon(Icons.close),
                      iconSize: Dimensions.iconSizeVerySmall,
                      constraints: const BoxConstraints(
                          //make button including hitbox smaller
                          maxHeight: Dimensions.iconButtonHeightVerySmall,
                          maxWidth: Dimensions.iconButtonWidthVerySmall),
                      padding: EdgeInsets.zero,
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.cornerRadiusSmall))),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.transparent)),
                    )
                  ]
                ],
              ),
            ),
          );
  }
}
