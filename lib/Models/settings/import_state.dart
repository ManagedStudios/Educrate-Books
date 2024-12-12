import 'dart:collection';
import 'dart:io';

import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Util/database/delete.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/import_general_util.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/io_util.dart';
import 'package:cbl/cbl.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../Data/db.dart';
import '../../Data/settings/excel_data.dart';
import '../../Data/settings/student_excel_mapper_attributes.dart';

import '../../Util/database/update.dart';
import '../../Util/settings/import/import_add_books.dart';
import '../../Util/settings/import/import_add_missing_classes.dart';
import '../../Util/settings/import/import_errors_util.dart';
import '../../Util/settings/import/students_from_excel.dart';

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
  Excel header to attributes processing and checks -> Excel PreProcessing
   */

  Excel? excelFormatErrors;
  Map<StudentAttributes, List<ExcelData>> currStudentAttributeToHeaders = {};
  List<int> rowsToRemove = [];
  Map<TrainingDirectionsData, Set<int>> uniqueTrainingDirections = {};
  HashSet<ClassData> uniqueClasses = HashSet();

  List<TrainingDirectionsData> availableTrainingDirections = [];

  Map<ExcelData, TrainingDirectionsData?> currTrainingDirectionMap = {};

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

  void setCurrTrainingDirectionMap(Map<ExcelData, TrainingDirectionsData?> trMap) {
    currTrainingDirectionMap = trMap;

    notifyListeners();
  }

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
    currHeaderToAttributeMap = {};
    availableStudentAttributes = StudentAttributes.values;
    currHeaderToAttributeError = "${StudentAttributes.FIRSTNAME.getLabelText()} "
        "${StudentAttributes.LASTNAME.getLabelText()} ${StudentAttributes.CLASS.getLabelText()} "
        "${TextRes.areMandatory}";

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

  /*
  preProcessing checks the Excel file for correct format in rows (checkAndCorrectExcelFile()),
  removes rows that have the wrong format,
  extracts the uniqueTrainingDirections for each class level to allow TrainingDirection Mapping,
  sets up all available classes to decide which classes have to be added,

   */
  Future<bool> preProcessExcel() async{
    currStudentAttributeToHeaders = getStudentAttributesToHeadersFrom(currHeaderToAttributeMap);
    Sheet sheet = excelFile!.sheets.values.first;
    trimExcelFile(excelFile!);
    checkAndCorrectExcelFile();

    for (int i = 0; i<rowsToRemove.length; i++) {
      //reduce the index value of rowsToRemove by i since maxRows is reduced by i due to the row deletions
      //which causes all indices after i to shift upwards
      //IMPORTANT: Works only if rowsToRemove is sorted!
      sheet.removeRow(rowsToRemove[i]-i);
    }


    uniqueTrainingDirections = getUniqueTrainingDirectionsOf(sheet, currStudentAttributeToHeaders);
    uniqueClasses = getUniqueClassesOf(sheet, currStudentAttributeToHeaders);
    List<ClassData>? availableClasses = await getAllClasses(database);
    await addMissingClasses(uniqueClasses, availableClasses, database);
    await getAndStructureTrainingDirections();

    if (excelFormatErrors != null) {
      throw Exception(TextRes.importExcelFormatError);
    }


    return true;
  }

  void checkAndCorrectExcelFile () {
    Sheet sheet = excelFile!.sheets.values.first;

    for (int i = 1; i<sheet.maxRows; i++) {
      String accumulatedFormatError = accumulateFormatErrorsFor(
          sheet.row(i).toList(),
          isClassWithoutCharAllowed,
          currStudentAttributeToHeaders);

      if (accumulatedFormatError.isNotEmpty) {
        if (excelFormatErrors == null) {
           initializeExcelFormatErrorFile();
        }

        //make copy of row that contains format error and add Error Column
        List<CellValue?> errorRow = sheet.row(i).map((e) => e?.value ?? TextCellValue('')).toList();


        errorRow.add(TextCellValue(accumulatedFormatError));
        excelFormatErrors!.sheets.values.first.appendRow(errorRow);
        rowsToRemove.add(i);

      }

    }
  }


  void initializeExcelFormatErrorFile () {

    excelFormatErrors = Excel.createExcel();
    List<CellValue?> headerRow = [];
    for (ExcelData currHeader in currHeaderToAttributeMap.keys) {
      headerRow.add(TextCellValue(currHeader.content));
    }
    headerRow.add(TextCellValue(TextRes.excelFormatErrorComment));
    excelFormatErrors!.sheets.values.first.appendRow(headerRow);
  }

  Future<bool> downloadExcelFormatErrorFile () async{
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: TextRes.saveExcelFormatErrorLabel,
      fileName: TextRes.excelFormatErrorFileName,
    );

    if (outputFile != null) {
      final excelBytes = excelFormatErrors!.encode();

      File(outputFile)
            ..createSync(recursive: true)
            ..writeAsBytesSync(excelBytes!);

      return true;
    } else {
      return false;
    }
  }

  /*
  Create TrainingDirection-Strings of type: tr-classLevel from Map of TrainingDirection
  and class levels that have this trainingDirection
   */
  Future<void> getAndStructureTrainingDirections() async{
    availableTrainingDirections = await getAllTrainingDirectionsUtil(database);
    Map<TrainingDirectionsData, List<int>> uniqueTrainingDirectionsSorted = uniqueTrainingDirections
        .map((key, value) {
          final sortedList = value.toList();
          sortedList.sort();
          return MapEntry(key, sortedList);
    });
    for (MapEntry<TrainingDirectionsData, List<int>> entry in uniqueTrainingDirectionsSorted.entries) {
      for (int level in entry.value) {
        currTrainingDirectionMap[
          ExcelData(
              row: -1,
              column: -1,
              content: "${entry.key.getLabelText()}${TextRes.trainingDirectionHyphen}$level"
          )
        ] = null;
      }
    }
  }

  Future<bool> importStudents() async{
    //0. get all existing students, delete them and update the book amounts accordingly
    // if updateExistingStudents is true create a NameToBooks Map to add their books to the imported successor
    List<Student>? existingStudents;
    //in order to compare the students with the imported ones we combine first and last Name and make a lookup
    Map<String, List<BookLite>>? studentFirstLastNameExistingStudents;

    existingStudents = await getAllStudentsUtil(database);
    await deleteItemsInBatchUtil(existingStudents.map((e) => e.id).toList(), database);
    await updateBookAmountOnStudentsDeletedUtil(existingStudents, database);

    if (updateExistingStudents) {
      studentFirstLastNameExistingStudents = {};
      for (Student student in existingStudents) {
        studentFirstLastNameExistingStudents["${student.firstName}${student.lastName}"] = student.books;
      }
    }

    //1. build a List of Student objects without their books
    List<MutableDocument> studentsToBeImported = getStudentsFromExcel(excelFile!,
        currTrainingDirectionMap,
        currStudentAttributeToHeaders, database);
    //2. Import the students
    await database.saveDocuments(studentsToBeImported);
    await Future.delayed(const Duration(seconds: 1));

    //3. add books to all students according to their trainingDirection and their former student instances
    await addBooksTo(studentsToBeImported, database,
        firstLastNameExistingStudents: studentFirstLastNameExistingStudents);

    //4. Finish Import students
    resetValues();

    return true;
  }

  Future<bool> updateOrCreateStudents() async{

    //1. Create a Set of Student Updates -> Concentrate all Updates to a student in one instance
    //e.g.: [Student1 => tr1, Student1 => tr 2] => [Student1 => [tr1, tr2]]

    List<MutableDocument> studentRowsToBeImported = getStudentsFromExcel(excelFile!,
        currTrainingDirectionMap,
        currStudentAttributeToHeaders, database);
    List<MutableDocument> studentGroupedRowsToBeImported =
                          groupStudentsAccordingToName(studentRowsToBeImported, database);

    //2. query all students
    //3. successively create list of documents with updated or new students

    return true;
  }


  void trimExcelFile(Excel excelFile) {
    Sheet sheet = excelFile.sheets.values.first;
    for (int i = 0; i<sheet.maxRows; i++) {
      final row = sheet.row(i);
      for (int j=0; j<row.length; j++) {
        //the ? is important here since real null values else get transformed to "null" due to .toString()
        String? trimmedCellValue = sheet.cell(CellIndex
            .indexByColumnRow(columnIndex: j, rowIndex: i)).value?.toString().trim();
        if (trimmedCellValue != null) { //update if not null
          sheet.updateCell(CellIndex.indexByColumnRow(
            columnIndex: j, rowIndex: i),
            TextCellValue(trimmedCellValue));
        }
      }
    }
  }

  //always reset after import so another import works smoothly
  void resetValues () {
    availableStudentAttributes = StudentAttributes.values;
    currHeaderToAttributeMap = {};
    currHeaderToAttributeError = "${StudentAttributes.FIRSTNAME.getLabelText()} "
        "${StudentAttributes.LASTNAME.getLabelText()} ${StudentAttributes.CLASS.getLabelText()} "
        "${TextRes.areMandatory}";
    currStudentAttributeToHeaders = {};
    rowsToRemove = [];
    uniqueTrainingDirections = {};
    uniqueClasses = HashSet();
    availableTrainingDirections = [];
    currTrainingDirectionMap = {};
    excelFormatErrors = null;
    isClassWithoutCharAllowed = false;
    updateExistingStudents = false;
    importFileName = null;
    excelFile = null;
    selectExcelFileError = TextRes.selectExcelFileError;

  }



}











