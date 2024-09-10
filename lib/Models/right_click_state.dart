import 'package:buecherteam_2023_desktop/Util/database/delete.dart';
import 'package:flutter/material.dart';

import '../Data/db.dart';

class RightClickState extends ChangeNotifier {
  RightClickState(this.database);

  final DB database;

  Future<void> deleteItem(String id) async {
    final doc = await database.getDoc(id);
    if (doc != null) database.deleteDoc(doc);
  }

  Future<void> deleteItemsInBatch(List<String> ids) async {
    await deleteItemsInBatchUtil(ids, database);
  }
}
