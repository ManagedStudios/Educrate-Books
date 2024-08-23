import 'package:buecherteam_2023_desktop/UI/right_click_actions/right_click_container.dart';
import 'package:flutter/material.dart';

import '../../Data/selectableItem.dart';

/*
should be shown when right clicked on a list that contains selectable Items
Controlled usually by gesture detector integrated in a widget

ActionsOverlay recieves list of SelectableItems and a list of actions.
Actions are defined as Map of String (=title) and a void function with the list of
selectable items as parameter. The void function should open some sort of dialog.

closing behavior primarily controlled by right_click_container
 */

class ActionsOverlay {
  ActionsOverlay(
      {required this.selectedItems,
      required this.width,
      required this.actions,
      required this.onOverlayClosed,
      required this.offset,
      required this.context});

  final List<SelectableItem> selectedItems;
  final double width;
  final Offset offset;
  final Map<String, void Function(List<SelectableItem>)> actions;
  final void Function() onOverlayClosed;
  final BuildContext context;
  bool isOverlayEntryOpen = false;
  OverlayEntry? overlayEntry;

  void showOverlayEntry() {
    final overlay = Overlay.of(context);
    overlayEntry ??
        {
          //if no overlayEntry is created, create a new one
          createOverlayEntry(offset),
          overlay.insert(overlayEntry!)
        };
  }

  void createOverlayEntry(Offset offset) {
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            //position near to mouse click
            left: offset.dx,
            top: offset.dy - 50, //there's an offset, hardcoded could vary a bit
            child: TapRegion(
              onTapOutside: (_) {
                closeOverlay();
                onOverlayClosed();
              },
              child: RightClickActionContainer(
                  //show actions
                  width: width,
                  actions: actions,
                  selectedItems: selectedItems,
                  onCloseOverlay: () {
                    //close when an item has been selected - callback
                    closeOverlay();
                    onOverlayClosed();
                  }),
            )));
  }

  void closeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      onOverlayClosed();
    }
  }
}
