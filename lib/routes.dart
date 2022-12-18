import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'globals/simple_storage.dart';
import 'login.dart';
import 'home.dart';
import 'coming_soon.dart';
import 'pagenotfound.dart';

// ignore: long-method
GoRouter routerGenerator() {
  final _storageService = GetIt.I.get<SimpleStorage>();
  return GoRouter(
    initialLocation: Routes.login,
    errorBuilder: (context, state) => const PageNotFound(),
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'Home',
        pageBuilder: (_, __) => NoTransitionPage(
          child: (_storageService.id != null) ? Home() : Login(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        name: 'Login',
        pageBuilder: (_, __) => const NoTransitionPage(
          child: Login(),
        ),
      ),
      GoRoute(
        path: Routes.start,
        name: 'Login2',
        pageBuilder: (_, __) => const NoTransitionPage(
          child: Login(),
        ),
      ),
      GoRoute(
        path: Routes.comingSoon,
        name: 'Coming Soon',
        pageBuilder: (_, __) => const NoTransitionPage(
          child: ComingSoon(),
        ),
      ),
    ],
  );
}

abstract class Routes {
  static const home = '/home';
  static const comingSoon = '/comingsoon';
  static const login = '/login';
  static const start = '/';
}

extension GoRouterExtensions on BuildContext {
  void emptyAndGo(String location, {Object? extra}) {
    Navigator.of(this).popUntil((route) => route.isFirst);
    replace(location, extra: extra);
  }

  void emptyAndGoNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const {},
    Object? extra,
  }) {
    Navigator.of(this).popUntil((route) => route.isFirst);
    replaceNamed(name, params: params, queryParams: queryParams, extra: extra);
  }
}
