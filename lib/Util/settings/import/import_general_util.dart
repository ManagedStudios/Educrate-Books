
import 'dart:collection';

import 'package:excel/excel.dart';

import '../../../Data/class_data.dart';
import '../../../Data/settings/excel_data.dart';
import '../../../Data/settings/student_excel_mapper_attributes.dart';
import '../../../Data/training_directions_data.dart';
import '../../parser.dart';

List<StudentAttributes> getUpdatedAvailableAttributes (List<StudentAttributes?> currAvailableStudentAttributes) {
  List<StudentAttributes> updatedAvailableStudentAttributes = StudentAttributes.values.toList();
  for (StudentAttributes? value in currAvailableStudentAttributes) {
    if(value == StudentAttributes.FIRSTNAME || value == StudentAttributes.LASTNAME || value == StudentAttributes.CLASS) {
      updatedAvailableStudentAttributes.remove(value);
    }
  }
  return updatedAvailableStudentAttributes;
}

Map<StudentAttributes, List<ExcelData>> getStudentAttributesToHeadersFrom
    (Map<ExcelData, StudentAttributes?> headerToAttrb) {

  Map<StudentAttributes, List<ExcelData>> res = {
    StudentAttributes.FIRSTNAME:<ExcelData>[],
    StudentAttributes.LASTNAME:<ExcelData>[],
    StudentAttributes.CLASS:<ExcelData>[],
    StudentAttributes.TRAININGDIRECTION:<ExcelData>[],
    StudentAttributes.TAGS:<ExcelData>[],
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
      String? trainingDirectionValue = sheet.row(i)[data.column]?.value.toString().trim();
      String? classLevel = sheet.row(i)[columnClass]?.value.toString().trim();

      if (trainingDirectionValue != null && classLevel != null) {
        ClassData classData = parseStringToClass(classLevel);
        res[TrainingDirectionsData(trainingDirectionValue)] ??=Set<int>();
        res[TrainingDirectionsData(trainingDirectionValue)]!.add(classData.classLevel);
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
      String? cellValue = sheet.row(i)[data.column]?.value.toString().trim();
      if (cellValue != null) {
        ClassData classData = parseStringToClass(cellValue);
        res.add(classData);
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

