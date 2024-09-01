
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

HashSet<TrainingDirectionsData> getUniqueTrainingDirectionsOf
    (Sheet sheet,
    Map<StudentAttributes, List<ExcelData>> studentAttributeToHeaders) {
  HashSet<TrainingDirectionsData> res = HashSet();

  for (int i = 1; i<sheet.maxRows; i++) {
    for (ExcelData data in
    studentAttributeToHeaders[StudentAttributes.TRAININGDIRECTION]!){
      String? tr = sheet.row(i)[data.column]?.value.toString().trim();
      if (tr != null) res.add(TrainingDirectionsData(tr));
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

