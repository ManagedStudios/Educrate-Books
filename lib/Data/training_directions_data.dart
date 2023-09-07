
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';

class TrainingDirectionsData implements LfgChip {

  const TrainingDirectionsData(this.label, this.classLevel);

  final String label;
  final int classLevel;

  @override
  String getLabelText() {
    return label;
  }

  @override
  int compareTo(other) {
    LfgChip chip = other as LfgChip;
    return getLabelText().compareTo(chip.getLabelText());
  }


}