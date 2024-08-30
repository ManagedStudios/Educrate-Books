import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_creation_row.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_selection_row.dart';
import 'package:flutter/material.dart';

import '../../Data/training_directions_data.dart';
import '../../Resources/dimensions.dart';

/*
A widget that is meant to be a training_directions creator.
It consists of a mandatory trainingDirection with TrainingDirectionSelectionRow and
n optional TrainingDirectionCreationRows
 */
class TrainingDirectionAddSection extends StatefulWidget {
  const TrainingDirectionAddSection(
      {super.key,
      required this.currClass,
      required this.currSubject,
      required this.onTrainingDirectionUpdated,
      this.initialTrainingDirections});

  final int? currClass;
  final String currSubject;

  final List<TrainingDirectionsData?>?
      initialTrainingDirections; //initial trainingDirections that are already set

  final Function(List<TrainingDirectionsData?> trainingDirections)
      onTrainingDirectionUpdated; //notify parent about changes

  @override
  State<TrainingDirectionAddSection> createState() =>
      _TrainingDirectionAddSectionState();
}

class _TrainingDirectionAddSectionState
    extends State<TrainingDirectionAddSection> {
  List<TrainingDirectionsData?> currTrainingDirectionsExposed = [
    null
  ]; //add first element which is the selectionRow
  List<String> internalTrainingDirections = [
    ""
  ]; //add first element which is the selectionRow

  bool isBasicClicked = false;
  bool isSubjectClicked = false;

  late ScrollController scrollController;

/*
initialize the state with the initialTrainingDirections if they are not null
  */
  @override
  void initState() {
    super.initState();
    if (widget.initialTrainingDirections != null) {
      internalTrainingDirections =
          widget.initialTrainingDirections!.map((e) => e!.label).toList();
      currTrainingDirectionsExposed = widget.initialTrainingDirections!;
      if (currTrainingDirectionsExposed[0]!
          .label
          .contains(TextRes.basicTrainingDirection)) {
        isBasicClicked = true;
      } else {
        isSubjectClicked = true;
      }
    }

    scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    /*
    update trainingDirections if class or subject has changed via parent widget
    => needed since TrainingDirectionSelectionRow updates the trainingDirections only
    when button is clicked, but when the subject/class has changed trD. also has to be
    updated
     */
    if (isSubjectClicked &&
        (oldWidget.currSubject != widget.currSubject ||
            oldWidget.currClass != widget.currClass)) {
      currTrainingDirectionsExposed[0] = TrainingDirectionsData(
          "${widget.currSubject}${TextRes.trainingDirectionHyphen}${widget.currClass}");
      widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed);
    }

    if (isBasicClicked && oldWidget.currClass != widget.currClass) {
      currTrainingDirectionsExposed[0] = TrainingDirectionsData(
          "${TextRes.basicTrainingDirection}${TextRes.trainingDirectionHyphen}${widget.currClass}");
      widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView(
          controller: scrollController,
          children: [
            /*
            first you are forced to select a trainingDirection of type BASIC/SUBJECT-classLevel
            where all three items are predefined
             */
            TrainingDirectionSelectionRow(
              onBasicClicked: () {
                //update the first element
                currTrainingDirectionsExposed[0] = TrainingDirectionsData(
                    "${TextRes.basicTrainingDirection}${TextRes.trainingDirectionHyphen}${widget.currClass}");
                widget
                    .onTrainingDirectionUpdated(currTrainingDirectionsExposed);
                setState(() {
                  isBasicClicked = true;
                  isSubjectClicked = false;
                });
              },
              onSubjectClicked: (subject) {
                currTrainingDirectionsExposed[0] = TrainingDirectionsData(
                    "$subject${TextRes.trainingDirectionHyphen}${widget.currClass}");
                widget
                    .onTrainingDirectionUpdated(currTrainingDirectionsExposed);
                setState(() {
                  isBasicClicked = false;
                  isSubjectClicked = true;
                });
              },
              currSubjectText: widget.currSubject, //predefined params
              currClass: widget.currClass,
              isBasicClicked: isBasicClicked,
              isSubjectClicked: isSubjectClicked,
            ),

            /*
            then you can add n training directions that follow a pattern of
            SOMETAG"-"SOMECLASSLEVEL
            It is not checked if the classLevel actually exists
             */
            for (int i = 1; i < internalTrainingDirections.length; i++)
              TrainingDirectionCreationRow(
                onEveryInputChange: (update) {
                  //every change of the textField is saved internally to remember the correct state if any row is deleted
                  internalTrainingDirections[i] = update;
                },
                onDeleteTrainingDirection: () {
                  setState(() {
                    currTrainingDirectionsExposed.removeAt(
                        i); //remove from the exposed trainingDirections list
                    internalTrainingDirections.removeAt(
                        i); //remove from the internal list to update state
                  });
                  widget.onTrainingDirectionUpdated(
                      currTrainingDirectionsExposed); //notify parent widget about that change
                },
                onTrainingDirectionChanged:
                    (TrainingDirectionsData? trainingDirectionsData) {
                  //only valid changes to a TrainingDirection are propagated else null (null => indicator that data is not valid)
                  currTrainingDirectionsExposed[i] =
                      trainingDirectionsData; //update exposedList with valid data
                  widget.onTrainingDirectionUpdated(
                      currTrainingDirectionsExposed); //notify parents
                },
                currTrainingDirection: internalTrainingDirections[i]
                        .split(TextRes.trainingDirectionHyphen)[
                    0], //use the internal state to set the textField text
                currClassLevel: internalTrainingDirections[i]
                        .split(TextRes.trainingDirectionHyphen)[
                    1], //be sure that all elements follow "String""-"String" pattern, else errors can occur
              )
          ],
        ),
      ),
      IconButton(
          onPressed: () {
            setState(() {
              //setState to rebuild the for loop
              currTrainingDirectionsExposed.add(
                  null); //first add null since the TrainingDirection is not yet valid
              internalTrainingDirections.add(TextRes
                  .trainingDirectionHyphen); //add only the hyphen so that the splitting mechanism for state works
            });
            widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed);
            // Schedule the scrollToBottom to happen after the build process
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToBottom();
            });
          },
          icon: const Icon(Icons.add_circle_outline))
    ]);
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: Dimensions.durationShort),
      curve: Curves.easeInOut,
    );
  }
}
