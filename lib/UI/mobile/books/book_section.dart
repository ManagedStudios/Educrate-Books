
import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/books/book_card.dart';
import 'package:flutter/material.dart';

import '../../../Resources/dimensions.dart';
import '../../../Resources/text.dart';

class BookSection extends StatelessWidget {
  const BookSection({super.key, required this.student, required this.onAddBooks, required this.onDeleteBooks});
  final Student student;
  final Function() onAddBooks;
  final Function(List<BookLite> books) onDeleteBooks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSmall),
          child: Row(
            children: [
              Text(
                "${student.books.length} ${TextRes.books}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(width: Dimensions.spaceVerySmall),
              IconButton(
                onPressed: onAddBooks, //addBooks
                icon: const Icon(Icons.add),
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSmall),
          child: Row(
            children: [
              Text(TextRes.deleteAllBooks, style: Theme.of(context).textTheme.bodyLarge,),
              IconButton(
                  onPressed: () => onDeleteBooks(student.books),
                  icon: const Icon(Icons.delete_forever_rounded)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: student.books.length,
            itemBuilder: (context, index) {
              final book = student.books[index];
              return BookCard(
                clicked: false,
                onClick: (_){},
                onDeleteBook: (bookToDelete) => onDeleteBooks([bookToDelete]),
                bookLite: book,
                leadingWidget: null,
                isDeletable: true,
                bookAvailableAmount: null,
              );
            },
          ),
        )
      ],
    );
  }
}
