
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
  }

  Future<void> saveDocument(MutableDocument document) async{
      _database.saveDocument(document);
  }

  /*
  generic method to retrieve a stream of a resultSet from the database which is
  based on a query provided as argument. Used when query changes have to be tracked.

  IMPORTANT: security risk when using dynamic arguments or user inputs for the query argument,
   as every query is executed. Always provide hardcoded queries to this method!
   */
  Stream<QueryChange<ResultSet>> streamLiveDocs(String query) async*{
    try {
      final queryRes = await Query.fromN1ql(_database, query); //build query
      yield* queryRes.changes(); //pass the generic stream of the build query
      /*
      handle db specific errors in order to prevent duplicate error handling
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

  Future<void> deleteDoc(Document document) async {
    _database.deleteDocument(document);
  }

  Future<void> startReplication () async{
    final replicator = await Replicator.create(ReplicatorConfiguration(database: _database,
        target: UrlEndpoint(Uri.parse('ws://localhost:4984/buecherteam')),
        continuous: true,
        replicatorType: ReplicatorType.pushAndPull,
        authenticator: BasicAuthenticator(username: "dibbo", password: "dibboMrinmoy"),
    ));

    await replicator.start();
  }

  void updateDocFromEntity(Object entity, MutableDictionaryInterface document) {
    final json = (entity as dynamic).toJson() as Map<String, Object?>;
    if (document is MutableDocument) {
      json.remove(TextRes.studentIdJson);
    }
    document.setData(json);
  }


  T toEntity<T>(T Function(Map<String, Object?> json) fromJson, DictionaryInterface result) {
    final json = result.toPlainMap();
    if (result case Document(:final id)) {
      json[TextRes.studentIdJson] = id;
    }
    return fromJson(json);
  }

}

