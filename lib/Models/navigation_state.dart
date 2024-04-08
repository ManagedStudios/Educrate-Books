import 'package:flutter/material.dart';


class NavigationState extends ChangeNotifier {
  bool isStudentViewClicked = true;
  bool isBookViewClicked = false;

  void onStudentViewClicked () {
      isStudentViewClicked = true;
      isBookViewClicked = false;
      notifyListeners();

  }

  void onBookViewClicked () {
      isBookViewClicked = true;
      isStudentViewClicked = false;
      notifyListeners();

  }
}