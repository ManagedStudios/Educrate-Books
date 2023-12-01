import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/books/student_detail_book_list.dart';
import 'package:buecherteam_2023_desktop/UI/keyboard_listener/keyboard_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Data/bookLite.dart';
import '../../Models/student_detail_state.dart';
import '../../Resources/dimensions.dart';
import '../right_click_actions/actions_overlay.dart';

class StudentDetailBookSection extends StatefulWidget {
  const StudentDetailBookSection({super.key,
    required this.pressedKey, required this.books,
    required this.studentOwnerNums});

  final Keyboard pressedKey;
  final List<BookLite> books;
  final List<int?> studentOwnerNums;

  @override
  State<StudentDetailBookSection> createState() => _StudentDetailBookSectionState();
}

class _StudentDetailBookSectionState extends State<StudentDetailBookSection> {

  List<BookLite> selectedBooks = [];
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
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                  ),
                const SizedBox(width: Dimensions.spaceVerySmall),
                IconButton(onPressed: (){},
                    icon: const Icon(Icons.add),
                color: Theme.of(context).colorScheme.secondary,)
              ],
            ),
          ),

        Expanded(
          child: GestureDetector(
            onSecondaryTapUp: (details) {
              var studentDetailState = Provider.of<StudentDetailState>(context, listen: false);
              if(//studentDetailState.selectedStudentIdObjects.isNotEmpty
                   selectedBooks.isNotEmpty && !isOverlayOpen) {
                setState(() {
                  isOverlayOpen = true;
                });
                var overlay = ActionsOverlay(
                    selectedItems: studentDetailState.selectedStudentIdObjects.toList(), //make copy of selected students to avoid side effects
                    width: Dimensions.widthRightClickActionMenu,
                    actions: { //inflate actions
                      TextRes.delete:(students) {
                        studentDetailState
                            .deleteBooksOfStudents(
                            studentDetailState.selectedStudentIdObjects.toList(),
                            selectedBooks);
                      },
                      TextRes.duplicate:(students){
                        studentDetailState
                            .duplicateBooksOfStudents(
                            studentDetailState.selectedStudentIdObjects.toList(),
                            selectedBooks);
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
              child: StudentDetailBookList(pressedKey: widget.pressedKey,
                  books: widget.books,
                  studentOwnerNums: widget.studentOwnerNums,
                  onAddSelectedBook: (book) {
                    selectedBooks.add(book);
                  },
                  onRemoveSelectedBook: (book){
                    selectedBooks.remove(book);
                  },
                  onClearSelectedBooks: (){
                    selectedBooks.clear();
                    }
                  ),
            ),
          ),
        )

      ],
    );
  }
}
