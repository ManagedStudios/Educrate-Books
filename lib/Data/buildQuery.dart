
import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class BuildQuery {

  /*
  WICHTIG beim query builden: Enter werden auch als Zeichen gesehen und führen
  zu Fehlern
  Am besten beim erstellen einer Query einfach eine vorherige query copy pasten und bearbeiten
  SELECT FROM Und WHERE an derselben Stelle lassen!!!
   */

  static String buildStudentListQuery (String? ftsQuery, Filter? filterOptions) {
    String ftsQueryMatch = "";
    String orderClause = "ORDER BY ${TextRes.studentClassLevelJson}, ${TextRes.studentClassCharJson}, ${TextRes.studentLastNameJson}";

    if(ftsQuery != null) {
      ftsQueryMatch = "AND MATCH(${TextRes.ftsStudent}, '$ftsQuery')";
    }

    String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson}, ${TextRes.studentAmountOfBooksJson}, ${TextRes.studentTagsJson} FROM _ 
      WHERE ${TextRes.typeJson}='${TextRes.studentTypeJson}' """;
    query+=ftsQueryMatch;
    query+=orderClause;

    return query;
  }

  static String getAllClassesQuery() {
    String query = """SELECT META().id, ${TextRes.classDataClassLevelJson}, 
      ${TextRes.classDataClassCharJson} FROM _ 
      WHERE ${TextRes.typeJson}='${TextRes.classDataTypeJson}' """;

    return query;
  }

  static String getAllTrainingDirections() {
    String query = """SELECT ${TextRes.trainingDirectionsJson} FROM _
    WHERE ${TextRes.typeJson}='${TextRes.trainingDirectionsTypeJson}' """;

    return query;
  }
}