import 'package:flutter/material.dart';

abstract class LfgChip implements Comparable {
  String getLabelText();

  Color? getChipColor();

  @override
  bool operator ==(Object other) {
    if (other == this) return true;
    return other is LfgChip && other.getLabelText() == getLabelText();
  }

  @override
  int get hashCode => getLabelText().hashCode;
}
