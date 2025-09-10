import 'package:buecherteam_2023_desktop/Models/book_depot_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/books/book_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/book.dart';

class BookDepotBookList extends StatelessWidget {
  const BookDepotBookList({super.key});

  @override
  Widget build(BuildContext context) {
    int length = 0;
    //Consumer =>
    return Consumer<BookDepotState>(

      builder: (context, state, _) => StreamBuilder<List<Book>>(
          stream: state.streamBooks(state.currClassLevel), //get live books from model
          builder: (context, books) {
            length = books.data?.length ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingVeryBig),
              child: ListView.builder(
                  itemCount: length,
                  itemBuilder: (context, index) {
                    return BookCard(
                        clicked: state.currBookId == books.data![index].id,
                        onClick: (_) {
                          state.setCurrBookId(books.data![index].id);
                        },
                        onDeleteBook: (_) {},
                        bookLite: books.data![index],
                        leadingWidget: null,
                        isDeletable: false,
                        bookAvailableAmount: books.data![index].nowAvailable,
                        error: books.data![index].nowAvailable <
                            Dimensions.bookAvAmountThreshold);
                  }),
            );
          }),
    );
  }
}
