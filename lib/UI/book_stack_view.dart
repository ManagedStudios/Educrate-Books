import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/book_stack_view_state.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_summary.dart';
import 'package:buecherteam_2023_desktop/UI/classes/class_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookStackView extends StatelessWidget {
  static String routeName = '/bookStackView';
  const BookStackView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookStateViewState(context.read<DB>()),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: ClassSelector(),
          ),
          Expanded(
            flex: 3,
            child: BookSummary(),
          ),
        ],
      ),
    );
  }
}
