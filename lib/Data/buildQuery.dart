
import 'package:buecherteam_2023_desktop/Data/filter.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class BuildQuery {

  static String buildStudentListQuery (String? ftsQuery, Filter? filterOptions) {
    String query = """SELECT META().id, ${TextRes.studentFirstNameJson}, 
      ${TextRes.studentLastNameJson}, ${TextRes.studentClassLevelJson}, 
      ${TextRes.studentClassCharJson}, ${TextRes.studentTrainingDirectionsJson},
      ${TextRes.studentBooksJson}, ${TextRes.studentAmountOfBooksJson} FROM _ 
      WHERE ${TextRes.typeJson}='${TextRes.studentTypeJson}' """;

    return query;
  }
}