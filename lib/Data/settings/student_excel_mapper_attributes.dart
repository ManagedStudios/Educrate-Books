import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';

import '../../Resources/text.dart';

/*
This enum enables easy attribute mapping: You can behave according to the
Enums without error pron String checks
 */
enum StudentAttributes implements LfgChip {
  FIRSTNAME(TextRes.studentAttrbMapperFirstname),
  LASTNAME(TextRes.studentAttrbMapperLastname),
  CLASS(TextRes.studentAttrbMapperClass),
  TRAININGDIRECTION(TextRes.studentAttrbMapperTrainingDirection),
  TAGS(TextRes.studentAttrbMapperTags);

  final String value;

  const StudentAttributes(this.value);

  @override
  String getLabelText() {
    return value;
  }

  @override
  int compareTo(other) {
    LfgChip chip = other as LfgChip;
    return getLabelText()
        .toUpperCase()
        .compareTo(chip.getLabelText().toUpperCase());
  }


}
