
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';

class TrainingDirectionsData implements LfgChip {

  const TrainingDirectionsData(this.label);

  final String label;

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