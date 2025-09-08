

import 'package:buecherteam_2023_desktop/Data/tag_data.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/tag_dropdown/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Data/db.dart';
import '../../../Util/database/adder.dart';
import '../../../Util/database/getter.dart';

class StudentDetailTagDropdown extends StatefulWidget {
  const StudentDetailTagDropdown({super.key, required this.tags, required this.onTagAdded, required this.onTagDeleted, required this.onFocusChanged});

  final List<String> tags;
  final Function(TagData tag) onTagAdded;
  final Function(TagData tag) onTagDeleted;
  final Function(bool focused) onFocusChanged;

  @override
  State<StudentDetailTagDropdown> createState() => _StudentDetailTagDropdownState();
}

class _StudentDetailTagDropdownState extends State<StudentDetailTagDropdown> {

  late Future<List<TagData>> availableChips;
  late Future<List<TagData>> selectedChips;
  late DB database;
  late Future future;

  @override
  void initState() {
    super.initState();
    database = Provider.of<StudentDetailState>(context, listen: false).database;
    availableChips = getAllTagDataUtil(database);
    selectedChips = getTagsOfUtil(database, widget.tags);
    future = Future.wait([availableChips, selectedChips]);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tags != widget.tags) {
        availableChips = getAllTagDataUtil(database);
        selectedChips = getTagsOfUtil(database, widget.tags);
        future = Future.wait([availableChips, selectedChips]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width*0.4;
    return FutureBuilder(
        future: future,
        initialData: const [
          <TagData>[],
          <TagData>[]
        ],
        builder: (context, snapshot) {
          return Dropdown<TagData>(
              availableChips: snapshot.data![0],
              selectedChips: snapshot.data![1],
              onAddChip: widget.onTagAdded,
              onDeleteChip: widget.onTagDeleted,
              offsetHeight: -Dimensions.navBarHeight,
              multiSelect: true,
              onFocusChanged: widget.onFocusChanged,
              hintText: TextRes.tagDropdownHintText,
              onCreateChip: (createdChip) {
                addChip(
                    Provider.of<StudentDetailState>(context, listen: false)
                        .database,
                    createdChip);
              },
              width: width,
              onCloseOverlay: (_){}
          );
        });
  }
}





