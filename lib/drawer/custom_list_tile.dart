import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../globals/simple_storage.dart';

final _storageService = GetIt.I.get<SimpleStorage>();

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool? clearDatas;
  final int infoCount;
  final String location;

  const CustomListTile({
    Key? key,
    required this.icon,
    required this.location,
    required this.title,
    this.clearDatas,
    required this.infoCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (clearDatas == true) {
          _storageService.clearDatas();
        }

        context.go(location);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 300,
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                    if (infoCount > 0)
                      Positioned(
                        right: -5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  if (infoCount > 0)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purple[200],
                        ),
                        child: Center(
                          child: Text(
                            infoCount.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
