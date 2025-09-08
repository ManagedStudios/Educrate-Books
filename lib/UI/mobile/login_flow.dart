

import 'package:buecherteam_2023_desktop/UI/common/sync/sync_form.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginFlow extends StatelessWidget {
  static String routeName = '/loginView';
  const LoginFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return SyncForm(onSave: () => context.go(ClassView.routeName),);
  }
}
