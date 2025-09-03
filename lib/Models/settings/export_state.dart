


import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
import 'package:buecherteam_2023_desktop/Util/pdf_util.dart';
import 'package:buecherteam_2023_desktop/Util/settings/io_util.dart';
import 'package:excel/excel.dart';

import 'package:flutter/material.dart';

import '../../Data/db.dart';
import '../../Resources/text.dart';
import '../../Util/settings/export/create_excel.dart';

class ExportState extends ChangeNotifier {

  ExportState(this.database);

  final DB database;



  Future<bool> downloadAllBooksExcel () async {

    List<Book> allBooks = await getAllBooks(database);
    Excel allBooksExcel = getExcelBookList(allBooks);
    final now = DateTime.now();
    final res = await downloadFile(allBooksExcel.encode(),
        "${TextRes.exportAllBooksFileName}_"
            "${now.year}-"
            "${now.month.toString().padLeft(2, '0')}-"
            "${now.day.toString().padLeft(2, '0')}.xlsx",
        TextRes.exportAllBooksDialogDescription);

    return res;
  }

  Future<bool> downloadAllBasicBookLists() async {
    List<int> allClassLevels = await getAllClassLevels(database);
    Map<String, List<int>> pdfs = {};

    for (var classLevel in allClassLevels) {
      final books = await getBooksOfBasicTrainingDirection(database, classLevel);
      if (books.isNotEmpty) {
        final pdfBytes = await createBasicBookListPdf(classLevel, books);
        pdfs['$classLevel.pdf'] = pdfBytes;
      }
    }

    if (pdfs.isNotEmpty) {
      return await saveFilesInDirectory(pdfs, TextRes.exportBasicBooksToPdf);
    }

    return true;
  }

  Future<bool> downloadClassLists() async{
    List<ClassData>? allClasses = await getAllClasses(database);


    return true;

  }
}

