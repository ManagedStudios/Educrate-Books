
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';

class ClassData implements LfgChip{

  ClassData(this.classLevel, this.classChar);

  final int classLevel;
  final String classChar;

  @override
  int compareTo(other) {
    LfgChip otherStr = other as LfgChip;
    return getLabelText().compareTo(otherStr.getLabelText());
  }

  @override
  String getLabelText() {
    return "$classLevel$classChar";
  }


}