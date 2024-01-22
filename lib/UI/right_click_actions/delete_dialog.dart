
import 'package:buecherteam_2023_desktop/Models/right_click_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Resources/text.dart';


/*
Dialog for right_click_actions. Receives a List of SelectableItems that can be
manipulated.
 */

Future<bool> openDeleteDialog (
    BuildContext context,
    List<String> itemIds,
    String itemType,
    {Function? functionBeforeDeletion}

) {
  return showDialog<List<String>>(context: context,
      builder: (context) => AlertDialog(
        content: Text(
          "${TextRes.sure} ${itemIds.length } $itemType ${TextRes.toDelete}" //show how many items of which type will be deleted
        ),
        actions: [
          FilledButton.tonal(onPressed: () {
            context.pop();
          }, child: const Text(
            TextRes.cancel
          )
          ),

          FilledButton(onPressed: () {
            context.pop(itemIds);

          }, child: const Text(
              TextRes.delete
            )
          )
        ],
      )
  ).then((items) {
    var state = Provider.of<RightClickState>(context, listen: false);
    if (items != null) { //return true if items have been deleted
      if (functionBeforeDeletion != null) {
        functionBeforeDeletion();
      }
      final ids = items;
      state.deleteItemsInBatch(ids); //delete items
      return true;
    } else {
      return false;
    }
  });
}

