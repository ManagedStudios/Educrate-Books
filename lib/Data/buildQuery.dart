import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class BuildQuery {
  static String noResultQuery = "SELECT * FROM _default WHERE 1 = 0";
  /*
  WICHTIG beim query builden: Enter werden auch als Zeichen gesehen und führen
  zu Fehlern
  Am besten beim erstellen einer Query einfach eine vorherige query copy pasten und bearbeiten
  SELECT FROM Und WHERE an derselben Stelle lassen!!!
   */

  static String buildStudentListQuery(String? ftsQuery, Filter? filterOptions) {
    String ftsQueryMatch = "";
    String orderClause =
        "ORDER BY ${TextRes.studentClassLevelJson}, ${TextRes.studentClassCharJson}, ${TextRes.studentLastNameJson}";

    if (ftsQuery != null) {
      ftsQueryMatch = "AND MATCH(${TextRes.ftsStudent}, '$ftsQuery')";
    }

    String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson}, ${TextRes.studentAmountOfBooksJson}, ${TextRes.studentTagsJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.studentTypeJson}' """;
    query += ftsQueryMatch;
    query += orderClause;

    return query;
  }

  static String getAllClassesQuery() {
    String query = """SELECT META().id, ${TextRes.classDataClassLevelJson}, 
      ${TextRes.classDataClassCharJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.classDataTypeJson}' """;

    return query;
  }

  static String getAllTrainingDirections() {
    String query = """SELECT META().id, ${TextRes.trainingDirectionsJson} FROM _default
    WHERE ${TextRes.typeJson}='${TextRes.trainingDirectionsTypeJson}' """;

    return query;
  }

  static String getAllStudents() {
    String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson}, ${TextRes.studentAmountOfBooksJson}, ${TextRes.studentTagsJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.studentTypeJson}' """;

    return query;
  }

  static String buildStudentDetailQuery(List<String> studentIds) {
    if (studentIds.isEmpty) return noResultQuery;
    String whereClause =
        """AND META().id IN [${studentIds.map((e) => """'$e'""").join(",")}]""";

    String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson}, ${TextRes.studentAmountOfBooksJson}, ${TextRes.studentTagsJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.studentTypeJson}' """;

    query += whereClause;

    return query;
  }

  static String buildStudentDetailBookAddQuery(String? searchQuery) {
    String ftsQueryMatch = "";

    if (searchQuery != null) {
      ftsQueryMatch =
          "AND MATCH(${TextRes.ftsBookStudentDetail}, '$searchQuery')";
    }
    String query = """SELECT META().id, ${TextRes.bookNameJson}, 
      ${TextRes.bookSubjectJson}, ${TextRes.bookClassLevelJson}, 
      ${TextRes.bookTrainingDirectionJson}, ${TextRes.bookAmountInStudentOwnershipJson},
      ${TextRes.bookNowAvailableJson}, ${TextRes.bookTotalAvailableJson}, 
      ${TextRes.bookIsbnNumberJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.bookTypeJson}' """;
    query += ftsQueryMatch;

    return query;
  }

  static String getAllClassLevels() {

    String orderClause =
        "ORDER BY ${TextRes.classDataClassLevelJson}";

    String query = """SELECT DISTINCT ${TextRes.classDataClassLevelJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.classDataTypeJson}' """;
    query+=orderClause;

    return query;
  }

  static String getBooksOfClassLevel(int? currClassLevel) {
    if (currClassLevel == null) return noResultQuery;

    String whereClause =
        """AND ${TextRes.bookClassLevelJson}=$currClassLevel""";

    String query = """SELECT META().id, ${TextRes.bookNameJson}, 
      ${TextRes.bookSubjectJson}, ${TextRes.bookClassLevelJson}, 
      ${TextRes.bookTrainingDirectionJson}, ${TextRes.bookAmountInStudentOwnershipJson},
      ${TextRes.bookNowAvailableJson}, ${TextRes.bookTotalAvailableJson}, 
      ${TextRes.bookIsbnNumberJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.bookTypeJson}' """;
    query += whereClause;

    return query;
  }

  static String getSingleTrainingDirection(String trainingDirection) {
    String whereClause =
        """AND ${TextRes.trainingDirectionsJson}='$trainingDirection'""";

    String query = """SELECT META().id, ${TextRes.trainingDirectionsJson} FROM _default
    WHERE ${TextRes.typeJson}='${TextRes.trainingDirectionsTypeJson}' """;
    query += whereClause;

    return query;
  }

  static String getBooksOfTrainingDirections(List<String> trainingDirections) {
    String formattedTrainingDirections =
        "[${trainingDirections.map((tr) => """'$tr'""").join(", ")}]";

    String whereClause = """AND 
    ANY td IN ${TextRes.bookTrainingDirectionJson} 
    SATISFIES (td IN $formattedTrainingDirections) END;""";

    String query = """SELECT META().id, ${TextRes.bookNameJson}, 
      ${TextRes.bookSubjectJson}, ${TextRes.bookClassLevelJson}, 
      ${TextRes.bookTrainingDirectionJson}, ${TextRes.bookAmountInStudentOwnershipJson},
      ${TextRes.bookNowAvailableJson}, ${TextRes.bookTotalAvailableJson}, 
      ${TextRes.bookIsbnNumberJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.bookTypeJson}' """;
    query += whereClause;

    return query;
  }

  static String getStudentsOfBook(String bookId) {
    String whereClause =
        """AND ANY book IN ${TextRes.studentBooksJson} SATISFIES book.${TextRes.bookIdJson} = '$bookId' END;""";

    String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson}, ${TextRes.studentAmountOfBooksJson}, ${TextRes.studentTagsJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.studentTypeJson}' """;

    query += whereClause;

    return query;
  }

  static String buildBookDetailQuery(String? bookId) {
    String whereClause = """AND META().id = '$bookId'""";
    String query = """SELECT META().id, ${TextRes.bookNameJson}, 
      ${TextRes.bookSubjectJson}, ${TextRes.bookClassLevelJson}, 
      ${TextRes.bookTrainingDirectionJson}, ${TextRes.bookAmountInStudentOwnershipJson},
      ${TextRes.bookNowAvailableJson}, ${TextRes.bookTotalAvailableJson}, 
      ${TextRes.bookIsbnNumberJson}, ${TextRes.bookPublisherJson},
      ${TextRes.bookPriceJson}, ${TextRes.bookAdmissionNumberJson},
      ${TextRes.bookFollowingBookJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.bookTypeJson}' """;
    query += whereClause;

    return query;
  }

  static String getBooksSubceedingAvAmount(int ofClassLevel, int amount) {
    String whereClause = """AND ${TextRes.bookNowAvailableJson} < $amount
      AND ${TextRes.bookClassLevelJson} = $ofClassLevel""";
    String query = """SELECT META().id, ${TextRes.bookNameJson}, 
      ${TextRes.bookSubjectJson}, ${TextRes.bookClassLevelJson}, 
      ${TextRes.bookTrainingDirectionJson}, ${TextRes.bookAmountInStudentOwnershipJson},
      ${TextRes.bookNowAvailableJson}, ${TextRes.bookTotalAvailableJson}, 
      ${TextRes.bookIsbnNumberJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.bookTypeJson}' """;
    query += whereClause;

    return query;
  }

  static String getAllTagsQuery() {
    String query = """SELECT META().id, ${TextRes.tagDataLabelJson}, 
    ${TextRes.tagDataColorJson} FROM _default
    WHERE ${TextRes.typeJson}='${TextRes.tagDataTypeJson}' """;

    return query;
  }

  static String getTagsOfQuery(List<String> tags) {
    String formattedTags =
        "[${tags.map((tag) => """'$tag'""").join(", ")}]";

    String whereClause = """AND 
    ANY tagL IN $formattedTags 
    SATISFIES ${TextRes.tagDataLabelJson}=tagL END;""";

    String query = """SELECT META().id, ${TextRes.tagDataLabelJson}, 
    ${TextRes.tagDataColorJson} FROM _default
    WHERE ${TextRes.typeJson}='${TextRes.tagDataTypeJson}' """;
    query+=whereClause;

    return query;
  }

  static String getAllBooks () {

    String query = """SELECT META().id, ${TextRes.bookNameJson}, 
      ${TextRes.bookSubjectJson}, ${TextRes.bookClassLevelJson}, 
      ${TextRes.bookTrainingDirectionJson}, ${TextRes.bookAmountInStudentOwnershipJson},
      ${TextRes.bookNowAvailableJson}, ${TextRes.bookTotalAvailableJson}, 
      ${TextRes.bookIsbnNumberJson}, ${TextRes.bookPublisherJson},
      ${TextRes.bookPriceJson}, ${TextRes.bookAdmissionNumberJson},
      ${TextRes.bookFollowingBookJson} FROM _default 
      WHERE ${TextRes.typeJson}='${TextRes.bookTypeJson}' """;


    return query;
  }


}
