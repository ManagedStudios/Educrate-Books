


import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';
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



    return true;
  }
}

