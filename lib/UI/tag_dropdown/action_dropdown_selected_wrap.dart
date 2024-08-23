import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/chip_colors.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_tag.dart';
import 'package:flutter/material.dart';

import '../../Resources/keys.dart';

/*
ActionDropdownSelectedWrap shows the currently selected Chips in ActionDropdown
and makes filtering for chips in ActionDropdown possible

No State managed here besides the TextEditingController for the textField
 */

class ActionDropdownSelectedWrap<T extends LfgChip> extends StatefulWidget {
  const ActionDropdownSelectedWrap(
      {super.key,
      required this.width,
      required this.selectedChips,
      required this.onDeleteChip,
      required this.onFilterTextChange});

  final double width;
  final List<T> selectedChips;
  final Function(T chip) onDeleteChip;
  final Function(String text) onFilterTextChange;

  @override
  State<ActionDropdownSelectedWrap<T>> createState() =>
      _ActionDropdownSelectedWrapState<T>();
}

class _ActionDropdownSelectedWrapState<T extends LfgChip>
    extends State<ActionDropdownSelectedWrap<T>> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //base container providing shape and color
      key: Key(Keys.actionDropdownSelectedWrapCard),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimensions.cornerRadiusSmall),
              topLeft: Radius.circular(Dimensions.cornerRadiusSmall))),
      margin: const EdgeInsets.only(bottom: 0),
      child: SizedBox(
        //limit the width to match ActionDropdownAvailableContainer
        key: Key(Keys.actionDropdownSelectedWrapSizedBoxForCard),
        width: widget.width,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (int chipIndex = 0;
                chipIndex < (widget.selectedChips.length);
                chipIndex++)
              ChipTag(
                  key: Key(widget.selectedChips[chipIndex].getLabelText()),
                  chipContent: widget.selectedChips[chipIndex],
                  color: ChipColors
                      .chipColors[chipIndex % ChipColors.chipColors.length],
                  deletable: true,
                  onDelete: (chip) {
                    widget.onDeleteChip(
                        chip); //delegate the onDeleteCall further up
                  }),
            /*
            Rest of code is for the textField
             */
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSmall),
              child: SizedBox(
                key: Key(Keys.actionDropdownSelectedWrapSizedBoxForTextfield),
                width: 64,
                height: 28,
                child: Center(
                  child: TextField(
                    style: Theme.of(context).textTheme.labelSmall,
                    autofocus: true,
                    controller: controller,
                    onChanged: (text) {
                      controller.text = text.toUpperCase();
                      widget.onFilterTextChange(text.toUpperCase());
                    },
                    decoration: const InputDecoration(
                      border: InputBorder
                          .none, // removes the default underline border
                      focusedBorder: InputBorder
                          .none, // removes the border when the TextField is focused
                      enabledBorder: InputBorder
                          .none, // removes the border when the TextField is enabled
                      errorBorder: InputBorder
                          .none, // removes the border when the TextField has an error
                      disabledBorder: InputBorder
                          .none, // removes the border when the TextField is disabled
                      contentPadding: EdgeInsets.all(0), // no padding
                      hintText: TextRes.search, // no hint text
                      labelText: null, // no label text
                      counterText: '', // no counter text
                      isDense: true,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
