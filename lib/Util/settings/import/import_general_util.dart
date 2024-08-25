
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