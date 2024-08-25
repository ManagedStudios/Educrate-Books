import '../../../Data/settings/excel_data.dart';
import '../../../Data/settings/student_excel_mapper_attributes.dart';
import '../../../Resources/text.dart';

String? updateHeaderToAttributeError(
    Map<ExcelData, StudentAttributes?> headerToAttribute) {
  // A set to store the missing attributes
  Set<StudentAttributes> missingAttributes = {StudentAttributes.FIRSTNAME, StudentAttributes.LASTNAME, StudentAttributes.CLASS};

  // Iterate through the values in the map and remove any found attributes from missingAttributes
  for (var attribute in headerToAttribute.values) {
    if (attribute != null) {
      missingAttributes.remove(attribute);
    }
  }
  // If no attributes are missing, clear the error
  if (missingAttributes.isEmpty) {
    return null;
  } else {
    // Otherwise, rebuild the error string
    final buffer = StringBuffer();
    for (var attribute in missingAttributes) {
      buffer.write("${attribute.getLabelText()} ");
    }
    buffer.write(TextRes.areMandatory);
    return buffer.toString();
  }
}