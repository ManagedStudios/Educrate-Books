

import 'package:buecherteam_2023_desktop/Models/book_depot_state.dart';
import 'package:buecherteam_2023_desktop/Models/navigation_state.dart';
import 'package:buecherteam_2023_desktop/UI/chips/chip_display_row.dart';
import 'package:buecherteam_2023_desktop/UI/classes/class_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';
import '../student_view.dart';

class BookDepotDetailCard extends StatelessWidget {
  const BookDepotDetailCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<BookDepotState>(
      builder: (context, state, _) => StreamBuilder(
          stream: state.streamBookDetails(state.currBookId),
          builder: (context, books) => books.data?.length!=1
              ? Container()
              : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.spaceLargeTimes2,),
                Card(
                  elevation: Dimensions.elevationZero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.cornerRadiusMedium)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingMedium),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Book subject and name display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${books.data![0].subject} ${books.data![0].classLevel}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,),
                                Text(books.data![0].name,
                                  style: Theme.of(context).textTheme.labelLarge,
                                  overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                            //book class level display
                            ClassBox(
                                classContent: books.data![0].classLevel.toString(),
                                radius: Dimensions.cornerRadiusBetweenSmallAndMedium,
                                dark: true)
                          ],
                        ),
                        const SizedBox(height: Dimensions.spaceSmall,),
                        Container(
                            height: Dimensions.lineWidth,
                            color: Theme.of(context).colorScheme.outlineVariant
                        ),
                        const SizedBox(height: Dimensions.spaceMedium,),

                         //Available Amount Display
                         Row(
                          children: [
                            Text.rich(
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children:[
                                const TextSpan(text: TextRes.bookAmountAvailable),
                                TextSpan(text: books.data![0].nowAvailable.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge),
                                const TextSpan(text: TextRes.slash),
                                TextSpan(text: books.data![0].totalAvailable.toString())
                              ]
                            ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.spaceVerySmall,),

                        //display how many times the book was lent
                        Row(
                          children: [
                            Expanded(
                              child: Text("${books.data![0].amountInStudentOwnership} ${TextRes.bookAmountInStudentOwnershipDisplay}",
                              overflow: TextOverflow.ellipsis,),
                            )
                          ],
                        ),
                        const SizedBox(height: Dimensions.spaceVerySmall,),

                            //ISBN Number display
                            Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SelectableText(
                                        "${TextRes.isbnDisplay} ${books.data![0].isbnNumber ?? ""}",
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                ),
                              ],
                            ),

                        const SizedBox(height: Dimensions.spaceLargeTimes2,),

                        //Training Directions Display
                        Row(
                          children: [
                            Text(TextRes.trainingDirectionsDisplay,
                            style: Theme.of(context).textTheme.displaySmall,),
                          ],
                        ),
                        const SizedBox(height: Dimensions.spaceSmall,),
                        ChipDisplayRow(chips: books.data![0].trainingDirection),
                        const SizedBox(height: Dimensions.spaceSmall,),

                        //Filter Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  Provider.of<NavigationState>(context, listen: false)
                                      .onStudentViewClicked();
                                  context.go(StudentView.routeName, extra: books.data![0]);
                                },
                                style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.only(right: Dimensions.paddingMedium,
                                        left: Dimensions.paddingMedium)
                                  ),
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: Theme.of(context).colorScheme.secondary,
                                      width: Dimensions.thickLineWidth
                                    )
                                  ),
                                ),
                                child: Text(TextRes.useAsFilter,
                                  style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary
                                ),
                                )
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ]
          ),
      )
    );
  }
}
