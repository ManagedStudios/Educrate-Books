import 'dart:collection';

import 'package:buecherteam_2023_desktop/UI/add_book_student_detail_dialog/student_detail_add_book_card.dart';

import 'package:flutter/material.dart';


import '../../Data/bookLite.dart';

class AddBookStudentDetailList extends StatefulWidget {
  const AddBookStudentDetailList({super.key, required this.books,
    });

  final List<BookLite> books;

  @override
  State<AddBookStudentDetailList> createState() => _AddBookStudentDetailListState();
}

class _AddBookStudentDetailListState extends State<AddBookStudentDetailList> {


  HashSet<BookLite> selectedBooks = HashSet();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: widget.books.length,
            itemBuilder: (context, index) {
              return StudentDetailAddBookCard(
                  onCheckChanged: (checked, book) {
                    if (checked) {
                      addToSelectedBooks(book);
                    } else {
                      removeFromSelectedBooks(book);
                    }
                  },
                  bookLite: widget.books[index]);
            },
          );

  }

  void addToSelectedBooks(BookLite book) {
    setState(() {
      selectedBooks.add(book);
    });
  }

  void removeFromSelectedBooks(BookLite book) {
    setState(() {
      selectedBooks.remove(book);
    });
  }
}
