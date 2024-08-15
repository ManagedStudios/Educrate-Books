

import 'package:buecherteam_2023_desktop/UI/settings_dialog/filter_parent.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import_parent.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/print_parent.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/warning_parent.dart';
import 'package:flutter/material.dart';

class SettingsNavState extends ChangeNotifier {

  SettingsNavButtons selectedButton = SettingsNavButtons.IMPORT;
  Widget currWidget = ImportParent();

  void navigateTo (SettingsNavButtons navButton) {
    if (navButton == selectedButton) return;
    selectedButton = navButton;
    switch(navButton) {
      case SettingsNavButtons.IMPORT:
        currWidget = ImportParent();
      case SettingsNavButtons.MAHNUNG:
        currWidget = WarningParent();
      case SettingsNavButtons.FILTER:
        currWidget = FilterParent();
      case SettingsNavButtons.DRUCKEN:
        currWidget = PrintParent();
    }
    notifyListeners();
  }

  void setCurrWidget (Widget nextWidget) {
    currWidget = nextWidget;
    notifyListeners();
  }

}

enum SettingsNavButtons {
  IMPORT("Import"),
  MAHNUNG("Mahnung"),
  FILTER("Filter"),
  DRUCKEN("Drucken");

  final String value;

  const SettingsNavButtons(this.value);

}