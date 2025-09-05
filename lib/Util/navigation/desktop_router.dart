
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Data/book.dart';
import '../../Resources/text.dart';
import '../../UI/app_introduction/add_class_data.dart';
import '../../UI/app_introduction/add_sync.dart';
import '../../UI/book_depot_view.dart';
import '../../UI/book_stack_view.dart';
import '../../UI/student_view.dart';
import '../../main.dart';

GoRouter getDesktopRouter () {
  return GoRouter(initialLocation: initialLocation, routes: [
    GoRoute(
        path: TextRes.introPaths[0],
        pageBuilder: (context, state) => CustomTransitionPage(
            child: const AddClassData(),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInCirc)
                      .animate(animation),
                  child: child);
            })),
    GoRoute(
        path: TextRes.introPaths[1],
        pageBuilder: (context, state) => CustomTransitionPage(
            child: const AddSync(),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInCirc)
                      .animate(animation),
                  child: child);
            })),
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
}