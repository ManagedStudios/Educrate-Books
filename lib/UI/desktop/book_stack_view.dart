
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/books/book_summary.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/classes/class_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'book_depot_view.dart';


class BookStackView extends StatelessWidget {
  static String routeName = '/bookStackView';
  const BookStackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      child: Row(
          children: [
            Expanded(

              child: ClassSelector(onSwitchBookView: () => context.go(BookDepotView.routeName),),
            ),
            const Expanded(

              child: BookSummary(),
            ),
          ],
        ),
    );
  }
}
