


import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Util/database/getter.dart';

import 'package:flutter/material.dart';

import '../../Data/db.dart';

class ExportState extends ChangeNotifier {

  ExportState(this.database);

  final DB database;



  Future<bool> downloadAllBooksExcel () async {

    List<Book> allBooks = await getAllBooks(database);


    return true;
  }
}