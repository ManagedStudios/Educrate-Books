
import 'package:buecherteam_2023_desktop/Data/selectableItem.dart';
import 'package:buecherteam_2023_desktop/Models/right_click_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Resources/text.dart';


/*
Dialog for right_click_actions. Receives a List of SelectableItems that can be
manipulated.
 */

void openDeleteDialog (
    BuildContext context,
    List<SelectableItem> items,
    String itemType

) {
  showDialog<List<SelectableItem>>(context: context,
      builder: (context) => AlertDialog(
        content: Text(
          "${TextRes.sure} ${items.length} $itemType ${TextRes.toDelete}" //show how many items of which type will be deleted
        ),
        actions: [
          FilledButton.tonal(onPressed: () {
            context.pop();
          }, child: const Text(
            TextRes.cancel
          )
          ),

          FilledButton(onPressed: () {
            context.pop(items);
          }, child: const Text(
              TextRes.delete
            )
          )
        ],
      )
  ).then((items) {
    var state = Provider.of<RightClickState>(context, listen: false);
    if (items != null) {
      final ids = items
          .map((item) => item.getDocId()!)
          .toList();
      state.deleteItemsInBatch(ids); //delete items
    }
  });
}

