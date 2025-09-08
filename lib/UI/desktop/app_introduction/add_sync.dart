

import 'package:buecherteam_2023_desktop/Models/settings/sync_state.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/app_introduction/introduction_scaffold.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/sync_parent.dart';
import 'package:buecherteam_2023_desktop/Util/navigation/desktop/nav_logic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';



class AddSync extends IntroductionScaffold {

  const AddSync({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return const SyncParent();
  }

  @override
  void onNext(BuildContext context) async{
    final state = Provider.of<SyncState>(context, listen: false);
    final router = GoRouter.of(context);
    await state.awaitOneSyncCycle();
    if (!context.mounted) return;
    String location = await getInitialPath();
    router.go(location);

  }

}