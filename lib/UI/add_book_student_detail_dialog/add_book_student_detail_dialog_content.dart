import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/add_book_student_detail_dialog/add_book_student_detail_list.dart';
import 'package:buecherteam_2023_desktop/UI/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../Resources/text.dart';

class AddBookStudentDetailDialogContent extends StatefulWidget {
  const AddBookStudentDetailDialogContent({super.key, required this.onFocusChanged, required this.onAddSelectedBook, required this.onRemoveSelectedBook});

  final Function(bool focused) onFocusChanged;
  final Function(BookLite bookLite) onAddSelectedBook;
  final Function(BookLite bookLite) onRemoveSelectedBook;

  @override
  State<AddBookStudentDetailDialogContent> createState() => _AddBookStudentDetailDialogContentState();
}

class _AddBookStudentDetailDialogContentState extends State<AddBookStudentDetailDialogContent> {

  String? ftsBookQuery;
  int amountOfQueriedBooks = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LfgSearchbar(onChangeText: (text) {
          setFtsBookQuery(text);
        }, amountOfFilteredItems: amountOfQueriedBooks,
            onFocusChange: widget.onFocusChanged,
            onTap: () {},
            amountType: TextRes.books),
        const SizedBox(height: Dimensions.spaceMedium,),

        StreamBuilder(stream: Provider.of<StudentDetailState>(context, listen: false)
            .streamBooks(ftsBookQuery),
            builder: (context, books) {
              if (books.hasData && books.data!.length != amountOfQueriedBooks) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    amountOfQueriedBooks = books.data!.length;
                  });
                });
              }

              return Expanded(child: AddBookStudentDetailList(
                  books: books.data ?? [],
                onAddSelectedBook: widget.onAddSelectedBook,
                onRemoveSelectedBook: widget.onRemoveSelectedBook,
                )
              );
            })
      ],
    );
  }

  void setFtsBookQuery(String text) {
    if (text == "") {
      setState(() {
        ftsBookQuery = null;
      });
    } else {
      List<String> parts = text
          .replaceAll("*",
          "") //"*" can lead to crashes of couchbase lite since it is a command
          .trim() //delete all whitespace to avoid "word AND  *" queries leading to crashes
          .split(RegExp(
          r'(?<=[0-9])(?=[A-Za-z])|\s+')); //use a regex to split up words and classLevel from classChar
      final query = '${parts.join(' AND ')}*';

      setState(() {
        ftsBookQuery = query;

      });
    }
  }
}
