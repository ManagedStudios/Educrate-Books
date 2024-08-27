
import '../../../Data/settings/excel_data.dart';
import '../../../Data/settings/student_excel_mapper_attributes.dart';

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