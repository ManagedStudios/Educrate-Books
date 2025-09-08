
import 'package:buecherteam_2023_desktop/Util/navigation/mobile/mobile_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/settings/sync_state.dart';
import '../../Theme/color_scheme.dart';
import '../../Theme/text_theme.dart';

MultiProvider mobileEntry = MultiProvider(
  providers: [
    //initialize the Viewmodels
    ChangeNotifierProvider(create: (context) => SyncState()..init()),
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
        body: child);
  }
}