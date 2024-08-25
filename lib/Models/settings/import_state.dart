import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/import_general_util.dart';
import 'package:flutter/material.dart';

import '../../Data/db.dart';
import '../../Data/settings/excel_data.dart';
import '../../Data/settings/student_excel_mapper_attributes.dart';
import '../../Util/settings/import/import_errors_util.dart';

class ImportState extends ChangeNotifier {
  ImportState(this.database);

  final DB database;

  List<StudentAttributes> availableStudentAttributes = StudentAttributes.values;
  Map<ExcelData, StudentAttributes?> currHeaderToAttributeMap = {
    ExcelData(row: 1, column: 1, content: "hello"):null,
    ExcelData(row: 1, column: 1, content: "hello 1"):null,
    ExcelData(row: 1, column: 1, content: "hello 2"):null,
    ExcelData(row: 1, column: 1, content: "hello 3"):null,
  };

  String? currHeaderToAttributeError = "${StudentAttributes.FIRSTNAME.getLabelText()} "
      "${StudentAttributes.LASTNAME.getLabelText()} ${StudentAttributes.CLASS.getLabelText()} "
      "${TextRes.areMandatory}";

  void setCurrHeaderToAttributeMap(Map<ExcelData, StudentAttributes?> headerToAttribute) {
    currHeaderToAttributeMap = headerToAttribute;
    availableStudentAttributes = getUpdatedAvailableAttributes(currHeaderToAttributeMap.values.toList());
    currHeaderToAttributeError = updateHeaderToAttributeError(headerToAttribute);
    notifyListeners();

  }


}


