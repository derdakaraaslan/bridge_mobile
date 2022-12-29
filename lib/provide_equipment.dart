import 'dart:convert';
import 'dart:io';
import 'globals/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';
import 'globals/desing.dart';
import 'globals/functions.dart';
import 'package:http/http.dart' as http;

class ProvideEquipment extends StatefulWidget {
  const ProvideEquipment({Key? key}) : super(key: key);

  @override
  State<ProvideEquipment> createState() => _ProvideEquipmentState();
}

class _ProvideEquipmentState extends State<ProvideEquipment> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  Widget newProvideEquipmentHelp = Container();
  String dropdownValue = 'Diğer';

  List<String> equipmentsTypeList = [];
  Map<String, String> equipmentsTypeMap = {};
  String? selectedEqipment;
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _getEquipmentsType();
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
            SizedBox(
              width: (MediaQuery.of(context).size.width >= 1200)
                  ? MediaQuery.of(context).size.width - 300
                  : MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 400,
                      height: 600,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: BridgeColors.secondaryColor),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: newProvideEquipmentHelp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onNewAdvertButtonPressed() {
    setState(() {
      newProvideEquipmentHelp = _formNewAdvert();
    });
  }

  _onNewAdvertConfirmButtonPressed() {
    var url = "${globalUrl}equipment_help/create";

    try {
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, Object>{
          'owner': {"id": _storageService.id ?? ""},
          'title': _titleController.text,
          'comment': _commentController.text,
          "equipment_id": equipmentsTypeMap[dropdownValue] ?? "",
          "phone_numner": _phoneController.text,
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}',
        },
      ).then((value) {
        if (value.statusCode == 200) {
          BridgeToast.showSuccessToastMessage("Kayıt başarıyla yapıldı.");
          initState();
        } else {
          BridgeToast.showErrorToastMessage(value.body);
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu, kayıt başarısız.");
    }
  }

  _getEquipmentsType() {
    var url = "${globalUrl}equipment_type/search";
    equipmentsTypeList = [];
    try {
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, Map>{
          "filter": {},
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}',
        },
      ).then((value) {
        if (value.statusCode == 200) {
          setState(() {
            var responseBody = jsonDecode(value.body);
            for (var element in responseBody) {
              equipmentsTypeList.add(element["name"]);
              equipmentsTypeMap.addAll({element["name"]: element["id"]});
            }
            _onNewAdvertButtonPressed();
          });
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu.");
    }

    return [];
  }

  Widget _formNewAdvert() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: DropdownButton<String>(
                alignment: AlignmentDirectional.topStart,
                value: dropdownValue,
                items: equipmentsTypeList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.topStart,
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  dropdownValue = newValue!;
                  _onNewAdvertButtonPressed();
                },
              ),
            ),
            Container(
              width: 350,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Lütfen başlık ekleyiniz",
                  labelText: 'Başlık',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BridgeColors.secondaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Container(
              width: 350,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Lütfen açıklama ekleyiniz",
                  labelText: 'Açıklama',
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BridgeColors.secondaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                maxLines: 5,
              ),
            ),
            Container(
              width: 350,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('../assets/images/92388_turkey_icon.png',
                      width: 40),
                  Text(
                    "+90",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 260,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: "Lütfen telefon numarası ekleyiniz",
                        labelText: 'Telefon numarası',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: BridgeColors.secondaryColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: 350,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: BridgeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      newProvideEquipmentHelp = Container();
                    });
                  },
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("İptal"),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: BridgeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _onNewAdvertConfirmButtonPressed,
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text("Onayla"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
