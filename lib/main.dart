
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/app_introduction_state.dart';
import 'package:buecherteam_2023_desktop/Models/book_depot_state.dart';
import 'package:buecherteam_2023_desktop/Models/book_stack_view_state.dart';
import 'package:buecherteam_2023_desktop/Models/class_level_state.dart';
import 'package:buecherteam_2023_desktop/Models/navigation_state.dart';
import 'package:buecherteam_2023_desktop/Models/right_click_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/export_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/sync_state.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/Util/navigation/desktop_router.dart';
import 'package:buecherteam_2023_desktop/Util/navigation/nav_logic.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Resources/dimensions.dart';
import 'UI/navigation/navigationbar.dart';

late String initialLocation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();

  await DB().initializeDatabase();


  initialLocation = await getInitialPath();

  //TODO shift init methods down to the widget and show a startup screen while initializing
  runApp(MultiProvider(
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
  ));
}


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
