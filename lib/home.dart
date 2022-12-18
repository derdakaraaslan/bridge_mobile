import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'appbar/appbar.dart';
import 'package:get_it/get_it.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BridgeAppBar.appbar(context),
      backgroundColor: Colors.white,
      drawer: MediaQuery.of(context).size.width < 1000
          ? const CustomDrawer()
          : null,
      body: Container(
        margin:
            const EdgeInsets.only(bottom: 40, top: 40, left: 150, right: 150),
        child: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 1000) ...[
              const CustomDrawer(),
              const SizedBox(
                width: 100,
              ),
            ],
            Column(
              children: [
                _storageService.getProfilePhoto(width: 240),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Adı Soyadı:\t\t",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Email:\t\t",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Bir engeli var mı?:\t\t",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_storageService.firstName ?? ""} ${_storageService.lastName ?? ""}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${_storageService.email ?? ""}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  (_storageService.isDisabled == true) ? "Evet" : "Hayır",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
