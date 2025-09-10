
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/add_book_student_detail_dialog/add_book_student_detail_dialog_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../Data/bookLite.dart';
import '../../../Models/student_detail_state.dart';
import '../../../Resources/text.dart';
import '../../../Util/lfg_snackbar.dart';

class AddBooksView extends StatefulWidget {
  static String routeName = "/add-books-view";
  const AddBooksView({super.key, required this.student});
  final Student student;

  @override
  State<AddBooksView> createState() => _AddBooksViewState();
}

class _AddBooksViewState extends State<AddBooksView> {

  List<BookLite> booksToAdd = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: Column(
        children: [
          Text(
              "${widget.student.firstName} ${widget.student.lastName} ${TextRes.books} ${TextRes.toAdd}",
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: Dimensions.spaceMedium,),
          Expanded(
            child: AddBookStudentDetailDialogContent(
                onFocusChanged: (_){},
                onAddSelectedBook: (book) => booksToAdd.add(book),
                onRemoveSelectedBook: (book) => booksToAdd.remove(book)
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingMedium),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSmall),
                  child: FilledButton.tonal(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text(TextRes.cancel)),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSmall),
                  child: FilledButton(
                      onPressed: () async{
                        await Provider.of<StudentDetailState>(context, listen: false)
                            .addBooksToStudent(booksToAdd, [widget.student],
                                (message) => showLFGSnackbar(context, message));

                        if (context.mounted) {
                          context.pop();
                        }
                      },
                      child: const Text(TextRes.addBooks)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
