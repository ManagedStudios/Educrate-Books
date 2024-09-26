

import 'package:cbl/cbl.dart';

import '../../Data/class_data.dart';
import '../../Data/db.dart';

Future<void> addClasses (List<ClassData> classes, DB database) async{
  List<MutableDocument> classDocs = [];
  for (ClassData classData in classes) {
    MutableDocument doc = MutableDocument();
    database.updateDocFromEntity(classData, doc);
    classDocs.add(doc);
  }
  await database.saveDocuments(classDocs);
}