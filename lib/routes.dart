import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'globals/simple_storage.dart';
import 'login.dart';
import 'home.dart';
import 'coming_soon.dart';
import 'pagenotfound.dart';
import 'equipment.dart';

// ignore: long-method
GoRouter routerGenerator() {
  final _storageService = GetIt.I.get<SimpleStorage>();

  return GoRouter(
    initialLocation: Routes.login,
    errorBuilder: (context, state) => const PageNotFound(),
    redirect: (_, state) {
      final isOnLogin = state.location == Routes.login;
      final isLoggedIn = _storageService.id != null;

      if (!isOnLogin && !isLoggedIn) return Routes.login;
      if (isOnLogin && isLoggedIn) return Routes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'Home',
        pageBuilder: (_, __) => const NoTransitionPage(
          child: Home(),
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
      GoRoute(
        path: Routes.equipment,
        name: 'Equipment',
        pageBuilder: (_, __) => const NoTransitionPage(
          child: Equipment(),
        ),
      ),
    ],
  );
}

abstract class Routes {
  static const home = '/home';
  static const comingSoon = '/comingsoon';
  static const login = '/login';
  static const equipment = '/equipment';
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
