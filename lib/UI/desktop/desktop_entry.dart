
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Data/db.dart';
import '../../Models/app_introduction_state.dart';
import '../../Models/book_depot_state.dart';
import '../../Models/book_stack_view_state.dart';
import '../../Models/class_level_state.dart';
import '../../Models/navigation_state.dart';
import '../../Models/right_click_state.dart';
import '../../Models/settings/export_state.dart';
import '../../Models/settings/import_state.dart';
import '../../Models/settings/settings_nav_state.dart';
import '../../Models/settings/sync_state.dart';
import '../../Models/studentListState.dart';
import '../../Models/student_detail_state.dart';
import '../../Resources/dimensions.dart';
import '../../Theme/color_scheme.dart';
import '../../Theme/text_theme.dart';
import '../../Util/navigation/desktop/desktop_router.dart';
import 'navigation/navigationbar.dart';

MultiProvider desktopEntry = MultiProvider(
  providers: [
    //initialize the Viewmodels
    ChangeNotifierProvider(create: (context) => StudentListState(DB())),
    ChangeNotifierProvider(create: (context) => RightClickState(DB())),
    ChangeNotifierProvider(create: (context) => StudentDetailState(DB())),
    ChangeNotifierProvider(create: (context) => ClassLevelState(DB())),
    ChangeNotifierProvider(create: (context) => BookDepotState(DB())),
    ChangeNotifierProvider(create: (context) => NavigationState()),
    ChangeNotifierProvider(create: (context) => SettingsNavState()),
    ChangeNotifierProvider(create: (context) => ImportState(DB())),
    ChangeNotifierProvider(create: (context) => AppIntroductionState(DB())),
    ChangeNotifierProvider(create: (context) => ExportState(DB())),
    ChangeNotifierProvider(create: (context) => SyncState()..init()),
    ChangeNotifierProvider(create: (context) => BookStackViewState(DB()))
  ],
  child: const MyApp(),
);

final _router = getDesktopRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buecherteam',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        fontFamily: 'Helvetica Neue',
        textTheme: textTheme,
      ),
      routerConfig: _router,
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightColorScheme.background,
        appBar: PreferredSize(
          preferredSize: Size(364, Dimensions.navBarHeight),
          child: const LfgNavigationBar(),
        ),
        body: child);
  }
}