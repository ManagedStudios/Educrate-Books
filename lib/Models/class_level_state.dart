import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:flutter/material.dart';

import '../Data/buildQuery.dart';
import '../Data/db.dart';

class ClassLevelState extends ChangeNotifier {
  ClassLevelState(this.database);
  final DB database;

  int? selectedClassLevel;

  Future<List<int>> getClassLevels() async {
    return getAllClassLevels(database);
  }

  void setSelectedClassLevel(int selectedLevel) {
    selectedClassLevel = selectedLevel;
    notifyListeners();
  }

  Future<bool> areBooksSubceedingAmount(int level) async {
    String query = BuildQuery.getBooksSubceedingAvAmount(
        level, Dimensions.bookAvAmountThreshold);
    final books = await database.getDocs(query);
    final res = await books
        .asStream()
        .toList(); //turn to results to list to check length of subceeding books
    return res.isNotEmpty; //if there are subceeding books return true
  }
}
