
import 'dart:async';


import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:cbl/cbl.dart';

class DB {
  static final DB _instance = DB._internal();

  factory DB () {
    return _instance;
  }

  late final Database _database;

  DB._internal();


  Future<void> initializeDatabase() async {
    _database = await Database.openAsync(TextRes.dbName);
    final typeIndex = ValueIndexConfiguration(['type']);
    final bookClassLevelIndex = ValueIndexConfiguration([TextRes.bookClassLevelJson]);
    final trainingDirectionIndex = ValueIndexConfiguration([TextRes.trainingDirectionsJson]);
    final searchBooksOfTrainingDirectionsIndex = ValueIndexConfiguration([
        TextRes.typeJson, TextRes.bookTrainingDirectionJson
      ]
    );

    final studentsOfBookIdIndex = ValueIndexConfiguration([
      "${TextRes.studentBooksJson}.${TextRes.bookIdJson}"
    ]);
    final ftsIndex = FullTextIndexConfiguration([
      TextRes.studentFirstNameJson,
      TextRes.studentLastNameJson,
      TextRes.studentClassLevelJson,
      TextRes.studentClassCharJson,
      TextRes.studentTrainingDirectionsJson
    ]);



    final bookFtsIndex = FullTextIndexConfiguration([
      TextRes.bookNameJson,
      TextRes.bookSubjectJson,
      TextRes.bookClassLevelJson,
      TextRes.bookTrainingDirectionJson
    ]);
    await _database.createIndex("Types", typeIndex);
    await _database.createIndex(TextRes.ftsStudent, ftsIndex);
    await _database.createIndex(TextRes.ftsBookStudentDetail, bookFtsIndex);
    await _database.createIndex(TextRes.bookClassLevelJsonIndex, bookClassLevelIndex);
    await _database.createIndex(TextRes.trainingDirectionsJsonIndex, trainingDirectionIndex);
    await _database.createIndex(TextRes.booksOfTrainingDirectionsIndex, searchBooksOfTrainingDirectionsIndex);
    await _database.createIndex(TextRes.studentsOfBookIdIndex, studentsOfBookIdIndex);

  }

  Future<void> saveDocument(MutableDocument document) async{
      _database.saveDocument(document);
  }

  /*
  generic method to retrieve a stream of generic db results from the database which is
  based on a query provided as argument. Used when query changes have to be tracked.
  Everytime data changes the stream yields a new QueryChange containing the results as resultSet

  IMPORTANT: security risk when using dynamic arguments or user inputs for the query argument,
   as every query is executed. Always provide hardcoded queries to this method!
   */
  Stream<QueryChange<ResultSet>> streamLiveDocs(String query) async*{
    try {
      final queryRes = await Query.fromN1ql(_database, query); //build query
      yield* queryRes.changes(); //pass the generic stream of the build query
      /*
      handle db specific errors in order to prevent duplicate error handling further down the line
       */
    } on DatabaseException catch(e) {
      throw Exception("${TextRes.dbAccesError} ${e.message}");
    } on TimeoutException catch(e) {
      throw Exception("${TextRes.timeOutException} ${e.message}");
    }
  }


  /*
    Method to get a standalone queryResult

    IMPORTANT: security risk when using dynamic arguments or user inputs for the query argument,
   as every query is executed. Always provide hardcoded queries to this method!
   */
  Future<ResultSet> getDocs(String query) async {
    final queryRes = await Query.fromN1ql(_database, query);
    return queryRes.execute();
  }

  /*
  retrieve single document with its id
   */

  Future<Document?> getDoc (String docId) async {
    return _database.document(docId);
  }

  /*
  Delete a single document that is provided
   */
  Future<void> deleteDoc(Document document) async {
    _database.deleteDocument(document);
  }

  /*
  delete multiple documents in a batch
   */

  Future<void> deleteDocs (List<Document> documents) async {
    _database.inBatch(() async {
      for(Document document in documents) {
        await _database.deleteDocument(document);
      }
    });
  }

  /*
  Change multiple documents in a batch from respective entities
   */

  Future<void> changeDocsFromEntities (List<Document> documents, List<Object> entities) async{
    if (documents.length != entities.length) {
      throw ArgumentError("Document List has a different length to the belonging entities");
    }
    _database.inBatch(() async {
      for (int i=0;i<documents.length;i++) {
        final doc = documents[i].toMutable();
        final entity = entities[i];
        updateDocFromEntity(entity, doc);
        saveDocument(doc);
      }
    });
  }

  /*
  startReplication is responsible for handling the sync between local couchbase lite
  db and couchbase server
   */

  Future<void> startReplication () async{
    final replicator = await Replicator.create(ReplicatorConfiguration(database: _database,
        target: UrlEndpoint(Uri.parse('ws://localhost:4984/buecherteam')), //The URI your reverse proxy server or your sync gateway is located - ws is websocket
        continuous: true,
        replicatorType: ReplicatorType.pushAndPull,
        authenticator: BasicAuthenticator(username: "dibbo", password: "dibboMrinmoy"),
    ));

    await replicator.start();
  }

  /*
  updateDocFromEntity updates a MutableDocument sothat its data matches the provided object
  the provided object needs to provide a toJson method in order to utilize updateDocFromEntity
  updateDocFromEntity can be used for completely blank docs or for filled document that need to be updated.
  Updates are basically just overwrites by the object.
   */
  void updateDocFromEntity(Object entity, MutableDictionaryInterface document) {
    final json = (entity as dynamic).toJson() as Map<String, Object?>;
    if (document is MutableDocument) {
      json.remove(TextRes.studentIdJson);
    }
    document.setData(json);
  }

  /*
  to Entity can transform database results in form of documents or results to real objects.
  The class the desired object belongs to needs to provide a fromJson method that serializes
  the json data.
   */

  T toEntity<T>(T Function(Map<String, Object?> json) fromJson, DictionaryInterface result) {
    final json = result.toPlainMap();
    if (result case Document(:final id)) {
      json[TextRes.studentIdJson] = id;
    }
    return fromJson(json);
  }


}

