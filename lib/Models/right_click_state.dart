import 'package:cbl/cbl.dart';
import 'package:flutter/cupertino.dart';

import '../Data/db.dart';

class RightClickState extends ChangeNotifier {
  RightClickState(this.database);

  final DB database;

  Future<void> deleteItem(String id) async {
    final doc = await database.getDoc(id);
    if (doc != null) database.deleteDoc(doc);
  }

  Future<void> deleteItemsInBatch(List<String> ids) async {
    List<Document> docs = [];
    for (String id in ids) {
      final doc = await database.getDoc(id);
      if (doc != null) docs.add(doc);
    }
    database.deleteDocs(docs);
  }
}
