import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';

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
      drawer: MediaQuery.of(context).size.width < 1200
          ? const CustomDrawer()
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 1200) ...[
            const CustomDrawer(),
          ],
          Container(
            height: MediaQuery.of(context).size.height,
            width: (MediaQuery.of(context).size.width >= 1200)
                ? MediaQuery.of(context).size.width - 300
                : MediaQuery.of(context).size.width,
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
                (MediaQuery.of(context).size.width >= 1200)
                    ? Image.asset("../assets/images/comingsoon.png", width: 500)
                    : Image.asset("../assets/images/comingsoon.png",
                        width: 250),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
