import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_add_section.dart';
import 'package:buecherteam_2023_desktop/UI/input/dialog_text_field.dart';
import 'package:flutter/material.dart';

import '../../Data/book.dart';
import '../../Data/training_directions_data.dart';
import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';


class BookDialogContent extends StatefulWidget {

  const BookDialogContent({super.key, required this.onBookNameChanged,
    required this.bookNameError, required this.bookSubjectError,
    required this.classLevelError, required this.amountError,
    required this.onBookSubjectChanged,
    required this.onClassLevelChanged, required this.onAmountChanged,
    required this.onTrainingDirectionsChanged, required this.book, required this.onIsbnChanged});

  final Function(String text) onBookNameChanged;
  final Function(String text) onBookSubjectChanged;
  final Function (String text) onClassLevelChanged;
  final Function(String text) onAmountChanged;
  final Function(String text) onIsbnChanged;
  final Function(List<TrainingDirectionsData?> trainingDirections) onTrainingDirectionsChanged;

  final String? bookNameError;
  final String? bookSubjectError;
  final String? classLevelError;
  final String? amountError;

  final Book? book;

  @override
  State<BookDialogContent> createState() => _BookDialogContentState();
}

class _BookDialogContentState extends State<BookDialogContent> {

  late TextEditingController bookNameController;
  late TextEditingController bookSubjectController;
  late TextEditingController classLevelController;
  late TextEditingController isbnController;
  late TextEditingController amountController;

  @override
  void initState () {
    super.initState();
    bookNameController = TextEditingController();
    bookSubjectController = TextEditingController();
    classLevelController = TextEditingController();
    isbnController = TextEditingController();
    amountController = TextEditingController();

    bookNameController.text = widget.book?.name ?? "";
    bookSubjectController.text = widget.book?.subject ?? "";
    classLevelController.text = widget.book?.classLevel.toString() ?? "";
    isbnController.text = widget.book?.isbnNumber?.toString() ?? "";
    amountController.text = widget.book?.totalAvailable.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth =
    MediaQuery.of(context).size.width*0.5>500?MediaQuery.of(context).size.width*0.5:500;
    double dialogHeight =
        MediaQuery.of(context).size.height*0.7;
    return SizedBox(
      width: dialogWidth,
      height: dialogHeight,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                  controller: bookNameController,
                  onChanged: widget.onBookNameChanged,
                  style: Theme.of(context).textTheme.labelMedium,
                  decoration: InputDecoration(
                      hintText: TextRes.bookNameHint,
                      errorText: widget.bookNameError,
                      border: InputBorder.none
                      ),
                    )
                  )
                ]
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DialogTextField(
                      controller: bookSubjectController,
                      onTextChanged: widget.onBookSubjectChanged,
                      hint: TextRes.bookSubjectHint,
                      errorText: widget.bookSubjectError),
                ),
                Expanded(
                  flex: 1,
                    child: DialogTextField(controller: amountController,
                        onTextChanged: widget.onAmountChanged,
                        hint: TextRes.bookAmountHint,
                        errorText: widget.amountError)
                )
              ],
            ),
                Row(
                  children: [
                    Expanded(
                    flex: 3,
                      child:DialogTextField(controller: classLevelController,
                      onTextChanged: widget.onClassLevelChanged,
                          hint: TextRes.classLevelHint,
                          errorText: widget.classLevelError)

                  ),
                    Expanded(
                      flex: 2,
                        child: DialogTextField(
                          controller: isbnController,
                          onTextChanged: widget.onIsbnChanged,
                          hint: TextRes.isbnHint,
                          errorText: null,
                          ),
                        )
                  ]
                ),
            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSmall, top: Dimensions.paddingSmall),
              child: Text(TextRes.trainingDirectionsAdd,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
                child: TrainingDirectionAddSection(
                    currClass: int.tryParse(classLevelController.text),
                    currSubject: bookSubjectController.text.toUpperCase(),
                    onTrainingDirectionUpdated: widget.onTrainingDirectionsChanged)
            )
          ],
        ),
    );
  }


}
