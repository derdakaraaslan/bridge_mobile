import 'dart:convert';

import 'package:bridge_mobile/routes.dart';
import 'package:flutter/material.dart';
import 'globals/desing.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BridgeAppBar.appbar(context),
      backgroundColor: Colors.white,
      drawer: MediaQuery.of(context).size.width < 1200
          ? const CustomDrawer()
          : null,
      body: Center(
        child: Row(
          mainAxisAlignment: (MediaQuery.of(context).size.width >= 1200)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (MediaQuery.of(context).size.width >= 1200) ...[
              const CustomDrawer(),
            ],
            Container(
              padding: (MediaQuery.of(context).size.width >= 900)
                  ? const EdgeInsets.all(50.0)
                  : const EdgeInsets.all(20.0),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (MediaQuery.of(context).size.width >= 900)
                        ? Row(
                            children: _getChildren(),
                          )
                        : Column(
                            children: _getChildren(),
                          ),
                    Row(
                      children: const [
                        Text(
                          "BURAYA YARDIM VERİLERE GELECEK\t\t",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getChildren() {
    return [
      Column(
        children: [
          Image.asset(
            _storageService.getAvatarAsset(),
            width: 300,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _onChangeAvatarButtonPressed,
            child: Text("Avatarı değiştir",
                style: TextStyle(color: BridgeColors.primaryColor)),
          ),
        ],
      ),
      Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Adı Soyadı:\t\t",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Email:\t\t",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Bir engeli var mı?:\t\t",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_storageService.firstName} ${_storageService.lastName}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "${_storageService.email}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                (_storageService.isDisabled == true) ? "Evet" : "Hayır",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  _onChangeAvatarButtonPressed() {
    const url = "http://localhost:8000/app_users/change_avatar";
    try {
      http
          .post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{'id': _storageService.id ?? ""}),
      )
          .then((value) async {
        if (value.statusCode == 200) {
          var responseBody = jsonDecode(value.body);
          setState(() {
            _storageService.avatarId = responseBody["message"];
          });

          BridgeToast.showSuccessToastMessage("Avatar değiştirildi");
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu");
    }
  }
}
