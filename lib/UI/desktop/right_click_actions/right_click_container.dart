import 'package:buecherteam_2023_desktop/UI/desktop/right_click_actions/action_button.dart';
import 'package:flutter/material.dart';

import '../../../Data/selectableItem.dart';
import '../../../Resources/dimensions.dart';

/*
shows the actions in a Card containing a list of buttons
 */
class RightClickActionContainer extends StatelessWidget {
  const RightClickActionContainer(
      {super.key,
      required this.width,
      required this.actions,
      required this.selectedItems,
      required this.onCloseOverlay});

  final double width;
  final Map<String, void Function(List<SelectableItem>)> actions;
  final Function() onCloseOverlay;
  final List<SelectableItem> selectedItems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimensions.cornerRadiusSmall))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var action in actions.entries)
              ActionButton(
                  label: action.key,
                  onClick: () {
                    action.value(selectedItems); //open associated Dialog
                    onCloseOverlay(); //notify overlay to be closed
                  })
          ],
        ),
      ),
    );
  }
}
