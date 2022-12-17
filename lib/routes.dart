import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'login.dart';
import 'home.dart';

// ignore: long-method
GoRouter routerGenerator() {
  return GoRouter(
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'Home',
        pageBuilder: (_, __) => const NoTransitionPage(
          child: Home(),
        ),
      ),
    ],
  );
}

abstract class Routes {
  static const home = '/home';
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
