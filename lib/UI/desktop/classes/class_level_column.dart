import 'package:buecherteam_2023_desktop/Models/book_depot_state.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/classes/class_level_card.dart';
import 'package:buecherteam_2023_desktop/Util/mathUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/class_level_state.dart';
import '../../../Resources/dimensions.dart';
import '../books/switch_book.dart';

class ClassLevelColumn extends StatefulWidget {
  const ClassLevelColumn({super.key, required this.onSwitchBookView});

  final Function() onSwitchBookView;

  @override
  State<ClassLevelColumn> createState() => _ClassLevelColumnState();
}

class _ClassLevelColumnState extends State<ClassLevelColumn> {
  late Future<List<int>> classLevels;

  /*
  every three classLevels the width of the card increases fractionally
   */
  double minFactorClassLevelWidth = 0.3;
  late int amountOfJumps;
  late double fractionPerJump;
  late double currFraction;

  @override
  void initState() {
    super.initState();
    classLevels =
        Provider.of<ClassLevelState>(context, listen: false).getClassLevels();
    currFraction = minFactorClassLevelWidth;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
        future: classLevels,
        initialData: const [],
        builder: (context, levels) {
          int length = levels.data?.length ?? 0;
          currFraction = minFactorClassLevelWidth;
          amountOfJumps = roundUpDivision(length, 3);
          fractionPerJump =
              (1 - minFactorClassLevelWidth) / amountOfJumps.toDouble();
          return Padding(
            padding: const EdgeInsets.only(top: Dimensions.paddingMedium),
            child: Column(
              children: [
                SwitchBook(onSwitchBookView: widget.onSwitchBookView),
                Expanded(
                  child: ListView(
                    //use listView to tacle even exceptional high load of classes
                    children: [
                      for (int index = 0; index < length; index++)
                        FractionallySizedBox(
                          //take up a fraction of full expanded width
                          widthFactor: getCurrFraction(index),
                          alignment: Alignment.centerLeft,
                          child: FutureBuilder(
                            //check if classLevel contains books subceeding avAmount threshold
                            future: Provider.of<ClassLevelState>(context,
                                    listen: false)
                                .areBooksSubceedingAmount(levels.data![index]),
                            initialData: false,
                            builder: (context, tooFewBooks) {
                              return Consumer<ClassLevelState>(
                                builder: (context, state, _) => ClassLevelCard(
                                    classLevel: levels.data![index],
                                    onClick: (selectedLevel) {
                                      state
                                          .setSelectedClassLevel(selectedLevel);
                                      Provider.of<BookDepotState>(context,
                                              listen: false)
                                          .setCurrClassLevel(selectedLevel);
                                    },
                                    clicked: levels.data![index] ==
                                        state.selectedClassLevel,
                                    error: tooFewBooks.data ?? false),
                              );
                            },
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  double getCurrFraction(int index) {
    if (index % 3 == 0) {
      currFraction += fractionPerJump;
    }
    return currFraction <= 1.0 ? currFraction : 1.0;
  }
}
