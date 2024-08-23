import 'package:buecherteam_2023_desktop/UI/book_stack_view.dart';
import 'package:buecherteam_2023_desktop/UI/book_view.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_depot_book_section.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_depot_detail_card.dart';
import 'package:buecherteam_2023_desktop/UI/classes/class_level_column.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookDepotView extends StatelessWidget {
  static String routeName = '/bookDepotView';
  const BookDepotView({super.key});

  @override
  Widget build(BuildContext context) {
    return BookView(
        leftColumn: ClassLevelColumn(
          onSwitchBookView: () => context.go(BookStackView.routeName),
        ),
        middleColumn: BookDepotBookSection(),
        rightColumn: BookDepotDetailCard());
  }
}
