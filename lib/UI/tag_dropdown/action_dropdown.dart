

import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_available_container.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown_selected_wrap.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

/*
the overlay widget which makes selecting and deleting options possible

in ActionDropdown only the filtering State is managed, all other state is managed
by Dropdown
 */
class ActionDropdown<T extends LfgChip> extends StatefulWidget {
  const ActionDropdown({super.key, required this.width,
    required this.selectedChips, required this.onDeleteChip,
    required this.availableChips, required this.onAddChip, this.hintText});

  final double width;
  final List<T> selectedChips;
  final Function(T chip) onDeleteChip;

  final List<T> availableChips;
  final Function(T chip) onAddChip;
  final String? hintText;

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
      final filterTextWithoutNum = filterText.replaceAll(filterNum, '').toUpperCase();
      if (filterTextWithoutNum.isNotEmpty && !item.getLabelText().toUpperCase().contains(filterTextWithoutNum)) {
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

  @override
  void initState() {
    super.initState();
    filteredAvailableChips = widget.availableChips.toList(); //set initialState for the filteredChips - make a copy of the list
  }

  /*
  update the filteredAvailableChips accordingly to availableChips changes
  that happen because of adding/deleting actions of the user
   */
  @override
  void didUpdateWidget (oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(listEquals(oldWidget.availableChips, widget.availableChips)) {
      setState(() {
        filteredAvailableChips = widget.filterList(widget.availableChips, filterText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionDropdownSelectedWrap<T>(width: widget.width,
              selectedChips: widget.selectedChips,
              onDeleteChip: widget.onDeleteChip,
            onFilterTextChange: (text) {
            setState(() {//update the available chips based on the filter
              filterText = text.toUpperCase();
              filteredAvailableChips = widget.filterList(widget.availableChips, filterText);
            });
            },
              ),
          ActionDropdownAvailableContainer(availableChips: filteredAvailableChips,
              onAddChip: widget.onAddChip, width: widget.width, hintText: widget.hintText,)
        ],
      ),
    );

  }
}




