import 'package:buecherteam_2023_desktop/UI/books/book_card.dart';
import 'package:flutter/material.dart';

import '../../Data/bookLite.dart';
import '../../Resources/dimensions.dart';

class StudentDetailAddBookCard extends StatefulWidget {
  const StudentDetailAddBookCard({super.key, required this.onCheckChanged, required this.bookLite});

  final Function(bool checked, BookLite bookLite) onCheckChanged;
  final BookLite bookLite;

  @override
  State<StudentDetailAddBookCard> createState() => _StudentDetailAddBookCardState();
}

class _StudentDetailAddBookCardState extends State<StudentDetailAddBookCard> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BookCard(clicked: false,
        onClick: (_) {
          setState(() {
            isChecked = !isChecked;
          });
          widget.onCheckChanged(isChecked, widget.bookLite);
        },
        onDeleteBook: (_){},
        bookLite: widget.bookLite,
        leadingWidget: Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSmall),
          child: Checkbox(
                value: isChecked,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall)
                ),
                onChanged: (checked) {
                  setState(() {
                    isChecked = checked ?? false;
                  });
                  widget.onCheckChanged(isChecked, widget.bookLite);
                }),
        ),
        isDeletable: false,
        bookAvailableAmount: null);
  }
}
