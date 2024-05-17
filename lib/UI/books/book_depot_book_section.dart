import 'package:buecherteam_2023_desktop/Models/book_depot_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/add_book_dialog.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/edit_book_dialog.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_depot_book_list.dart';
import 'package:buecherteam_2023_desktop/UI/books/book_not_deletable_snackbar.dart';
import 'package:buecherteam_2023_desktop/UI/right_click_actions/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../right_click_actions/actions_overlay.dart';

class BookDepotBookSection extends StatefulWidget {
  const BookDepotBookSection({super.key});

  @override
  State<BookDepotBookSection> createState() => _BookDepotBookSectionState();
}

class _BookDepotBookSectionState extends State<BookDepotBookSection> {

  bool isOverlayOpen = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingMedium),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: "${TextRes.books} ${TextRes.toAdd}",
                child: IconButton(onPressed: () => addBook(context),
                    icon: const Icon(Icons.add, size: Dimensions.iconButtonSizeMedium,)),
              )
            ],
          ),
          const SizedBox(height: Dimensions.spaceMedium,),
           Expanded(
              child: GestureDetector(
                  onSecondaryTapUp: (details) {
                    var bookListState = Provider.of<BookDepotState>(context, listen: false);
                    if(bookListState.currBookId != null && !isOverlayOpen) {
                      setState(() {
                        isOverlayOpen = true;
                      });
                      var overlay = ActionsOverlay(
                          selectedItems: [],
                          width: Dimensions.widthRightClickActionMenu,
                          actions: { //inflate actions
                            TextRes.delete:(_) async{
                              //Ensure Book won't be deleted if students own it
                              if (await bookListState.haveStudentsThisBook(bookListState.currBookId!)) {
                                if (context.mounted) { //avoid async errors
                                  showBookNotDeletableSnackBar(context); //notify user
                                }
                              } else {
                                if (context.mounted) {//avoid async errors
                                  openDeleteDialog(context, [bookListState.currBookId!], TextRes.book,
                                    functionBeforeDeletion: () async{
                                      bookListState
                                          .deleteTrainingDirectionsIfRequired(bookListState.currBookId!);
                                    });
                                }
                              }

                            },
                            TextRes.edit:(_)async{
                              if(context.mounted) { // Check if the widget is still in the tree to avoid async errors
                                openEditBookDialog(context,
                                    await bookListState.getBook(bookListState.currBookId!),
                                    !(await bookListState.haveStudentsThisBook(bookListState.currBookId!))
                                );
                              }
                            }
                          },
                          onOverlayClosed: () {
                            setState(() {
                              isOverlayOpen = false;
                            });
                          },
                          offset: details.globalPosition,
                          context: context);
                      overlay.showOverlayEntry();
                    }
                  },
                  child: IgnorePointer(
                      ignoring: isOverlayOpen,
                      child: const BookDepotBookList()
                  )
              )
          )
        ],
      ),
    );
  }
}
