import 'package:buecherteam_2023_desktop/Data/tag_data.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:flutter/material.dart';

abstract class LfgChip implements Comparable {
  String getLabelText();

  Color? getChipColor();



  static T createChipFrom<T extends LfgChip> (String label, Color color) {
    switch (T) {
      case TagData : {
        return TagData(label, color) as T;
      }
      case TrainingDirectionsData : {
        return TrainingDirectionsData(label) as T;
      }
      default : {
        throw UnimplementedError("This type does not support Chip creation!");
      }
    }
  }

  @override
  int compareTo(other) {
    return getLabelText().compareTo(other.getLabelText());
  }
  @override
  bool operator ==(Object other) {
    if (other == this) return true;
    return other is LfgChip && other.getLabelText() == getLabelText();
  }

  @override
  int get hashCode => getLabelText().hashCode;
}
