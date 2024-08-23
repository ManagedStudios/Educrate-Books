import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';

import '../Data/buildQuery.dart';
import '../Data/db.dart';
import '../Resources/text.dart';

class BookDepotState extends ChangeNotifier {
  BookDepotState(this.database);

  final DB database;
  int? currClassLevel;

  String? currBookId;

  /*
  main/entry method that streams the up to date books for a given classLevel

   */
  Stream<List<Book>> streamBooks(int? currClassLevel) async* {
    String query = BuildQuery.buildBookListQuery(currClassLevel);

    yield* database.streamLiveDocs(query).asyncMap((change) {
      return change.results.asStream().map((result) {
        return database.toEntity(Book.fromJson, result);
      }).toList();
    });
  }

  void setCurrBookId(String? id) {
    currBookId = id;
    notifyListeners();
  }

  void setCurrClassLevel(int selectedLevel) {
    if (selectedLevel != currClassLevel) {
      currClassLevel = selectedLevel;
      currBookId = null;
      notifyListeners();
    }
  }

  /*
  save trainingDirections that do not exist in the DB
   */
  Future<void> saveTrainingDirectionsIfNotAvailable(
      List<String> trainingDirections) async {
    for (var trainingDirection in trainingDirections) {
      if (!await trainingDirectionExists(trainingDirection)) {
        final document = MutableDocument();
        database.updateDocFromEntity(
            TrainingDirectionsData(trainingDirection), document);
        await database.saveDocument(document);
      }
    }
  }

  /*
  checks if a trainingDirection with given label exists in the database
   */
  Future<bool> trainingDirectionExists(String trainingDirection) async {
    String query = BuildQuery.getSingleTrainingDirection(trainingDirection);

    var docs = await database.getDocs(query);
    var results = await docs.allResults();

    return results.isNotEmpty;
  }

  Future<void> saveBook(String bookName, String bookSubject, int classLevel,
      List<String> trainingDirections, String? isbnNumber, int amount) async {
    final document = createNewBookDocument(bookName, bookSubject, classLevel,
        trainingDirections, isbnNumber, amount);
    await database.saveDocument(document);
    saveTrainingDirectionsIfNotAvailable(trainingDirections);
  }

  MutableDocument createNewBookDocument(
      String bookName,
      String bookSubject,
      int classLevel,
      List<String> trainingDirections,
      String? isbnNumber,
      int amount) {
    final document =
        MutableDocument(); //create empty MutableDocument to retrieve books id
    final book = Book(
        bookId: document.id,
        name: bookName,
        subject: bookSubject,
        classLevel: classLevel,
        trainingDirection: trainingDirections,
        amountInStudentOwnership: 0,
        nowAvailable: amount,
        totalAvailable: amount,
        isbnNumber: isbnNumber);
    database.updateDocFromEntity(book, document);
    return document;
  }

  /*
  called when book is deleted
  purpose: if trainingDirection is to no book attached it is useless and should be deleted
  this is what happens here. Check if any trainingDirections of the book are useless and delete them
   */
  Future<void> deleteTrainingDirectionsIfRequired(String currBookId) async {
    /*
    first retrieve the trainingDirections of the d
     */
    final bookDoc = (await database.getDoc(currBookId))!.toMutable();
    Book book = database.toEntity(Book.fromJson, bookDoc);
    List<String> trainingDirections = book.trainingDirection;

    for (String trainingDirection in trainingDirections) {
      if (!await trainingDirectionIsObtainedByOtherBook(trainingDirection)) {
        String query = BuildQuery.getSingleTrainingDirection(trainingDirection);
        final trainingDirectionDocs = await database.getDocs(query);
        await for (var trainingDirection in trainingDirectionDocs.asStream()) {
          final String trainingId =
              trainingDirection.toPlainMap()[TextRes.idJson] as String;
          final trainingDoc = await database.getDoc(trainingId);
          database.deleteDoc(trainingDoc!);
        }
      }
    }
  }

  Future<bool> trainingDirectionIsObtainedByOtherBook(
      String trainingDirection) async {
    String query = BuildQuery.getBooksOfTrainingDirections([trainingDirection]);

    var docs = await database.getDocs(query);
    var results = await docs.allResults();

    return results.length > 1;
  }

  Future<bool> haveStudentsThisBook(String bookId) async {
    String query = BuildQuery.getStudentsOfBook(bookId);

    var docs = await database.getDocs(query);
    var results = await docs.allResults();

    return results
        .isNotEmpty; //notEmpty means there are students who own the given book
  }

  Future<Book> getBook(String bookId) async {
    var doc = (await database.getDoc(bookId))!.toMutable();
    final book = database.toEntity(Book.fromJson, doc);

    return book;
  }

  Future<void> updateBook(Book book) async {
    final doc = (await database.getDoc(book.id))!.toMutable();
    database.updateDocFromEntity(book, doc);
    database.saveDocument(doc);
    saveTrainingDirectionsIfNotAvailable(book.trainingDirection);
  }

  /*
  book detail methods
   */

  Stream<List<Book>> streamBookDetails(String? bookId) async* {
    String query = BuildQuery.buildBookDetailQuery(bookId);

    yield* database.streamLiveDocs(query).asyncMap((change) {
      //asyncMap required as the data is asynchronously fetched from the Web
      return change.results
          .asStream()
          .map((result) => database.toEntity(
              Book.fromJson, result)) //build Book objects from JSON
          .toList();
    });
  }
}
