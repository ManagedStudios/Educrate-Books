import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Data/book.dart';
import '../../Models/book_list_state.dart';
import '../../Resources/text.dart';
import 'book_dialog.dart';

void openEditBookDialog(BuildContext context, Book book, bool isFullyEditable) {
  final bookListState = Provider.of<BookListState>(context, listen: false);
  showDialog<Book>(context: context, builder: (context) {

    return BookDialog(title: TextRes.addBook,
        book: book, actionText: TextRes.saveActionText, isFullyEditable: isFullyEditable,);
  }).then((book) async{

    if (book == null) return;

    bookListState.updateBook(book);

  });
}