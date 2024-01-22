import 'package:buecherteam_2023_desktop/Models/class_level_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/book_list_state.dart';
import '../../Resources/text.dart';
import 'book_dialog.dart';

void addBook(BuildContext context) {
  showDialog<List<Object?>>(context: context, builder: (context) {
    return const BookDialog(title: TextRes.addBook,
        book: null, actionText: TextRes.saveActionText, isFullyEditable: true,);
  }).then((values) async{
    final bookListState = Provider.of<BookListState>(context, listen: false);
    final classLevelState = Provider.of<ClassLevelState>(context, listen: false);

    if (values == null) return;

    String bookName = values[0] as String;
    String bookSubject = values[1] as String;
    int classLevel = int.parse((values[2] as String));
    List<String> trainingDirections = values[3] as List<String>;
    String? isbnNumber = values[4] as String?;
    int amount = int.parse((values[5] as String));

    bookListState.saveBook(bookName, bookSubject, classLevel, trainingDirections, isbnNumber, amount);
    bookListState.setCurrClassLevel(classLevel);
    classLevelState.setSelectedClassLevel(classLevel);



  });
}