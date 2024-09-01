

import '../Data/class_data.dart';

ClassData parseStringToClass(String cellValue) {

  final regex = RegExp(r'^(\d+)(\D*)$');
  final match = regex.firstMatch(cellValue);

  final numberPart = match!.group(1) ?? '';
  final textPart = match.group(2) ?? '';

  return ClassData(int.parse(numberPart), textPart.toUpperCase());

}