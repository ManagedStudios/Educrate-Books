

import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Data/shared_preferences.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/student_view.dart';
import 'package:cbl/cbl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Data/db.dart';

class AppIntroductionState extends ChangeNotifier {
  AppIntroductionState(this.database);

  final DB database;

  String? selectedPath;
  int currIntroIndex = 0;
  String? currError;
  List<ClassData>? classesToImport;
  bool dbInitialized = false;

  Future<void> getAndSavePath() async{
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;
    selectedPath = selectedDirectory;
    await savePreference(TextRes.dbPath, selectedPath!);
    currError = null;
    notifyListeners();
  }

  Future<void> goToNextPage (BuildContext context) async{
    currIntroIndex++;
    if (currIntroIndex < TextRes.introPaths.length) {
      context.go(TextRes.introPaths[currIntroIndex]);
    } else {
      context.go(StudentView.routeName);
    }
  }

  void setClassData(Map<TextEditingController, List<ClassData>?> controllerToData) {
    bool hasError = false;
    if (controllerToData.isEmpty) return;
    classesToImport = [];
    for (MapEntry<TextEditingController, List<ClassData>?> entry in controllerToData.entries) {
      if (entry.value == null) {
        classesToImport = null;
        hasError = true;
      } else {
        classesToImport?.addAll(entry.value!);
      }
    }
    if (hasError) {
      currError = TextRes.correctClassData;
    } else {
      currError = null;
    }
    notifyListeners();
  }

  Future<void> saveClasses() async{
    if (classesToImport == null) {
      currError = TextRes.correctClassData;
      notifyListeners();
    } else {
      List<MutableDocument> docs = [];
      for (ClassData classData in classesToImport!) {
          MutableDocument doc = MutableDocument();
          database.updateDocFromEntity(classData, doc);
          docs.add(doc);
      }
      await database.saveDocuments(docs);
    }

  }

}