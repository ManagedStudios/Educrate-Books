
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/chip_colors.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_available_container.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_creation_row.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_selected_wrap.dart';

import 'package:flutter/material.dart';

/*
the overlay widget which makes selecting and deleting options possible

in ActionDropdown only the filtering State is managed, all other state is managed
by Dropdown
 */
class ActionDropdown<T extends LfgChip> extends StatefulWidget {
  const ActionDropdown(
      {super.key,
      required this.width,
      required this.selectedChips,
      required this.onDeleteChip,
      required this.availableChips,
      required this.onAddChip,
      this.hintText, this.onCreateChip, this.onFocusChanged,
      });

  final double width;
  final List<T> selectedChips;
  final Function(T chip) onDeleteChip;

  final List<T> availableChips;
  final Function(T chip) onAddChip;
  final String? hintText;

  final Function(T chip)? onCreateChip;

  final Function(bool focused)? onFocusChanged;

  /*
  filterList filters for numbers in elements and additionally for text matches
  ensures filtering just after class_level
   */
  List<T> filterList(List<T> fullList, String filterText) {
    // Get numeric value from filterText.
    final filterNum = RegExp(r'\d+').firstMatch(filterText)?.group(0) ?? '';

    return fullList.where((item) {
      // If filterNum is not empty, check if item contains it.
      if (filterNum.isNotEmpty && !item.getLabelText().contains(filterNum)) {
        return false;
      }

      // Filter based on the non-numeric part of filterText.
      final filterTextWithoutNum =
          filterText.replaceAll(filterNum, '').toUpperCase();
      if (filterTextWithoutNum.isNotEmpty &&
          !item.getLabelText().toUpperCase().contains(filterTextWithoutNum)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  State<ActionDropdown<T>> createState() => _ActionDropdownState<T>();
}

class _ActionDropdownState<T extends LfgChip> extends State<ActionDropdown<T>> {
  late List<T> filteredAvailableChips;
  String filterText = "";
  Color? creationColor;

  @override
  void initState() {
    super.initState();
    filteredAvailableChips = widget.availableChips
        .toList(); //set initialState for the filteredChips - make a copy of the list
    if (widget.onCreateChip != null) {
      creationColor = getColor();
    }
  }

  /*
  update the filteredAvailableChips accordingly to availableChips changes
  that happen because of adding/deleting actions of the user
   */
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
        filteredAvailableChips =
            widget.filterList(widget.availableChips, filterText);

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionDropdownSelectedWrap<T>(
            width: widget.width,
            selectedChips: widget.selectedChips,
            onDeleteChip: widget.onDeleteChip,
            onFilterTextChange: (text) {
              setState(() {
                //update the available chips based on the filter
                filterText = text.toUpperCase();
                filteredAvailableChips =
                    widget.filterList(widget.availableChips, filterText);
              });
            },
            onFocusChanged: widget.onFocusChanged,
          ),
          ActionDropdownAvailableContainer<T>(
            availableChips: filteredAvailableChips,
            onAddChip: widget.onAddChip,
            width: widget.width,
            hintText: widget.hintText,
          ),
          if (widget.onCreateChip != null
              && filterText.isNotEmpty
              && !widget.selectedChips.map((e) => e.getLabelText()).contains(filterText)
              && !widget.availableChips.map((e) => e.getLabelText()).contains(filterText))
            ActionDropdownCreationRow<T>(
                chipToBeCreated: LfgChip.createChipFrom(filterText, creationColor!),
                onCreateChip: widget.onCreateChip!,
                width: widget.width)
        ],
      ),
    );
  }

  Color getColor() {
    Set<Color?> currColors = {};
    currColors.addAll(widget.selectedChips.map((e) => e.getChipColor()));
    currColors.addAll(widget.availableChips.map((e) => e.getChipColor()));
    List<Color> colors = ChipColors.chipColors.toList();
    colors.removeWhere((color) => currColors.contains(color));
    return colors.first;
  }

}
