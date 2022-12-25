import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../globals/simple_storage.dart';
import 'package:go_router/go_router.dart';
import '../routes.dart';

class BridgeAppBar {
  static PreferredSizeWidget appbar(BuildContext context) {
    final _storageService = GetIt.I.get<SimpleStorage>();
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      toolbarHeight: 100,
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "../../assets/images/logo.png",
                height: 90,
              ),
            ],
          ),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Bridge ile engelleri birlikte aşalım!",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          (MediaQuery.of(context).size.width >= 900)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${_storageService.firstName ?? ""} ${_storageService.lastName ?? ""}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      iconSize: 70,
                      onPressed: () {
                        context.go(Routes.home);
                      },
                      icon: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(48), // Image radius
                          child: Image.asset(_storageService.getAvatarAsset(),
                              width: 300, fit: BoxFit.cover),
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
