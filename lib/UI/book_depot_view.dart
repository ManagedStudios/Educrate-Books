import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_add_section.dart';
import 'package:buecherteam_2023_desktop/UI/book_stack_view.dart';
import 'package:buecherteam_2023_desktop/UI/book_view.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_depot_book_section.dart';
import 'package:buecherteam_2023_desktop/UI/classes/class_level_column.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class BookDepotView extends StatelessWidget {
  static String routeName = '/bookDepotView';
  const BookDepotView({super.key});

  @override
  Widget build(BuildContext context) {
    List<TrainingDirectionsData?> directions = [
      TrainingDirectionsData("BASIC-10"),
      TrainingDirectionsData("SAMSUNG-8"),
      TrainingDirectionsData("INDEX-5")];
    return BookView(
        leftColumn: ClassLevelColumn(
          onSwitchBookView: () => context.go(BookStackView.routeName),
        ),
        middleColumn: BookDepotBookSection(),
        rightColumn:
            SizedBox(
              height: 250,
              child: TrainingDirectionAddSection(
                  currClass: 10,
                  currSubject: "Englisch",
                  onTrainingDirectionUpdated: (tr) {
                   print(tr.map((e) => e?.label).toList());
                  },
              initialTrainingDirections: directions.toList(),
              ),

            )

    );
  }
}
