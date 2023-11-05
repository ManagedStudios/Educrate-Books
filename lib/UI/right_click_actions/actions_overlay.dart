
import 'package:buecherteam_2023_desktop/UI/right_click_actions/right_click_container.dart';
import 'package:flutter/material.dart';

import '../../Data/selectableItem.dart';



class ActionsOverlay {

  ActionsOverlay({required this.selectedItems, required this.width, required this.actions,
  required this.onOverlayClosed, required this.offset, required this.context});

  final List<SelectableItem> selectedItems;
  final double width;
  final Offset offset;
  final Map<String, void Function(List<SelectableItem>)> actions;
  final void Function() onOverlayClosed;
  final BuildContext context;
  bool isOverlayEntryOpen = false;
  OverlayEntry? overlayEntry;

  void showOverlayEntry () {
    final overlay = Overlay.of(context);
    overlayEntry??{ //if no overlayEntry is created, create a new one
      createOverlayEntry(offset),
      overlay.insert(overlayEntry!)
    };
  }


  void createOverlayEntry (Offset offset) {
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            left: offset.dx,
            top: offset.dy-50,
            child: TapRegion(
              onTapOutside: (_) {
                closeOverlay();
                onOverlayClosed();
              },
              child: RightClickActionContainer(
                  width: width,
                  actions: actions,
                  selectedItems: selectedItems,
                  onCloseOverlay: (){
                    closeOverlay();
                    onOverlayClosed();
                  }),
            )
        )

    );
  }

  void closeOverlay() {
    if(overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      onOverlayClosed();
    }
  }
}
