import 'dart:convert';
import 'globals/constants.dart';
import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';
import 'globals/desing.dart';
import 'globals/functions.dart';
import 'package:http/http.dart' as http;

class Equipment extends StatefulWidget {
  const Equipment({Key? key}) : super(key: key);

  @override
  State<Equipment> createState() => _EquipmentState();
}

class _EquipmentState extends State<Equipment> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  List<Container> rows = [];

  @override
  void initState() {
    // TODO: implement initState
    _getRows();
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
      body: Row(
        mainAxisAlignment: (MediaQuery.of(context).size.width >= 1200)
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          if (MediaQuery.of(context).size.width >= 1200) ...[
            const CustomDrawer(),
          ],
          Stack(
            children: [
              Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("data")],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 100.0),
                child: SingleChildScrollView(
                  child: Container(
                    width: (MediaQuery.of(context).size.width >= 1200)
                        ? MediaQuery.of(context).size.width - 300
                        : MediaQuery.of(context).size.width,
                    padding: (MediaQuery.of(context).size.width >= 900)
                        ? const EdgeInsets.all(50.0)
                        : const EdgeInsets.all(20.0),
                    child: Column(
                      children: rows,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Container> _getRows() {
    final url = "${globalUrl}equipment_help/search";
    try {
      http
          .post(
        Uri.parse(url),
        body: jsonEncode(<String, Map>{
          "filter": {},
        }),
      )
          .then((value) async {
        if (value.statusCode == 200) {
          setState(() {
            var responseBody = jsonDecode(value.body);
            for (var element in responseBody) {
              rows.add(_getContainerRow(
                title: element["title"],
                comment: element["comment"],
                equipment: element["equipment"],
                shareDate: element["share_date"],
              ));
            }
          });
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu.");
    }

    return [];
  }

  Container _getContainerRow(
      {String? base64Image,
      String? title,
      String? comment,
      String? equipment,
      String? shareDate}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black87))),
      child: ListTile(
        textColor: Colors.black,
        trailing: Text(shareDate ?? ""),
        subtitle: Text(comment ?? ""),
        title: Text(title ?? ""),
        //leading: Text(sharaDate ?? ""),
        leading: geteEquipmentPhoto(base64Image),
      ),
    );
  }
}
