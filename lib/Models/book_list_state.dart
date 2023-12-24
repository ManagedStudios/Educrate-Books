
import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:flutter/foundation.dart';

import '../Data/buildQuery.dart';
import '../Data/db.dart';

class BookListState extends ChangeNotifier {

  BookListState(this.database);

  final DB database;
  int? currClassLevel;

  String? currBookId;

  Stream<List<Book>> streamBooks(int? currClassLevel) async*{
    String query = BuildQuery.buildBookListQuery(currClassLevel);

    yield* database.streamLiveDocs(query).asyncMap((change) {
      return change.results
          .asStream()
          .map((result) => database.toEntity(Book.fromJson, result))
          .toList();
    });
  }

  void setCurrBookId(String? id) {
    currBookId = id;
    notifyListeners();
  }

  void setCurrClassLevel(int selectedLevel) {
    if(selectedLevel != currClassLevel) {
      currClassLevel = selectedLevel;
      currBookId = null;
      notifyListeners();
    }
  }

}