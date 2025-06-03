

import 'package:excel/excel.dart';

import '../../../Data/book.dart';
import '../../../Resources/text.dart';

Excel getExcelBookList(List<Book> allBooks) {

  final excel = Excel.createExcel();
  excel.rename(excel.sheets.values.first.sheetName,
      TextRes.exportExcelAllBooksSheetName); //remove default sheet


  final headers = [
    TextRes.exportExcelClassLevel,
    TextRes.exportExcelSubject,
    TextRes.exportExcelBookName,
    TextRes.exportExcelTotalAv,
    TextRes.exportExcelAmountInStuOwn,
    TextRes.exportExcelNowAv,
    TextRes.exportExcelIsbn,
  ];

  List<Book> sortedBooks = [...allBooks];
  sortedBooks.sort();

  writeSheet(excel, TextRes.exportExcelAllBooksSheetName,
              sortedBooks, headers);

  // Create one sheet per classLevel
  final booksByClassLevel = <int, List<Book>>{};
  for (var book in allBooks) {
    booksByClassLevel.putIfAbsent(book.classLevel, () => []).add(book);
  }

  final classes = booksByClassLevel.keys.toList();
  classes.sort();

  for (int classLevel in classes) {
    final classLevelBooks = [...booksByClassLevel[classLevel]!];
    classLevelBooks.sort();

    writeSheet(excel,
        "${TextRes.exportExcelClassLevelSheet}$classLevel",
        classLevelBooks, headers
    );
  }


  return excel;

}

void writeSheet(Excel excel, String sheetName,
    List<Book> books,
    List<String> headers) {
  Sheet sheet = excel[sheetName];

  // Write header row
  for (var col = 0; col < headers.length; col++) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        .value = TextCellValue(headers[col]);
  }

  // Write data rows
  for (var row = 0; row < books.length; row++) {
    final book = books[row];
    final rowIndex = row + 1;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .value = TextCellValue(book.classLevel.toString());

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .value = TextCellValue(book.subject);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .value = TextCellValue(book.name);

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
        .value = TextCellValue(book.totalAvailable.toString());

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
        .value = TextCellValue(book.amountInStudentOwnership.toString());

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
        .value = TextCellValue(book.nowAvailable.toString());

    // For isbnNumber, replace null with "N/A"
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
        .value = TextCellValue(book.isbnNumber ?? "N/A");
  }
}