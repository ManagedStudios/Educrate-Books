import 'package:buecherteam_2023_desktop/Data/book.dart';
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/app_introduction_state.dart';
import 'package:buecherteam_2023_desktop/Models/book_depot_state.dart';
import 'package:buecherteam_2023_desktop/Models/class_level_state.dart';
import 'package:buecherteam_2023_desktop/Models/navigation_state.dart';
import 'package:buecherteam_2023_desktop/Models/right_click_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/app_introduction/introduction_scaffold.dart';
import 'package:buecherteam_2023_desktop/UI/app_introduction/select_db_path.dart';
import 'package:buecherteam_2023_desktop/UI/book_depot_view.dart';
import 'package:buecherteam_2023_desktop/UI/book_stack_view.dart';
import 'package:buecherteam_2023_desktop/UI/student_view.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'Data/shared_preferences.dart';
import 'UI/app_introduction/add_class_data.dart';
import 'UI/navigation/navigationbar.dart';
import 'Util/settings/import/io_util.dart';

late String initialLocation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();

  String? dbPath = await getPreference(TextRes.dbPath);
  if (dbPath != null && await pathExists(dbPath)) {
    initialLocation = StudentView.routeName;
    await DB().initializeDatabase(dbPath);
  } else {
    initialLocation = TextRes.introPaths[0];
  }

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
    ],
    child: const MyApp(),
  ));
}





final _router = GoRouter(initialLocation: initialLocation, routes: [
  ShellRoute(
    builder: (BuildContext context, GoRouterState state, Widget child) {
      return IntroductionScaffold(child: child);
    },
    routes: [
      GoRoute(
          path: TextRes.introPaths[0],
          pageBuilder: (context, state) => CustomTransitionPage(
              child: const SelectDbPath(),
              transitionsBuilder: (context, animation, _, child) {
                return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInCirc)
                        .animate(animation),
                    child: child);
              })),
      GoRoute(
          path: TextRes.introPaths[1],
          pageBuilder: (context, state) => CustomTransitionPage(
              child: const AddClassData(),
              transitionsBuilder: (context, animation, _, child) {
                return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInCirc)
                        .animate(animation),
                    child: child);
              })),
    ]
  ),
  ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return Homepage(child: child);
      },
      routes: [
        GoRoute(
            path: StudentView.routeName,
            pageBuilder: (context, state) => CustomTransitionPage(
                child: StudentView(filterBook: state.extra as Book?),
                transitionsBuilder: (context, animation, _, child) {
                  return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInCirc)
                          .animate(animation),
                      child: child);
                })),
        GoRoute(
            path: BookDepotView.routeName,
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const BookDepotView(),
                transitionsBuilder: (context, animation, _, child) {
                  return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInCirc)
                          .animate(animation),
                      child: child);
                })),
        GoRoute(
            path: BookStackView.routeName,
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const BookStackView(),
                transitionsBuilder: (context, animation, _, child) {
                  return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInCirc)
                          .animate(animation),
                      child: child);
                }))
      ])
]);

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
      //TODO add background color manually and delete background in color scheme
        appBar: const PreferredSize(
          preferredSize: Size(364, 56),
          child: LfgNavigationBar(),
        ),
        body: child);
  }
}
