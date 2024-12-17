

import 'package:buecherteam_2023_desktop/Data/lfg_chip.dart';
import 'package:flutter/material.dart';

import '../Resources/text.dart';

class TagData extends LfgChip{

  TagData(this.label, this.color);

  final String label;
  final Color color;

  factory TagData.fromJson(Object data) {
    var json = data as dynamic;

    int colorValue = json[TextRes.tagDataColorJson] is int
                      ? json[TextRes.tagDataColorJson]
                      : int.parse(json[TextRes.tagDataColorJson]);
    return TagData(
        json[TextRes.tagDataLabelJson] ?? "",
        Color(colorValue)
    );
  }

  Map<String, Object?> toJson() {
    final data = {
      TextRes.tagDataLabelJson: label,
      TextRes.tagDataColorJson: color.value,
      TextRes.typeJson: TextRes.tagDataTypeJson
    };
    return data;
  }

  static TagData createFrom(String label, Color color) {
    return TagData(label, color);
  }


  @override
  int compareTo(other) {
    return other.getLabelText().compareTo(label);
  }

  @override
  String getLabelText() {
    return label;
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // If both references are the same

    return other is TagData && label == other.label;
  }

  @override
  int get hashCode => label.hashCode;

  @override
  Color? getChipColor() {
    return color;
  }




}