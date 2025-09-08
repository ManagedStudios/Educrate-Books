import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/book_dialog/training_direction_button.dart';
import 'package:flutter/material.dart';

import '../../../Resources/dimensions.dart';

/*
TrainingDirectionSelectionRow makes it possible to select the mandatory training direction
of the pattern BASIC/SUBJECT-CLASS
 */
class TrainingDirectionSelectionRow extends StatefulWidget {
  const TrainingDirectionSelectionRow(
      {super.key,
      required this.onBasicClicked,
      required this.onSubjectClicked,
      required this.currSubjectText,
      required this.currClass,
      required this.isBasicClicked,
      required this.isSubjectClicked});

  final Function() onBasicClicked;
  final Function(String subject) onSubjectClicked;
  final String currSubjectText;
  final int? currClass;

  final bool isBasicClicked;
  final bool isSubjectClicked;

  @override
  State<TrainingDirectionSelectionRow> createState() =>
      _TrainingDirectionSelectionRowState();
}

class _TrainingDirectionSelectionRowState
    extends State<TrainingDirectionSelectionRow> {
  bool hasError = true;

/*
initialize the error to true if the user has not selected a training direction
*/
  @override
  void initState() {
    super.initState();
    if (widget.isBasicClicked || widget.isSubjectClicked) {
      hasError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TrainingDirectionButton(
                      text: TextRes.basicTrainingDirection,
                      isClicked: widget.isBasicClicked,
                      onClick: () {
                        widget.onBasicClicked();

                        if (hasError) {
                          setState(() {
                            hasError = false;
                          });
                        }
                      }),
                  const SizedBox(
                    width: Dimensions.spaceSmall,
                  ),
                  Text(
                    TextRes.slash,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    width: Dimensions.spaceSmall,
                  ),
                  TrainingDirectionButton(
                      text: widget.currSubjectText,
                      isClicked: widget.isSubjectClicked,
                      onClick: () {
                        widget.onSubjectClicked(widget.currSubjectText);

                        if (hasError) {
                          setState(() {
                            hasError = false;
                          });
                        }
                      })
                ],
              ),
              Text(
                TextRes.hyphen,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              IgnorePointer(
                //ignore the click on the class level button since it is not clickable
                ignoring: true,
                child: TrainingDirectionButton(
                    text: widget.currClass?.toString() ?? "",
                    isClicked: false,
                    onClick: () {}),
              )
            ],
          ),
          if (hasError) //show error if the user has not selected a training direction
            Text(
              TextRes.trainingDirectionSelectionRowError,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            )
        ],
      ),
    );
  }
}
