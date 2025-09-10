

import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/books/add_books_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/login_flow.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/student_detail.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/student_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Data/student.dart';
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
          GoRoute(
              path: "${StudentListView.routeName}/:${TextRes.classLevelPathParam}/:${TextRes.classCharPathParam}",
              pageBuilder: (context, state) {
                final int classLevel = int.parse(state.pathParameters[TextRes.classLevelPathParam]!);
                final String classChar = state.pathParameters[TextRes.classCharPathParam]!;
                return CustomTransitionPage(
                  child: StudentListView(
                      classLevel: classLevel,
                      classChar: classChar),
                  transitionsBuilder: (context, animation, _, child) {
                    return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInCirc)
                            .animate(animation),
                        child: child);
                  });
              },
            routes: [
              GoRoute(
                path: ":${TextRes.studentDetailPathParam}",
                pageBuilder: (context, state) {
                  final String studentId = state.pathParameters[TextRes.studentDetailPathParam]!;
                  return CustomTransitionPage(
                      child: StudentDetail(currStudentId: studentId),
                      transitionsBuilder: (context, animation, _, child) {
                        return FadeTransition(
                            opacity: CurveTween(curve: Curves.easeInCirc)
                                .animate(animation),
                            child: child);
                      });
                },

              ),
            ]
          ),
          GoRoute(
            path: AddBooksView.routeName,
            pageBuilder: (context, state) {
              final Student student = state.extra as Student;
              return CustomTransitionPage(
                  child: AddBooksView(student: student),
                  transitionsBuilder: (context, animation, _, child) {
                    return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInCirc)
                            .animate(animation),
                        child: child);
                  });
            },

          )


        ])
  ]);
}