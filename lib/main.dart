//ignore_for_file: prefer-match-file-name
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'login.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bridge Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
