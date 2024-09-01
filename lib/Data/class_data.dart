import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class ClassData implements LfgChip {
  ClassData(this.classLevel, this.classChar);

  final int classLevel;
  final String classChar;

  factory ClassData.fromJson(Map<String, Object?> json) {
    return ClassData(
        json[TextRes.classDataClassLevelJson] is int
            ? json[TextRes.classDataClassLevelJson] as int
            : int.parse(json[TextRes.classDataClassLevelJson] as String),
        json[TextRes.classDataClassCharJson] as String);
  }

  Map<String, Object?> toJson() {
    return {
      TextRes.classDataClassLevelJson: classLevel,
      TextRes.classDataClassCharJson: classChar,
      TextRes.typeJson: TextRes.classDataTypeJson
    };
  }

  @override
  int compareTo(other) {
    ClassData otherData = other as ClassData;
    if (otherData.classLevel < classLevel) return 1;
    if (otherData.classLevel == classLevel) {
      return classChar
          .toUpperCase()
          .compareTo(otherData.classChar.toUpperCase());
    }
    return -1;
  }

  @override
  String getLabelText() {
    return "$classLevel$classChar";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    return other is ClassData && classLevel == other.classLevel && classChar == other.classChar;
  }

  @override
  int get hashCode => classLevel.hashCode + classChar.hashCode;
}
