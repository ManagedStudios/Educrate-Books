import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_creation_row.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_selection_row.dart';
import 'package:flutter/material.dart';

import '../../Data/training_directions_data.dart';

/*
A widget that is meant to be a training_directions creator.
It consists of a mandatory trainingDirection with TrainingDirectionSelectionRow and
n optional TrainingDirectionCreationRows
 */
class TrainingDirectionAddSection extends StatefulWidget {
  const TrainingDirectionAddSection({super.key, required this.currClass, required this.currSubject,
    required this.onTrainingDirectionUpdated, this.initialTrainingDirections});

  final int? currClass;
  final String currSubject;

  final List<TrainingDirectionsData?>? initialTrainingDirections;

  final Function(List<TrainingDirectionsData?> trainingDirections) onTrainingDirectionUpdated;

  @override
  State<TrainingDirectionAddSection> createState() => _TrainingDirectionAddSectionState();
}

class _TrainingDirectionAddSectionState extends State<TrainingDirectionAddSection> {
  List<TrainingDirectionsData?> currTrainingDirectionsExposed = [null]; //add first element which is the selectionRow
  List<String> internalTrainingDirections = [""]; //add first element which is the selectionRow

  bool isBasicClicked = false;
  bool isSubjectClicked = false;

  @override
  void initState () {
    super.initState();
    if (widget.initialTrainingDirections != null) {
      internalTrainingDirections =
          widget.initialTrainingDirections!.map((e) => e!.label).toList();
      currTrainingDirectionsExposed = widget.initialTrainingDirections!;
      if(currTrainingDirectionsExposed[0]!.label.contains(TextRes.basicTrainingDirection)) {
        isBasicClicked = true;
      } else {
        isSubjectClicked = true;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
          children: [
            /*
            first you are forced to select a trainingDirection of type BASIC/SUBJECT-classLevel
            where all three items are predefined
             */
            TrainingDirectionSelectionRow(
                onBasicClicked: () { //update the first element
                  currTrainingDirectionsExposed[0] =
                      TrainingDirectionsData("${TextRes.basicTrainingDirection}${TextRes.trainingDirectionHyphen}${widget.currClass}");
                  widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed);
                  setState(() {
                    isBasicClicked = true;
                    isSubjectClicked = false;
                  });
                },
                onSubjectClicked: (subject) {
                  currTrainingDirectionsExposed[0] =
                      TrainingDirectionsData("$subject${TextRes.trainingDirectionHyphen}${widget.currClass}");
                  widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed);
                  setState(() {
                    isBasicClicked = false;
                    isSubjectClicked = true;
                  });
                },
                currSubjectText: widget.currSubject, //predefined params
                currClass: widget.currClass,
              isBasicClicked: isBasicClicked,
              isSubjectClicked: isSubjectClicked,),

            /*
            then you can add n training directions that follow a pattern of
            SOMETAG"-"SOMECLASSLEVEL
            It is not checked if the classLevel actually exists
             */
            for (int i = 1; i<internalTrainingDirections.length; i++)
              TrainingDirectionCreationRow(
                  onEveryInputChange: (update) { //every change of the textField is saved internally to remember the correct state if any row is deleted
                      internalTrainingDirections[i] = update;
                  },
                  onDeleteTrainingDirection: () {
                    setState(() {
                      currTrainingDirectionsExposed.removeAt(i); //remove from the exposed trainingDirections list
                      internalTrainingDirections.removeAt(i); //remove from the internal list to update state
                    });
                    widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed); //notify parent widget about that change
                  },
                onTrainingDirectionChanged: (TrainingDirectionsData? trainingDirectionsData) { //only valid changes to a TrainingDirection are propagated else null (null => indicator that data is not valid)
                    currTrainingDirectionsExposed[i] = trainingDirectionsData; //update exposedList with valid data
                    widget.onTrainingDirectionUpdated(currTrainingDirectionsExposed); //notify parents
                },
                currTrainingDirection: internalTrainingDirections[i].split(TextRes.trainingDirectionHyphen)[0], //use the internal state to set the textField text
                currClassLevel: internalTrainingDirections[i].split(TextRes.trainingDirectionHyphen)[1], //be sure that all elements follow "String""-"String" pattern, else errors can occur

                   )
          ],

    ),
        ),
        IconButton(
            onPressed: () {
              setState(() { //setState to rebuild the for loop
                currTrainingDirectionsExposed.add(null); //first add null since the TrainingDirection is not yet valid
                internalTrainingDirections.add(TextRes.trainingDirectionHyphen); //add only the hyphen so that the splitting mechanism for state works
              });
            },
            icon: const Icon(Icons.add_circle_outline))
      ]
    );
  }
}
