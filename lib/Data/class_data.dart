
import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';

class ClassData implements LfgChip{

  ClassData(this.classLevel, this.classChar);


  final int classLevel;
  final String classChar;

  factory ClassData.fromJson(Map<String, Object?> json) {
    return ClassData(
        json[TextRes.classDataClassLevelJson] is int ? json[TextRes.classDataClassLevelJson] as int : int.parse(json[TextRes.classDataClassLevelJson] as String)
        ,json[TextRes.classDataClassCharJson] as String
    );
  }

  Map<String, Object?> toJson () {
    return {
      TextRes.classDataClassLevelJson:classLevel,
      TextRes.classDataClassCharJson:classChar,
      TextRes.typeJson:TextRes.classDataTypeJson
    };
  }

  @override
  int compareTo(other) {
    ClassData otherData = other as ClassData;
    if(otherData.classLevel<classLevel) return 1;
    if(otherData.classLevel==classLevel) {
      return classChar.compareTo(otherData.classChar);
    }
    return -1;
  }

  @override
  String getLabelText() {
    return "$classLevel$classChar";
  }


}