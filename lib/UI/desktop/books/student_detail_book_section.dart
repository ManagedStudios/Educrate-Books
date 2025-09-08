import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/books/student_detail_book_list.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/keyboard_listener/keyboard_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/bookLite.dart';
import '../../../Data/student.dart';
import '../../../Models/student_detail_state.dart';
import '../../../Resources/dimensions.dart';
import '../../../Util/lfg_snackbar.dart';
import '../right_click_actions/actions_overlay.dart';

/*
This Widget completes the book list with amount indicator, an plus button to
add books and the feature to take action on selected books with right click
 */
class StudentDetailBookSection extends StatefulWidget {
  const StudentDetailBookSection(
      {super.key,
      required this.pressedKey,
      required this.books,
      required this.onAddBooks,
      required this.currStudents});

  final Keyboard pressedKey; //pass forward
  final List<BookLite> books; //pass forward
  final Function() onAddBooks;
  final List<Student> currStudents;

  @override
  State<StudentDetailBookSection> createState() =>
      _StudentDetailBookSectionState();
}

class _StudentDetailBookSectionState extends State<StudentDetailBookSection> {
  List<BookLite> selectedBooks =
      []; //manage selectedBooks in widget since no other widget is depended on this piece of information
  bool isOverlayOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSmall),
          child: Row(
            children: [
              Text(
                "${widget.books.length} ${TextRes.books}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(width: Dimensions.spaceVerySmall),
              Tooltip(
                message: "${TextRes.books} ${TextRes.toAdd}",
                waitDuration:
                    const Duration(seconds: Dimensions.toolTipDuration),
                child: IconButton(
                  onPressed: widget.onAddBooks, //addBooks
                  icon: const Icon(Icons.add),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
        Expanded(
          /*
          Wrap the bookList in the RightClick Action body
           */
          child: GestureDetector(
            //used to detect right clicks
            onSecondaryTapUp: (details) {
              var studentDetailState =
                  Provider.of<StudentDetailState>(context, listen: false);
              if (widget.currStudents.isNotEmpty &&
                  selectedBooks.isNotEmpty &&
                  !isOverlayOpen) {
                setState(() {
                  isOverlayOpen = true;
                });
                var overlay = ActionsOverlay(
                    selectedItems: widget
                        .currStudents, //actually not used since no dialog and abstraction is needed/possible
                    width: Dimensions.widthRightClickActionMenu,
                    actions: {
                      //inflate actions
                      TextRes.delete: (students) {
                        studentDetailState //instantly process action
                            .deleteBooksOfStudents(
                                widget.currStudents, //students passed
                                selectedBooks.toList()); //selected books passed
                        clearSelectedBooks();
                      },
                      TextRes.duplicate: (students) {
                        studentDetailState.duplicateBooksOfStudents(
                            widget.currStudents,
                            selectedBooks.toList(),
                            (message) => showLFGSnackbar(context, message));

                        clearSelectedBooks();
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
              child: StudentDetailBookList(
                pressedKey: widget.pressedKey,
                books: widget.books,
                onAddSelectedBook: (book) {
                  selectedBooks.add(book);
                },
                onRemoveSelectedBook: (book) {
                  selectedBooks.remove(book);
                },
                onClearSelectedBooks: () {
                  selectedBooks.clear();
                },
                onDeleteBook: (BookLite bookLite) {
                  /*
                use delete method that is also used for right click action above
                 */
                  var state =
                      Provider.of<StudentDetailState>(context, listen: false);
                  state.deleteBooksOfStudents(widget.currStudents, [bookLite]);
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  void clearSelectedBooks() {
    selectedBooks.clear();
  }
}
