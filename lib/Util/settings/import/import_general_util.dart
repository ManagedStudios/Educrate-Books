
import 'dart:collection';
import 'dart:ui';

import 'package:excel/excel.dart';

import '../../../Data/class_data.dart';
import '../../../Data/db.dart';
import '../../../Data/settings/excel_data.dart';
import '../../../Data/settings/student_excel_mapper_attributes.dart';
import '../../../Data/tag_data.dart';
import '../../../Data/training_directions_data.dart';
import '../../database/getter.dart';
import '../../parser.dart';

/*
Make first name, last name and class only selectable once
 */
List<StudentAttributes> getUpdatedAvailableAttributes (List<StudentAttributes?> currAvailableStudentAttributes) {
  List<StudentAttributes> updatedAvailableStudentAttributes = StudentAttributes.values.toList();
  for (StudentAttributes? value in currAvailableStudentAttributes) {
    if(value == StudentAttributes.FIRSTNAME || value == StudentAttributes.LASTNAME || value == StudentAttributes.CLASS) {
      updatedAvailableStudentAttributes.remove(value);
    }
  }
  return updatedAvailableStudentAttributes;
}

/*
sum up all excel cells that have the same StudentAttribute assigned
Transform ExcelCells(ExcelData) mapped to one StudentAttribute to
Studentattribute to a List of ExcelCells
 */
Map<StudentAttributes, List<ExcelData>> getStudentAttributesToHeadersFrom
    (Map<ExcelData, StudentAttributes?> headerToAttrb) {

  Map<StudentAttributes, List<ExcelData>> res = {
    StudentAttributes.FIRSTNAME:<ExcelData>[],
    StudentAttributes.LASTNAME:<ExcelData>[],
    StudentAttributes.CLASS:<ExcelData>[],
    StudentAttributes.TRAININGDIRECTION:<ExcelData>[],
    StudentAttributes.TAG:<ExcelData>[],
  };

  for (MapEntry<ExcelData, StudentAttributes?> entry in headerToAttrb.entries) {
    res[entry.value]?.add(entry.key);
  }

  return res;
}


Map<TrainingDirectionsData, Set<int>> getUniqueTrainingDirectionsOf
    (Sheet sheet,
    Map<StudentAttributes, List<ExcelData>> studentAttributeToHeaders) {
  Map<TrainingDirectionsData, Set<int>> res = {};

  for (int i = 1; i<sheet.maxRows; i++) {
    for (ExcelData data in
    studentAttributeToHeaders[StudentAttributes.TRAININGDIRECTION]!){
      //TODO I have used Null-Check operators, would be great to avoid them for class
      int columnClass = studentAttributeToHeaders[StudentAttributes.CLASS]!.first.column;
      //use cellValues instead of strings since .toString() transforms null in just "null"!!!
      CellValue? trainingDirectionValue = sheet.row(i)[data.column]?.value;
      CellValue? classLevel = sheet.row(i)[columnClass]?.value;

      if (trainingDirectionValue != null && classLevel != null) {
        ClassData classData = parseStringToClass(classLevel.toString());
        res[TrainingDirectionsData(trainingDirectionValue.toString())] ??=Set<int>();
        res[TrainingDirectionsData(trainingDirectionValue.toString())]!.add(classData.classLevel);
      }
    }
  }

  return res;
}

HashSet<ClassData> getUniqueClassesOf
    (Sheet sheet,
    Map<StudentAttributes, List<ExcelData>> studentAttributeToHeaders) {
  HashSet<ClassData> res = HashSet();

  for (int i = 1; i<sheet.maxRows; i++) {
    for (ExcelData data in
    studentAttributeToHeaders[StudentAttributes.CLASS]!){
      CellValue? cellValue = sheet.row(i)[data.column]?.value;
      if (cellValue != null) {
        ClassData classData = parseStringToClass(cellValue.toString());
        res.add(classData);
      }

    }
  }

  return res;

}

Future<HashSet<TagData>> getUniqueTagsOf(Sheet sheet,
    Map<StudentAttributes, List<ExcelData>> currStudentAttributeToHeaders, DB database) async{

  HashSet<TagData> res = HashSet();
  Set<Color> usedColors = (await getAllTagDataUtil(database))
                                      .map((e) => e.color).toSet();

  for (int i=0;i<sheet.maxRows; i++) {
    for (ExcelData data in
        currStudentAttributeToHeaders[StudentAttributes.TAG]!) {
      CellValue? cellValue = sheet.row(i)[data.column]?.value;
      if (cellValue != null) {
        Color tagColor = getTagColor(usedColors);
        TagData tagData = TagData(cellValue.toString().toUpperCase(), tagColor);
        usedColors.add(tagColor);
        res.add(tagData);
      }
    }
  }

  return res;


}



List<int> getUniqueClassLevelsFrom(HashSet<ClassData> uniqueClasses) {
  Set<int> classLevels = {};
  for (ClassData data in uniqueClasses) {
    classLevels.add(data.classLevel);
  }
  return classLevels.toList();
}

