import 'package:get_it/get_it.dart';

import 'custom_list_tile.dart';
import 'package:flutter/material.dart';
import '../routes.dart';
import '../globals/desing.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: BridgeColors.primaryColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(2, 4), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              //CustomDrawerHeader(),
              // Divider(
              //   color: Colors.grey,
              // ),
              CustomListTile(
                icon: Icons.home_outlined,
                title: 'Ana Menü',
                infoCount: 0,
                clearDatas: false,
                location: Routes.home,
              ),

              CustomListTile(
                icon: Icons.emergency_share_outlined,
                title: 'Anlık Yardım Talebi',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),

              CustomListTile(
                icon: Icons.emoji_people_sharp,
                title: 'Refakatçi Talebi',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),

              CustomListTile(
                icon: Icons.add_to_queue,
                title: 'Ekipman Yardımı',
                infoCount: 0,
                clearDatas: false,
                location: Routes.equipment,
              ),

              CustomListTile(
                icon: Icons.record_voice_over_outlined,
                title: 'Sesli Yardım Talebi',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),
              CustomListTile(
                icon: Icons.run_circle_outlined,
                title: 'Anlık Yardım Et',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),
              CustomListTile(
                icon: Icons.wheelchair_pickup_outlined,
                title: 'Refakatçi Ol',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),
              CustomListTile(
                icon: Icons.how_to_reg_outlined,
                title: 'Ekipman Yardımı Yap',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),

              CustomListTile(
                icon: Icons.keyboard_voice_sharp,
                title: 'Sesli Yardım Yap',
                infoCount: 0,
                clearDatas: false,
                location: Routes.comingSoon,
              ),
              CustomListTile(
                icon: Icons.logout_rounded,
                title: 'Çıkış Yap',
                infoCount: 0,
                clearDatas: true,
                location: Routes.login,
              ),
              //
              // BottomUserInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
