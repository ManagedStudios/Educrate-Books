

import 'dart:collection';


import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../../Data/bookLite.dart';


import 'book_card.dart';

/*
List for the books n students own in the detail page
 */

class StudentDetailBookList extends StatefulWidget {
  const StudentDetailBookList({super.key, required this.pressedKey,
    required this.books, required this.onAddSelectedBook,
    required this.onRemoveSelectedBook, required this.onClearSelectedBooks,
    required this.onDeleteBook});

  final Keyboard pressedKey; //conditional selection-process of books
  final List<BookLite> books; //content with conditional studentOwnerNum
  final Function(BookLite bookLite) onAddSelectedBook; //propagate
  final Function(BookLite bookLite) onRemoveSelectedBook; //propagate
  final Function() onClearSelectedBooks; //propagate
  final Function(BookLite bookLite) onDeleteBook;



  @override
  State<StudentDetailBookList> createState() => _StudentDetailBookListState();
}

class _StudentDetailBookListState extends State<StudentDetailBookList> {

  SplayTreeSet selectedBookIndices = SplayTreeSet(); //ordered indexed list to efficiently add and decide which books are selected

  /*
  clear selection when book is added or deleted to avoid memory leaks
   */
  @override
  void didUpdateWidget (oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(!listEquals(oldWidget.books, widget.books)) {
      setState(() {
        selectedBookIndices.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     return ListView(
        children: [
          for (int index = 0; index<widget.books.length; index++)
            BookCard(
                clicked: selectedBookIndices.contains(index),
                onClick: (book) => selectBooks( //method to select multiple books
                  books: widget.books,
                  index: index,
                  pressedKey: widget.pressedKey,
                ),
                onDeleteBook: widget.onDeleteBook,
                bookLite: widget.books.elementAt(index),
                isDeletable: true,
                leadingWidget: null,
                bookAvailableAmount: null),

        ],
    );

  }

  void selectBooks (
      {required Keyboard pressedKey,
        required int index,
        required List<BookLite> books}
      ) {
    /*
    depending on the pressed keys cmd/shift/nothing the selection behavior differs.
    The selection behavior is similar to Finder/Explorer.
     */
    setState(() {
      switch(pressedKey) {
        case Keyboard.nothing : { //one book cannot be selected, but clears the old selection
          selectedBookIndices.clear();
          widget.onClearSelectedBooks();
        }
        case Keyboard.cmd : { //add or remove student from selection

          if(selectedBookIndices.contains(index)) {
            selectedBookIndices.remove(index);
            widget.onRemoveSelectedBook(books[index]);

          } else {
            selectedBookIndices.add(index);
            widget.onAddSelectedBook(books[index]);
          }
        }
        case Keyboard.shift : { //select all intermediary options of students.

          if(selectedBookIndices.isEmpty) {
            for(int i = 0; i<=index; i++) {
              selectedBookIndices.add(i);
              widget.onAddSelectedBook(books[index]);
            }
            return;
          }
          if(index>selectedBookIndices.last) {
            for (int i = selectedBookIndices.last+1; i<=index; i++) {
              selectedBookIndices.add(i);
              widget.onAddSelectedBook(books[index]);
            }
          } else if (index<selectedBookIndices.first){
            for (int i = selectedBookIndices.first-1; i>=index; i--) {
              selectedBookIndices.add(i);
              widget.onAddSelectedBook(books[index]);
            }
          } else {
            for(int i = selectedBookIndices.first+1; i<=index; i++) {
              selectedBookIndices.add(i);
              widget.onAddSelectedBook(books[index]);
            }
          }
        }
      }
    });

  }
}
