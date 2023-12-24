
import 'package:flutter/material.dart';

import '../Data/buildQuery.dart';
import '../Data/db.dart';
import '../Resources/text.dart';

class ClassLevelState extends ChangeNotifier {



  ClassLevelState(this.database);
  final DB database;

  int? selectedClassLevel;

  Future<List<int>> getClassLevels () async{

    String query = BuildQuery.getAllClassLevels();
    final res = await database.getDocs(query);
    return res
        .asStream()
        .map((result) => result.toPlainMap()[TextRes.classDataClassLevelJson] as int)
        .toList();
  }

  void setSelectedClassLevel(int selectedLevel) {
    selectedClassLevel = selectedLevel;
    notifyListeners();
  }
}