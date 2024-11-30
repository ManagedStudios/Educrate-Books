import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';

import 'package:buecherteam_2023_desktop/UI/tag_dropdown/action_dropdown.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/chip_wrap.dart';
import 'package:flutter/material.dart';

/*
Dropdown is the entry point for Dropdowns.
The dropdown consists of a selection view that opens on click a actionDropdown Overlay
to change the selection.
Dropdown is self contained and updates its state within the widget, but it also
notifies parents about state changes to make updates to databases and similar.

The Dropdown requires a type implementing LfgChip. Its similar to Item of the Material.io
Dropdown, but with the benefit that you can cast without any worry the delegated Results
of onDeleteChip and onAddChip to the initial data objects.
 */
class Dropdown<T extends LfgChip> extends StatefulWidget {
  const Dropdown(
      {super.key,
      required this.availableChips,
      required this.selectedChips,
      required this.onAddChip,
      required this.onDeleteChip,
      required this.multiSelect,
      required this.width,
      this.hintText,
      required this.onCloseOverlay, this.onCreateChip, this.offsetHeight, this.onFocusChanged});

  final List<T> selectedChips;
  final List<T> availableChips;
  final Function(T chip) onAddChip;
  final Function(T chip) onDeleteChip;
  final Function(List<T> selectedChips)
      onCloseOverlay; //is not called on single Select!
  final Function(T chip)? onCreateChip;
  final bool multiSelect;
  final double width;
  final double? offsetHeight;
  final String? hintText;
  final Function(bool focused)? onFocusChanged;

  @override
  State<Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T extends LfgChip> extends State<Dropdown<T>> {
  bool isOverlayOpen = false;
  late GlobalKey wrapChipsField;
  late List<T> selectedChips;
  late List<T> availableChips;
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    wrapChipsField =
        GlobalKey(); //globalKey used to get the position of the selection view
    selectedChips = widget.selectedChips
        .toList(); //initial state that is updated internally
    availableChips = widget.availableChips.toList();
    for (var selected in selectedChips) {
      availableChips
          .removeWhere((it) => it.getLabelText() == selected.getLabelText());
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.availableChips != widget.availableChips) {
      availableChips = widget.availableChips.toList();
      if (oldWidget.selectedChips != widget.selectedChips) {
        selectedChips = widget.selectedChips.toList();
      }
      for (var selected in selectedChips) {
        availableChips
            .removeWhere((it) => it.getLabelText() == selected.getLabelText());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    overlayEntry?.remove();
    overlayEntry?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return IgnorePointer(
      ignoring: isOverlayOpen, //disable interaction when overlay is open
      child: ChipWrap<T>(
          key: wrapChipsField,
          chips: selectedChips,
          onClickChipRow: (_) {
            showOverlay(widget.offsetHeight);
          },
          width: widget.width),
    );
  }

  void showOverlay(double? offsetHeight) {
    final overlay = Overlay.of(context);
    RenderBox renderBox =
        wrapChipsField.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox
        .localToGlobal(Offset(0, offsetHeight??0)); //retrieve position of textField
    overlayEntry ??
        {
          //if overlayEntry is not initialized create a new one (case when you open the overlay)
          createOverlayEntry(offset),
          overlay.insert(overlayEntry!)
        };
    setState(() {
      isOverlayOpen = true;
    });
  }

  void createOverlayEntry(Offset offset) {
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
          //position the Overlay widget correctly
          left: offset.dx,
          top: offset.dy,
          child: TapRegion(
            onTapOutside: (_) {
              closeOverlay();
            },
            child: ActionDropdown<T>(
                width: widget.width,
                selectedChips: selectedChips,
                hintText: widget.hintText,
                onDeleteChip: (chip) {
                  widget.onDeleteChip(chip); //notify parents about changes
                  deleteChip(chip); //internally update State
                },
                availableChips: availableChips,
                onAddChip: (T chip) {
                  widget.onAddChip(chip);
                  addChip(chip);
                },
              onCreateChip: widget.onCreateChip == null
                            ? null
                            : (chip) {
                  widget.onCreateChip!(chip);
                  widget.onAddChip(chip);
                  addChip(chip);
              },
              onFocusChanged: widget.onFocusChanged,
            ),
          )),
    );
  }

  /*
  Overlays don't react to setState so you have to
  manually determine when to update the overlay
   */

  void markOverlayReadyForUpdate() {
    if (overlayEntry != null) {
      overlayEntry!.markNeedsBuild();
    }
  }

  void closeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
      setState(() {
        isOverlayOpen = false;
      });
      widget.onCloseOverlay(selectedChips);
    }
  }

  void addChip(T chip) {
    markOverlayReadyForUpdate(); //update Overlay on next state change occurring right in addChip
    if (widget.multiSelect) {
      setState(() {
        selectedChips.add(chip);
        print(availableChips.map((e) => e.getLabelText()));
        availableChips.removeWhere(
            (element) => element.getLabelText() == chip.getLabelText());
        print(availableChips.map((e) => e.getLabelText()));
      });
    } else {
      //single select
      setState(() {
        /*
        first move all chips (usually should be 0 or 1 element) to availableChips and then delete
         */
        selectedChips.forEach((element) => availableChips.add(element));
        selectedChips.removeRange(0, selectedChips.length);

        /*
        then add the chip and remove from available
         */
        selectedChips.add(chip);
        availableChips.removeWhere(
            (element) => element.getLabelText() == chip.getLabelText());

        //close the overlay since no more elements can be selected
        closeOverlay();
      });
    }
  }

  void deleteChip(T chip) {
    markOverlayReadyForUpdate();
    setState(() {
      availableChips.add(chip);
      selectedChips.removeWhere(
          (element) => element.getLabelText() == chip.getLabelText());
    });
  }
}
