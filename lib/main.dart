import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/right_click_state.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Theme/color_scheme.dart';
import 'package:buecherteam_2023_desktop/Theme/text_theme.dart';
import 'package:buecherteam_2023_desktop/UI/student_view.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'UI/navigation/navigationbar.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();
  await DB().initializeDatabase();
  //await DB().startReplication();
  runApp(MultiProvider(providers: [ //initialize the Viewmodels
    ChangeNotifierProvider(create: (context) => StudentListState(DB())),
    ChangeNotifierProvider(create: (context) => RightClickState(DB())),
    ChangeNotifierProvider(create: (context) => StudentDetailState(DB()))
  ],
    child: const MyApp(),
  ));
}

final _router = GoRouter(
    initialLocation: StudentView.routeName,
    routes: [
  ShellRoute(builder: (BuildContext context, GoRouterState state, Widget child) {
    return Homepage(child: child);
  },routes: [
    GoRoute(path: StudentView.routeName,
      builder: (context, state) => const StudentView()
    )
  ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
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
      appBar: const PreferredSize(
        preferredSize: Size(364, 48),
        child: LfgNavigationBar(),
      ),
      body: child
    );
  }
}
