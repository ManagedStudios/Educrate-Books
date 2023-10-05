
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class TrainingDirectionsData implements LfgChip {

  const TrainingDirectionsData(this.label);

  final String label;

  factory TrainingDirectionsData.fromJson(Object data) {
    var json = data as dynamic;
    return TrainingDirectionsData(json[TextRes.trainingDirectionsJson]??"");
  }

  Map<String, Object?> toJson() {
    final data = {
      TextRes.trainingDirectionsJson:label,
      TextRes.typeJson:TextRes.trainingDirectionsTypeJson
    };
    return data;
  }

  @override
  String getLabelText() {
    return label;
  }

  @override
  int compareTo(other) {
    LfgChip chip = other as LfgChip;
    return getLabelText().toUpperCase().compareTo(chip.getLabelText().toUpperCase());
  }


}