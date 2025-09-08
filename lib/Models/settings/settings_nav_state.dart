import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/filter_parent.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import_parent.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/export_parent.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/sync_parent.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/warning_parent.dart';
import 'package:flutter/material.dart';

class SettingsNavState extends ChangeNotifier {
  SettingsNavButtons selectedButton = SettingsNavButtons.IMPORT;
  Widget currWidget = const ImportParent();

  void navigateTo(SettingsNavButtons navButton) {
    selectedButton = navButton;
    switch (navButton) {
      case SettingsNavButtons.IMPORT:
        currWidget = const ImportParent();
      case SettingsNavButtons.MAHNUNG:
        currWidget = const WarningParent();
      case SettingsNavButtons.FILTER:
        currWidget = const FilterParent();
      case SettingsNavButtons.EXPORT:
        currWidget = const ExportParent();
      case SettingsNavButtons.SYNC:
        currWidget = const SyncParent();
    }
    notifyListeners();
  }

  void setCurrWidget(Widget nextWidget, SettingsNavButtons navButton) {
    currWidget = nextWidget;
    selectedButton = navButton;
    notifyListeners();
  }
}

enum SettingsNavButtons {
  IMPORT("Import"),
  MAHNUNG("Mahnung"),
  FILTER("Filter"),
  EXPORT("Export"),
  SYNC("Sync");

  final String value;

  const SettingsNavButtons(this.value);
}
