

import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/login_flow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../UI/mobile/mobile_entry.dart';
import '../../../main.dart';

GoRouter getMobileRouter () {
  return GoRouter(initialLocation: initialLocation, routes: [
    ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Homepage(child: child);
        },
        routes: [
          GoRoute(
              path: LoginFlow.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                  child: const LoginFlow(),
                  transitionsBuilder: (context, animation, _, child) {
                    return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInCirc)
                            .animate(animation),
                        child: child);
                  })),
          GoRoute(
              path: ClassView.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                  child: const ClassView(),
                  transitionsBuilder: (context, animation, _, child) {
                    return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInCirc)
                            .animate(animation),
                        child: child);
                  })),
        ])
  ]);
}