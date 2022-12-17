//ignore_for_file: prefer-match-file-name
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:go_router/go_router.dart';
import 'login.dart';
import 'routes.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  runApp(const BridgeApp());
}

class BridgeApp extends StatefulWidget {
  const BridgeApp({Key? key}) : super(key: key);

  @override
  State<BridgeApp> createState() => BridgeAppState();
}

class BridgeAppState extends State<BridgeApp> {
  // This widget is the root of your application.
  bool _isLoading = false;
  late final GoRouter _router;
  @override
  void initState() {
    super.initState();
    _router = routerGenerator();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp.router(
        title: 'Bridge',
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('tr', 'TR')],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        builder: (context, child) {
          return Stack(
            children: [
              child ?? Login(),
            ],
          );
        },
      ),
    );
  }
}
