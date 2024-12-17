
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:cbl/cbl.dart';
import 'package:excel/excel.dart';

import '../../../Data/settings/excel_data.dart';
import '../../../Data/settings/student_excel_mapper_attributes.dart';
import '../../../Data/student.dart';
import '../../../Data/training_directions_data.dart';
import '../../parser.dart';
import '../../stringUtil.dart';

List<MutableDocument> getStudentsFromExcel(Excel excelFile,
    Map<ExcelData, TrainingDirectionsData?> currTrainingDirectionMap,
    Map<StudentAttributes, List<ExcelData>> currStudentAttributeToHeaders,
    DB database) {
  //Map strings directly to TrainingDirectionsData
  Map<String, TrainingDirectionsData> finalTrainingDirectionMap =
                      getTrainingDirectionMapFrom(currTrainingDirectionMap);
  Sheet sheet = excelFile.sheets.values.first;

  //define the column numbers of each attribute
  List<int> trainingDirectionColumns =
    currStudentAttributeToHeaders[StudentAttributes.TRAININGDIRECTION]!
          .map((e) => e.column).toList();
  List<int> tagColumns =
          currStudentAttributeToHeaders[StudentAttributes.TAG]!
            .map((e) => e.column).toList();
  int classColumn =
      currStudentAttributeToHeaders[StudentAttributes.CLASS]!.first.column;
  int lastNameColumn =
      currStudentAttributeToHeaders[StudentAttributes.LASTNAME]!.first.column;
  int firstNameColumn =
      currStudentAttributeToHeaders[StudentAttributes.FIRSTNAME]!.first.column;

  List<MutableDocument> res = [];

  //loop over the excel rows to extract all students
    for (int i = 1; i<sheet.maxRows; i++) {
      //the trainingDirection Value With ClassLevel from row
      Set<String> trainingDirections =
              getTrainingDirectionsFromRow
                (sheet.row(i), trainingDirectionColumns, classColumn);
      Set<String> tags =
              getTagsFromRow(sheet.row(i), tagColumns);

      //the trainingDirection used in App
      Set<String> finalMappedTrainingDirections =
          getTrainingDirectionsFromMap(trainingDirections, finalTrainingDirectionMap);

      String? firstName = sheet.row(i)[firstNameColumn]?.value?.toString();
      String? lastName = sheet.row(i)[lastNameColumn]?.value?.toString();
      String? classDataString = sheet.row(i)[classColumn]?.value?.toString();


      if (firstName != null && lastName!=null && classDataString != null) {
        ClassData classData = parseStringToClass(classDataString);
        //every student has the BASIC-X trainingDirection:
        finalMappedTrainingDirections
            .add("${TextRes.basicTrainingDirection}${TextRes.trainingDirectionHyphen}${classData.classLevel}");

        final document = MutableDocument();
        final student = Student(document.id, firstName: firstName, lastName: lastName,
            classLevel: classData.classLevel, classChar: classData.classChar,
            trainingDirections: finalMappedTrainingDirections.toList(), books: [],
            amountOfBooks: 0, tags: tags.toList());

        database.updateDocFromEntity(student, document);
        res.add(document);
      }

    }


  return res;
}

Set<String> getTagsFromRow(List<Data?> row, List<int> tagColumns) {
  Set<String> res = {};

  for (int column in tagColumns) {
    String? tag = row[column]?.value?.toString();
    if (tag != null && !isOnlyWhitespace(tag)) {
      res.add(tag.toUpperCase());
    }
  }
  return res;
}

Set<String> getTrainingDirectionsFromMap
    (Set<String> trainingDirections,
    Map<String, TrainingDirectionsData> finalTrainingDirectionMap) {
  Set<String> res = {};

  for (String trainingDirection in trainingDirections) {
    String? trainingDirectionValue =
        finalTrainingDirectionMap[trainingDirection]?.getLabelText();
    if (trainingDirectionValue != null) {
      res.add(trainingDirectionValue);
    }
  }
  return res;
}

Set<String> getTrainingDirectionsFromRow
    (List<Data?> row, List<int> trainingDirectionColumns, int classColumn) {

  Set<String> res = {};

  for (int column in trainingDirectionColumns) {
    String? label = row[column]?.value?.toString(); //trainingDirection might be empty / null
    String? classString = row[classColumn]?.value?.toString(); //class has to be set
    if (label != null && classString != null) {
      int classLevel = parseStringToClass(classString).classLevel;
      res.add("$label${TextRes.trainingDirectionHyphen}$classLevel");
    }
  }

  return res;

}

Map<String, TrainingDirectionsData> getTrainingDirectionMapFrom
    (Map<ExcelData, TrainingDirectionsData?> currTrainingDirectionMap) {
  Map<String, TrainingDirectionsData> res = {};

  for (MapEntry<ExcelData, TrainingDirectionsData?> entry
          in currTrainingDirectionMap.entries) {
      if (entry.value != null) {
        res[entry.key.content] = entry.value!;
      }
  }

  return res;

}

List<MutableDocument> groupStudentsAccordingToName
            (List<MutableDocument> studentRowsToBeImported, DB database) {

  Map<String, MutableDocument> groupedRows = {};

  for (MutableDocument row in studentRowsToBeImported) {

    if (groupedRows["${row.string(TextRes.studentFirstNameJson)}"
        "${row.string(TextRes.studentLastNameJson)}"] != null) {

      final doc = groupedRows["${row.string(TextRes.studentFirstNameJson)}"
          "${row.string(TextRes.studentLastNameJson)}"];
      final newInformationOfStudent = database.toEntity(Student.fromJson, row);
      final studentToBeUpdated = database.toEntity(Student.fromJson, doc!);
      studentToBeUpdated.addTrainingDirections(newInformationOfStudent.trainingDirections);

      database.updateDocFromEntity(studentToBeUpdated, doc);

      groupedRows["${row.string(TextRes.studentFirstNameJson)}"
          "${row.string(TextRes.studentLastNameJson)}"] = doc;

    } else {

      groupedRows["${row.string(TextRes.studentFirstNameJson)}"
          "${row.string(TextRes.studentLastNameJson)}"] = row;

    }
  }

  return groupedRows.values.toList();

}