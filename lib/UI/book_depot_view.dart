import 'package:buecherteam_2023_desktop/UI/book_view.dart';
import 'package:buecherteam_2023_desktop/UI/class_level_column.dart';
import 'package:flutter/material.dart';

class BookDepotView extends StatelessWidget {
  static String routeName = '/bookDepotView';
  const BookDepotView({super.key});

  @override
  Widget build(BuildContext context) {
    return BookView(
        leftColumn: const ClassLevelColumn(),
        middleColumn: Container(),
        rightColumn: Container());
  }
}
