import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './drawer/custom_drawer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'routes.dart';

class PageNotFound extends StatefulWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  State<PageNotFound> createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Bu Sayfa Bulunamadı!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset("../assets/images/pagenotfound.png", width: 500),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      context.go(Routes.home);
                    },
                    child: Text("Ana sayfaya dönmek için tıklayınız."))
              ],
            )),
      ]),
    );
  }
}
