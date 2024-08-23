
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/attribute_mapper.dart';
import 'package:flutter/material.dart';

class AttributeMapperList<T extends LfgChip> extends StatefulWidget {
  const AttributeMapperList({super.key, required this.availableDropdownItems, required this.excelDataKeys, required this.onUpdatedMap, required this.width});

  final List<T> availableDropdownItems;
  final List<ExcelData> excelDataKeys;
  final Function(Map<ExcelData, T> updatedItems) onUpdatedMap;
  final double width;

  @override
  State<AttributeMapperList<T>> createState() => _AttributeMapperListState<T>();
}

class _AttributeMapperListState<T extends LfgChip> extends State<AttributeMapperList<T>> {

  Map<ExcelData, T> currMap = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (ExcelData key in widget.excelDataKeys)
          AttributeMapper<T>(
              excelDataKey: key,
              availableAttributes: widget.availableDropdownItems,
              width: widget.width,
              onItemSelected: (T item) {
                currMap[key] = item;
                widget.onUpdatedMap(currMap);
              })
      ],
    );
  }
}
