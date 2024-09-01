
import 'package:excel/excel.dart';

import '../../../Data/settings/excel_data.dart';
import '../../../Resources/text.dart';
import '../../stringUtil.dart';

String getRowFirstNameError (List<ExcelData> columns, List<Data?> row) {
  StringBuffer errorString = StringBuffer();
  List<Data> cells = getDataOf(columns, row);

  if(cells.isEmpty) {
    errorString.write(TextRes.importFirstNameCannotBeEmptyError);
  }

  for (Data cell in cells) {
    if (isOnlyWhitespace(cell.value.toString())) {
      errorString.write(TextRes.importFirstNameCannotBeEmptyError);
    }
    if (containsNonAlphabetical(cell.value.toString().trim())) {
      errorString.write(TextRes.importFirstNameMustNotContainNonAlphabeticalError);

    }
  }
  return errorString.toString();
}

String getLastNameError(List<ExcelData> columns, List<Data?> row) {
  StringBuffer errorString = StringBuffer();
  List<Data> cells = getDataOf(columns, row);

  if(cells.isEmpty) {
    errorString.write(TextRes.importLastNameCannotBeEmptyError);
  }

  for (Data cell in cells) {
    if (isOnlyWhitespace(cell.value.toString())) {
      errorString.write(TextRes.importLastNameCannotBeEmptyError);
    }
    if (containsNonAlphabetical(cell.value.toString().trim())) {
      errorString.write(TextRes.importLastNameMustNotContainNonAlphabeticalError);
    }
  }


  return errorString.toString();

}

String getClassError(List<ExcelData> columns, List<Data?> row, bool isClassWithoutCharAllowed) {
  StringBuffer errorString = StringBuffer();
  List<Data> cells = getDataOf(columns, row);

  if (cells.isEmpty) {
    errorString.write(TextRes.importClassCannotBeEmptyError);
  }

  for (Data cell in cells) {
    if (isOnlyWhitespace(cell.value.toString())) {
      errorString.write(TextRes.importClassCannotBeEmptyError);
    }

    if (isClassWithoutCharAllowed
        && !isClassValid(isClassWithoutCharAllowed, cell.value.toString().trim())) {
      errorString.write(TextRes.importClassPatternNumericAllowedError);

    } else if (!isClassWithoutCharAllowed
        && !isClassValid(isClassWithoutCharAllowed, cell.value.toString().trim())) {
      errorString.write(TextRes.importClassPatternError);
    }

  }

  return errorString.toString();

}

String getTrainingDirectionError(List<ExcelData> columns, List<Data?> row) {
  StringBuffer errorString = StringBuffer();
  List<Data> cells = getDataOf(columns, row);

  for (Data cell in cells) {
    if (!isTrainingDirectionValid(cell.value.toString())) {
      errorString.write(TextRes.importTrainingDirectionInvalid);
    }
  }

  return errorString.toString();

}



List<Data> getDataOf(List<ExcelData> columns, List<Data?> row) {
  List<Data> res = [];
  for (ExcelData columnData in columns) {
    if (row[columnData.column] != null) {
      res.add(
          row[columnData.column]!
      );
    }
  }
  return res;
}