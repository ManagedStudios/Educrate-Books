
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/Util/navigation/mobile/mobile_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/settings/sync_state.dart';
import '../../Resources/dimensions.dart';
import '../../Theme/color_scheme.dart';
import '../../Theme/text_theme.dart';

MultiProvider mobileEntry = MultiProvider(
  providers: [
    //initialize the Viewmodels
    ChangeNotifierProvider(create: (context) => SyncState()..init()),
    ChangeNotifierProvider(create: (context) => StudentListState(DB())),
    ChangeNotifierProvider(create: (context) => StudentDetailState(DB()))
  ],
  child: const MyApp(),
);

final _router = getMobileRouter();

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
        body: Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingVeryBig),
          child: child,
        ));
  }
}