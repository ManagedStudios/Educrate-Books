
import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:cbl/cbl.dart';
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

  Future<void> saveTrainingDirectionsIfNotAvailable (List<String> trainingDirections) async{
    for (var trainingDirection in trainingDirections) {
          if (!await trainingDirectionExists(trainingDirection)) {
            final document = MutableDocument();
            database.updateDocFromEntity(TrainingDirectionsData(trainingDirection), document);
            await database.saveDocument(document);
          }
    }
  }

  Future<bool> trainingDirectionExists (String trainingDirection) async {
    String query = BuildQuery.getSingleTrainingDirection(trainingDirection);

    var docs = await database.getDocs(query);
    var results = await docs.allResults();

    return results.isNotEmpty;
  }

  Future<void> saveBook (String bookName, String bookSubject, int classLevel,
      List<String> trainingDirections, String? isbnNumber, int amount
      ) async {
    final document = createNewBookDocument(bookName, bookSubject, classLevel, trainingDirections, isbnNumber, amount);
    await database.saveDocument(document);
    saveTrainingDirectionsIfNotAvailable(trainingDirections);
  }

  MutableDocument createNewBookDocument(String bookName, String bookSubject, int classLevel,
      List<String> trainingDirections, String? isbnNumber, int amount) {
    final document = MutableDocument(); //create empty MutableDocument to retrieve books id
    final book = Book(bookId: document.id, name: bookName, subject: bookSubject, classLevel: classLevel,
        trainingDirection: trainingDirections,
        amountInStudentOwnership: 0, nowAvailable: amount, totalAvailable: amount, isbnNumber: isbnNumber);
    database.updateDocFromEntity(book, document);
    return document;
  }

}