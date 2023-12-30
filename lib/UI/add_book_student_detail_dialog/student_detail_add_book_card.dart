import 'package:buecherteam_2023_desktop/UI/books/book_card.dart';
import 'package:flutter/material.dart';

import '../../Data/bookLite.dart';
import '../../Resources/dimensions.dart';

class StudentDetailAddBookCard extends StatelessWidget {
  const StudentDetailAddBookCard({
    super.key,
    required this.onCheckChanged,
    required this.bookLite,
    required this.isChecked,
  });

  final Function(BookLite bookLite) onCheckChanged;
  final BookLite bookLite;
  final bool isChecked; //is book already checked

  @override
  Widget build(BuildContext context) {
    return BookCard(
      clicked: false,
      onClick: (_) {
        onCheckChanged(bookLite);
      },
      onDeleteBook: (_) {},
      bookLite: bookLite,
      leadingWidget: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSmall),
        child: Checkbox(
          value: isChecked,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall),
          ),
          onChanged: (checked) {
            //onChanged is called when the checkbox is clicked
            onCheckChanged(bookLite);
          },
        ),
      ),
      isDeletable: false,
      bookAvailableAmount: null,
    );
  }
}
