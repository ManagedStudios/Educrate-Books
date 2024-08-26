import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/import_general_util.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/io_util.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../Data/db.dart';
import '../../Data/settings/excel_data.dart';
import '../../Data/settings/student_excel_mapper_attributes.dart';
import '../../Util/settings/import/import_errors_util.dart';

class ImportState extends ChangeNotifier {
  ImportState(this.database);

  final DB database;

  /*
  Excel header to attributes Screen
   */
  List<StudentAttributes> availableStudentAttributes = StudentAttributes.values;
  Map<ExcelData, StudentAttributes?> currHeaderToAttributeMap = {};

  String? currHeaderToAttributeError = "${StudentAttributes.FIRSTNAME.getLabelText()} "
      "${StudentAttributes.LASTNAME.getLabelText()} ${StudentAttributes.CLASS.getLabelText()} "
      "${TextRes.areMandatory}";

  /*
  Import options
   */

  bool isClassWithoutCharAllowed = false;
  bool updateExistingStudents = false;

  /*
  Select Excel file screen
   */
  String? importFileName;
  Excel? excelFile;
  String? selectExcelFileError = TextRes.selectExcelFileError;



  void setCurrHeaderToAttributeMap(Map<ExcelData, StudentAttributes?> headerToAttribute) {
    currHeaderToAttributeMap = headerToAttribute;
    availableStudentAttributes = getUpdatedAvailableAttributes(currHeaderToAttributeMap.values.toList());
    currHeaderToAttributeError = updateHeaderToAttributeError(headerToAttribute);
    notifyListeners();

  }

  void setImportFileName (String? fileName) {
    importFileName = fileName;
    notifyListeners();
  }

  Future<void> getImportFile() async{
    FilePickerResult? filePickerResult = await getFilePickerResult();
    if (filePickerResult == null) return;
    importFileName = getFileNameOf(filePickerResult);
    excelFile = getExcelFileOf(filePickerResult);
    selectExcelFileError = null;
    notifyListeners();
  }

  void setIsClassWithoutCharAllowed(bool allowClassWithoutChar) {
    isClassWithoutCharAllowed = allowClassWithoutChar;
  }

  void setUpdateExistingStudent(bool updateExistingStudents) {
    this.updateExistingStudents = updateExistingStudents;
  }



  Future<bool> getExcelHeaders() async{
    if (excelFile == null) throw Exception(TextRes.selectExcelFileError);
    if (excelFile!.sheets.length != 1) throw Exception(TextRes.excelFileTooManySheetsError);
    Sheet sheet = excelFile!.sheets.values.first;
    List<Data?> headerRow = sheet.row(0);


    if (headerRow.isEmpty || (headerRow.length == 1 && headerRow.first == null)) {
      throw Exception(TextRes.excelNoHeaderError);
    }
    for (Data? cell in headerRow) {
        if (cell != null) {
          currHeaderToAttributeMap[
            ExcelData(
              row: cell.rowIndex,
              column: cell.columnIndex,
                content: cell.value.toString())] = null;
        }
    }
    return true;
  }
}


