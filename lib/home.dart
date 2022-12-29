import 'dart:convert';
import 'dart:io';
import 'globals/constants.dart';
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
  List<Container> companionRows = [];
  List<Container> equipmentRows = [];

  final _storageService = GetIt.I.get<SimpleStorage>();
  @override
  void initState() {
    _getCompanionRows(filter: {"owner": _storageService.id, "is_active": true});
    _getEquipmentRows(filter: {"owner": _storageService.id, "is_active": true});
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
              width: (MediaQuery.of(context).size.width >= 1200)
                  ? MediaQuery.of(context).size.width - 300
                  : MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Container(
                  padding: (MediaQuery.of(context).size.width >= 900)
                      ? const EdgeInsets.all(50.0)
                      : const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          (MediaQuery.of(context).size.width >= 900)
                              ? Container(
                                  width: (MediaQuery.of(context).size.width >=
                                          1200)
                                      ? MediaQuery.of(context).size.width - 400
                                      : MediaQuery.of(context).size.width - 100,
                                  child: Row(
                                    children: _getChildren(),
                                  ))
                              : Container(
                                  width: (MediaQuery.of(context).size.width >=
                                          1200)
                                      ? MediaQuery.of(context).size.width - 400
                                      : MediaQuery.of(context).size.width - 40,
                                  child: Column(
                                    children: _getChildren(),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width >= 900)
                            ? MediaQuery.of(context).size.width - 400
                            : MediaQuery.of(context).size.width - 50,
                        child: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          if (constraints.maxWidth > 1200.0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width:
                                      (constraints.maxWidth > 400) ? 400 : 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 400,
                                        height: 40,
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Refakatçi Taleplerim",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: companionRows,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                  height: 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width:
                                      (constraints.maxWidth > 400) ? 400 : 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 400,
                                        height: 40,
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Ekipman Taleplerim",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: equipmentRows,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width:
                                      (constraints.maxWidth > 400) ? 400 : 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 400,
                                        height: 40,
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Refakatçi Taleplerim",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: companionRows,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width:
                                      (constraints.maxWidth > 400) ? 400 : 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 400,
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Colors.black87),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Ekipman Taleplerim",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: equipmentRows,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                      )
                    ],
                  ),
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
      Stack(
        children: [
          Image.asset(
            _storageService.getAvatarAsset(),
            width: 300,
          ),
          Container(
            width: 300,
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: _onChangeAvatarButtonPressed,
              icon: Icon(Icons.change_circle,
                  color: BridgeColors.primaryColor, size: 40),
            ),
          ),
        ],
      ),
      SizedBox(
        width: 100,
        height: 100,
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

  _getCompanionRows({Map? filter}) {
    final url = "${globalUrl}companion_request/search";
    try {
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, Map>{
          "filter": filter ?? {},
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}'
        },
      ).then((value) {
        if (value.statusCode == 200) {
          companionRows = [];

          setState(() {
            var responseBody = jsonDecode(value.body);
            for (var element in responseBody) {
              var date = DateTime.parse(element["date"]);
              var strDate =
                  "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
              if (companionRows.length < 4) {
                companionRows.add(_getContainerRow(
                  "${globalUrl}companion_request/${element["id"]}",
                  date: strDate,
                  title: element["title"],
                ));
              }
            }
          });
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu.");
    }
  }

  _getEquipmentRows({Map? filter}) {
    final url = "${globalUrl}equipment_help/search";
    try {
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, Map>{
          "filter": filter ?? {},
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}'
        },
      ).then((value) {
        if (value.statusCode == 200) {
          equipmentRows = [];

          setState(() {
            var responseBody = jsonDecode(value.body);
            for (var element in responseBody) {
              var date = DateTime.parse(element["share_date"]);
              var strDate = "${date.day}/${date.month}/${date.year}";
              if (equipmentRows.length < 4) {
                equipmentRows.add(_getContainerRow(
                  "${globalUrl}equipment_help/${element["id"]}",
                  date: strDate,
                  title: element["title"],
                ));
              }
            }
          });
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu.");
    }
  }

  Container _getContainerRow(String url,
      {String? date, String? ownerAvatarId, String? title, String? id}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
      alignment: Alignment.center,
      height: 40,
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        titleTextStyle: const TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever_outlined),
          onPressed: () {
            http.delete(
              Uri.parse(url),
              body: {},
              headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${_storageService.apiToken}',
              },
            ).then((value) {
              if (value.statusCode == 200) {
                BridgeToast.showSuccessToastMessage("Kayıt Silindi");
                initState();
              }
            });
          },
        ),
        title: Text(title ?? ""),
        leading: (ownerAvatarId != null)
            ? Image.asset(
                _storageService.getAvatarAsset(newAvatarId: ownerAvatarId),
                width: 100,
              )
            : null,
      ),
    );
  }

  _onChangeAvatarButtonPressed() {
    var url = "${globalUrl}app_users/change_avatar";
    try {
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{'id': _storageService.id ?? ""}),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}',
        },
      ).then((value) async {
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
