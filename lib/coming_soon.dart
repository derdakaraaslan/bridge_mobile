import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sidebarx/sidebarx.dart';
import './drawer/custom_drawer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'appbar/appbar.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BridgeAppBar.appbar(context),
      backgroundColor: Colors.white,
      drawer: !kIsWeb ? const CustomDrawer() : null,
      body: Row(children: [
        if (kIsWeb) ...[
          const CustomDrawer(),
        ],
        SizedBox(
            width: MediaQuery.of(context).size.width - 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bu Sayfa Henüz Yapım Aşamasındadır...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset("../assets/images/comingsoon.png", width: 500),
              ],
            )),
      ]),
    );
  }
}
