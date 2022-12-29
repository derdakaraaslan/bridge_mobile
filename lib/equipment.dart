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

class Equipment extends StatefulWidget {
  const Equipment({Key? key}) : super(key: key);

  @override
  State<Equipment> createState() => _EquipmentState();
}

class _EquipmentState extends State<Equipment> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  List<Container> rows = [];
  List<Container> equipmentTypeButtons = [];
  Widget newEquipmentHelp = Container();
  Widget detail = Container();
  String dropdownValue = 'Diğer';

  List<String> equipmentsTypeList = [];
  Map<String, String> equipmentsTypeMap = {};
  String? selectedEqipment;
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  final _phoneController = TextEditingController();

  Map<String, String> _selectedRow = {};

  @override
  void initState() {
    // TODO: implement initState
    equipmentTypeButtons = [];
    if (selectedEqipment != null) {
      _getRows(
          filter: {"equipment__name": selectedEqipment, "is_active": true});
    } else {
      _getRows(filter: {"is_active": true});
    }
    _getEquipmentsType();
    rows = [];
    equipmentTypeButtons = [];
    newEquipmentHelp = Container();
    detail = Container();
    dropdownValue = 'Diğer';

    equipmentsTypeList = [];
    equipmentsTypeMap = {};
    selectedEqipment;
    _titleController.text = "";
    _commentController.text = "";
    _phoneController.text = "";

    Map<String, String> _selectedRow = {};
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
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Row(
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
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 20.0),
                    width: (MediaQuery.of(context).size.width >= 1200)
                        ? MediaQuery.of(context).size.width - 300
                        : MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Row(
                            children: equipmentTypeButtons,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, left: 10),
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
                                  selectedEqipment = null;
                                  initState();
                                });
                              },
                              child: SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text("Tümü"),
                                ),
                              ),
                            ),
                          )
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10, left: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: BridgeColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: _onNewAdvertButtonPressed,
                                child: const SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Text("Yeni İlan Oluştur"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 110.0),
                    child: SingleChildScrollView(
                      child: Container(
                        width: (MediaQuery.of(context).size.width >= 1200)
                            ? MediaQuery.of(context).size.width - 300
                            : MediaQuery.of(context).size.width,
                        padding: (MediaQuery.of(context).size.width >= 900)
                            ? const EdgeInsets.only(left: 50.0, right: 50.0)
                            : const EdgeInsets.only(left: 50.0, right: 50.0),
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
          newEquipmentHelp,
          detail,
        ],
      ),
    );
  }

  _getRows({Map? filter}) {
    final url = "${globalUrl}equipment_help/search";
    try {
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, Map>{
          "filter": filter ?? {},
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}',
        },
      ).then((value) {
        if (value.statusCode == 200) {
          rows = [];

          setState(() {
            var responseBody = jsonDecode(value.body);
            for (var element in responseBody) {
              var date = DateTime.parse(element["share_date"]);
              var strDate = "${date.day}/${date.month}/${date.year}";
              rows.add(_getContainerRow(
                  title: element["title"],
                  comment: element["comment"],
                  equipment: element["equipment"]["name"],
                  shareDate: strDate,
                  phoneNumber: element["phone_number"]));
            }
          });
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu.");
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
              equipmentTypeButtons
                  .add(_getEquipmentTypeButton(element["name"]));
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
      String? shareDate,
      String? phoneNumber}) {
    IconData newIcon = Icons.queue_sharp;

    if (equipment == "Tekerlekli Sandalye") {
      newIcon = Icons.wheelchair_pickup_outlined;
    } else if (equipment == "Görme Engelli Bastonu") {
      newIcon = Icons.nordic_walking_outlined;
    }

    Icon icon = Icon(newIcon, color: Colors.blue, size: 50);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      height: 90,
      // decoration: const BoxDecoration(
      //     border: Border(bottom: BorderSide(color: Colors.black87))),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        key: UniqueKey(),
        //onTap: _onDetailButtonPressed,
        onTap: () {
          _selectedRow.addAll(
            {
              "title": title ?? "",
              "comment": comment ?? "",
              "equipment": equipment ?? "",
              "shareDate": shareDate ?? "",
              "base64Image": base64Image ?? "",
              "phoneNumber": phoneNumber ?? "",
            },
          );
          _onDetailButtonPressed();
        },
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        trailing: Text(shareDate ?? ""),
        title: Text(title ?? ""),
        leading: icon,
      ),
    );
  }

  _getEquipmentTypeButton(String? equipment) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
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
            selectedEqipment = equipment;
            initState();
          });
        },
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(equipment ?? ""),
          ),
        ),
      ),
    );
  }

  _onNewAdvertButtonPressed() {
    setState(() {
      newEquipmentHelp = _formNewAdvert();
    });
  }

  _onDetailButtonPressed() {
    setState(() {
      detail = _detailScreen();
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
          "phone_number": _phoneController.text,
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}',
        },
      ).then((value) {
        if (value.statusCode == 200) {
          initState();
          BridgeToast.showSuccessToastMessage("Kayıt başarıyla yapıldı.");
        } else {
          BridgeToast.showErrorToastMessage(value.body);
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu, kayıt başarısız.");
    }
  }

  Widget _formNewAdvert() {
    return Container(
      width: 400,
      height: 600,
      decoration: BoxDecoration(
          border: Border.all(color: BridgeColors.secondaryColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white),
      child: Form(
        child: Column(
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
                        borderSide:
                            BorderSide(color: BridgeColors.secondaryColor),
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
                        borderSide:
                            BorderSide(color: BridgeColors.secondaryColor),
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
                              borderSide: BorderSide(
                                  color: BridgeColors.secondaryColor),
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
                          newEquipmentHelp = Container();
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
        ),
      ),
    );
  }

  Widget _detailScreen() {
    IconData newIcon = Icons.queue_sharp;

    if (_selectedRow["equipment"] == "Tekerlekli Sandalye") {
      newIcon = Icons.wheelchair_pickup_outlined;
    } else if (_selectedRow["equipment"] == "Görme Engelli Bastonu") {
      newIcon = Icons.nordic_walking_outlined;
    }

    Icon icon = Icon(newIcon, color: Colors.blue, size: 90);
    return Container(
      width: 400,
      height: 600,
      decoration: BoxDecoration(
          border: Border.all(color: BridgeColors.secondaryColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: 350,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 20),
                  child: icon,
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        "Ekipman:\t\t\t",
                        style: TextStyle(
                          fontSize: 20,
                          color: BridgeColors.secondaryColor,
                        ),
                      ),
                      Text(
                        _selectedRow["equipment"] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        "Başlık:\t\t\t",
                        style: TextStyle(
                          fontSize: 20,
                          color: BridgeColors.secondaryColor,
                        ),
                      ),
                      Text(
                        _selectedRow["title"] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        "Telefon Numarası:\t\t\t",
                        style: TextStyle(
                          fontSize: 20,
                          color: BridgeColors.secondaryColor,
                        ),
                      ),
                      Text(
                        _selectedRow["phoneNumber"] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        "Tarih:\t\t\t",
                        style: TextStyle(
                          fontSize: 20,
                          color: BridgeColors.secondaryColor,
                        ),
                      ),
                      Text(
                        _selectedRow["shareDate"] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Açıklama:\t\t\t\n",
                        style: TextStyle(
                          fontSize: 20,
                          color: BridgeColors.secondaryColor,
                        ),
                      ),
                      Text(
                        _selectedRow["comment"] ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
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
                          detail = Container();
                        });
                      },
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text("KAPAT"),
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
