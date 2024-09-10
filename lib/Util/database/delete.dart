import 'package:cbl/cbl.dart';

import '../../Data/db.dart';


Future<void> deleteItemsInBatchUtil(List<String> ids, DB database) async {
  List<Document> docs = [];
  for (String id in ids) {
    final doc = await database.getDoc(id);
    if (doc != null) docs.add(doc);
  }
  database.deleteDocs(docs);
}