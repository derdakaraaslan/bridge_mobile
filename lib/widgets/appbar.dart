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
    final avatars = [
      "../assets/images/avatar1.png",
      "../assets/images/avatar2.png",
      "../assets/images/avatar3.png",
      "../assets/images/avatar4.png",
      "../assets/images/avatar5.png"
    ];
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      toolbarHeight: 100,
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Bridge",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 70,
                ),
              ),
            ],
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
                          child: Image.asset(
                              avatars[int.parse(_storageService.avatarId!) - 1],
                              width: 300,
                              fit: BoxFit.cover),
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
