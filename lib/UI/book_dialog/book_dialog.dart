import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/book_dialog_content.dart';
import 'package:buecherteam_2023_desktop/Util/stringUtil.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Data/book.dart';
import '../../Models/class_level_state.dart';
import '../../Resources/text.dart';
import '../../Util/mathUtil.dart';

class BookDialog extends StatefulWidget {
  const BookDialog({super.key, required this.title, required this.book, required this.actionText, this.isFullyEditable});

  final String title;
  final Book? book;
  final String actionText;
  final bool? isFullyEditable;

  @override
  State<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {

  late String bookName;
  late String bookSubject;
  late String classLevel;
  late String isbnNumber;
  late String amount;
  String? bookId;
  late List<TrainingDirectionsData?> trainingDirections = [null];

  late List<int> availableClassLevels;

  String? bookNameError;
  String? classLevelError;
  String? amountError;
  String? bookSubjectError;

  @override
  void initState () {
    super.initState();
    bookName = widget.book?.name ?? "";
    bookSubject = widget.book?.subject ?? "";
    classLevel = widget.book?.classLevel.toString() ?? "";
    isbnNumber = widget.book?.isbnNumber?.toString() ?? "";
    amount = widget.book?.totalAvailable.toString() ?? "";
    bookId = widget.book?.id;
    trainingDirections = widget.book?.trainingDirection.map((e) =>
        TrainingDirectionsData(e)).toList() ?? [null];
    setAvailableClassLevel(Provider.of<ClassLevelState>(context, listen: false).getClassLevels());
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      content: BookDialogContent(
      onBookNameChanged: onBookNameChanged,
      bookNameError: bookNameError,
      bookSubjectError: bookSubjectError,
      classLevelError: classLevelError,
      amountError: amountError,
      onBookSubjectChanged: onBookSubjectChanged,
      onClassLevelChanged: onClassLevelChanged,
      onAmountChanged: onAmountChanged,
      onTrainingDirectionsChanged: onTrainingDirectionsChanged,
      book: widget.book,
        isFullyEditable: widget.isFullyEditable,
        onIsbnChanged: onIsbnChanged),
      actions: [
        FilledButton.tonal(onPressed:(){
          context.pop();
        }, child: const Text(
            TextRes.cancel
        )
        ),
        FilledButton(onPressed: () {
          if(isDataValid()) {
            if(bookId != null) { //update book
              context.pop(
                Book(bookId: bookId!,
                    name: bookName,
                    subject: bookSubject,
                    classLevel: int.parse(classLevel),
                    trainingDirection: trainingDirections.map((e) => e!.label).toList(),
                    amountInStudentOwnership: widget.book!.amountInStudentOwnership,
                    nowAvailable: int.parse(amount)-widget.book!.amountInStudentOwnership,
                    totalAvailable: int.parse(amount),
                    isbnNumber: isbnNumber)
              );

            } else { //create new Book
              /*
              IMPORTANT: When refactor make sure to update the receiver of the pop method!
               */
              context.pop([
                bookName,
                bookSubject,
                classLevel,
                trainingDirections.map((e) => e!.label).toList(),
                isbnNumber,
                amount
              ]);
            }
          }
        },
            child: Text(widget.actionText)
        )
      ],
    );
  }

  void onBookNameChanged(String text) {
    if (isBookNameValid (text)) {
      setState(() {
        bookNameError = null;
      });
    }
    bookName = text;
  }

  void onBookSubjectChanged(String text) {
      if (isBookSubjectValid (text)) {
        setState(() {
          bookSubjectError = null;
        });
      }
      bookSubject = text;
  }

  void onClassLevelChanged(String text) {
      if (isClassLevelValid (text)) {
        setState(() {
          classLevelError = null;
        });
      }
      classLevel = text;


  }

  void onAmountChanged(String text) {
    if (isAmountValid (text)) {
      setState(() {
        amountError = null;
      });
    }
    amount = text;
  }

  void onTrainingDirectionsChanged(List<TrainingDirectionsData?> trainingDirections) {
    this.trainingDirections = trainingDirections;
  }

  bool isBookNameValid(String text) {
    return !isOnlyWhitespace(text) && !text.contains("-");
  }

  bool isBookSubjectValid(String text) {
    return !isOnlyWhitespace(text) && !text.contains("-");
  }

  bool isClassLevelValid(String text) {
    return isNumeric(text) && availableClassLevels.contains(int.parse(text));
  }

  bool isAmountValid(String text) {
    return isNumeric(text);
  }

  bool isTrainingDirectionsValid (List<TrainingDirectionsData?> trainingDirections) {
    return !trainingDirections.contains(null);
  }

  bool isDataValid () {
    updateErrors();
    return
      isBookNameValid(bookName)
        && isBookSubjectValid(bookSubject)
        && isClassLevelValid(classLevel)
        && isAmountValid(amount)
        && isTrainingDirectionsValid(trainingDirections);
  }

  void updateErrors() {
    setState(() {
      if (!isBookNameValid(bookName)) {
        bookNameError = TextRes.bookNameError;
      }
      if (!isBookSubjectValid(bookSubject)) {
        bookSubjectError = TextRes.bookSubjectError;
      }
      if (!isClassLevelValid(classLevel)) {
        classLevelError =
        "${TextRes.availableClassLevelError} ${formatRange(availableClassLevels)} ${TextRes.toInsert}";
      }
      if(!isAmountValid(amount)) {
        amountError = TextRes.bookAmountError;
      }

    });
  }

  Future<void> setAvailableClassLevel(Future<List<int>> classLevels) async{
    availableClassLevels = await classLevels;
  }

  void onIsbnChanged(String text) {
    isbnNumber = text;
  }
}
