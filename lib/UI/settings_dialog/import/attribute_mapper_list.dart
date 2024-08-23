import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/attribute_mapper.dart';
import 'package:flutter/material.dart';

/*
Widget that creates a List of Attribute Mappers in a column and sends the latest
Excel-Attribute-Map whenever any of the Attribute Mappers has changed.
 */
class AttributeMapperList<T extends LfgChip> extends StatefulWidget {
  const AttributeMapperList(
      {super.key,
      required this.availableDropdownItems,
      required this.initialMap,
      required this.onUpdatedMap,
      required this.width});

  final List<T> availableDropdownItems;
  final Map<ExcelData, T?> initialMap;
  final Function(Map<ExcelData, T?> updatedItems) onUpdatedMap;
  final double width;

  @override
  State<AttributeMapperList<T>> createState() => _AttributeMapperListState<T>();
}

class _AttributeMapperListState<T extends LfgChip>
    extends State<AttributeMapperList<T>> {
  late Map<ExcelData, T?> currMap;

  @override
  void initState() {
    super.initState();
    currMap = widget.initialMap;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (MapEntry<ExcelData, T?> entry in widget.initialMap.entries)
          AttributeMapper<T>(
              excelDataKey: entry.key,
              availableAttributes: widget.availableDropdownItems,
              width: widget.width,
              selectedAttribute: entry.value,
              onItemSelected: (T item) {
                currMap[entry.key] = item;
                widget.onUpdatedMap(currMap);
              })
      ],
    );
  }
}
