import 'dart:convert';
import 'dart:io';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

import 'globals/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';
import 'globals/desing.dart';

import 'dart:html';
import 'package:google_maps/google_maps.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class CompanionList extends StatefulWidget {
  const CompanionList({Key? key}) : super(key: key);

  @override
  State<CompanionList> createState() => _CompanionState();
}

class _CompanionState extends State<CompanionList> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  List<Container> rows = [];
  List<Container> equipmentTypeButtons = [];
  Widget newCompanionHelp = Container();
  Widget detail = Container();
  String dropdownValue = 'Diğer';

  List<String> equipmentsTypeList = [];
  Map<String, String> equipmentsTypeMap = {};
  String? selectedEqipment;
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedRowId;

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
                      children: [],
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
          detail,
        ],
      ),
    );
  }

  _getRows({Map? filter}) {
    final url = "${globalUrl}companion_request/search";
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
              var date = DateTime.parse(element["date"]);
              var strDate =
                  "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
              rows.add(_getContainerRow(
                startLatitude: element["start_latitude"],
                startLongitude: element["start_longitude"],
                comment: element["comment"],
                finishLatitude: element["finish_latitude"],
                finishLongitude: element["finish_longitude"],
                ownerAvatarId: element["owner"]["avatar_id"],
                date: strDate,
                title: element["title"],
              ));
            }
          });
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu.");
    }
  }

  Container _getContainerRow(
      {String? startLatitude,
      String? startLongitude,
      String? comment,
      String? finishLatitude,
      String? finishLongitude,
      String? date,
      String? ownerAvatarId,
      String? title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        key: UniqueKey(),
        onTap: () {
          _selectedRow.addAll(
            {
              "title": title ?? "",
              "comment": comment ?? "",
              "date": date ?? "",
              "start_latitude": startLatitude ?? "",
              "start_longitude": startLongitude ?? "",
              "finish_latitude": finishLatitude ?? "",
              "finish_longitude": finishLongitude ?? "",
              "owner_avatar_id": ownerAvatarId ?? "",
            },
          );
          _onDetailButtonPressed();
        },
        titleTextStyle: const TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
        trailing: Text(date ?? ""),
        title: Text(title ?? ""),
        leading: Image.asset(
          _storageService.getAvatarAsset(newAvatarId: ownerAvatarId),
          width: 100,
        ),
      ),
    );
  }

  _onDetailButtonPressed() {
    setState(() {
      detail = _detailScreen();
    });
  }

  Widget _detailScreen() {
    return Container(
      width: 400,
      height: 600,
      decoration: BoxDecoration(
          border: Border.all(color: BridgeColors.secondaryColor),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 150,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(bottom: 20),
              child: Image.asset(
                _storageService.getAvatarAsset(
                    newAvatarId: _selectedRow["avatar_id"]),
              ),
            ),
            Container(
              width: 350,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Text(
                    "Güzergah:\t\t\t",
                    style: TextStyle(
                      fontSize: 20,
                      color: BridgeColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 350,
              width: 350,
              child: Center(
                child: _getMap(
                  double.parse(_selectedRow["start_latitude"] ?? ""),
                  double.parse(_selectedRow["start_longitude"] ?? ""),
                  double.parse(_selectedRow["finish_latitude"] ?? ""),
                  double.parse(_selectedRow["finish_longitude"] ?? ""),
                ),
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
                    "Tarih:\t\t\t",
                    style: TextStyle(
                      fontSize: 20,
                      color: BridgeColors.secondaryColor,
                    ),
                  ),
                  Text(
                    _selectedRow["date"] ?? "",
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

  Widget getMap(double lat, double lng) {
    return Center(
      child: FlutterLocationPicker(
          initPosition: LatLong(lat, lng),
          showSearchBar: false,
          showSelectLocationButton: false,
          showLocationController: false,
          initZoom: 11,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          trackMyPosition: true,
          searchBarBackgroundColor: Colors.white,
          mapLanguage: 'ar',
          onError: (e) => print(e),
          onPicked: (pickedData) {}),
    );
  }

  Widget _getMap(
    double startLat,
    double startLng,
    double finishLat,
    double finishLng,
  ) {
    String htmlId = "2";

    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final fromLatlng = LatLng(startLat, startLng);
      final toLatlng2 = LatLng(finishLat, finishLng);

      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = LatLng(startLat, startLng);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      Marker(MarkerOptions()
        ..label = "Başlangıç"
        ..position = fromLatlng
        ..map = map
        ..title = 'nereden');
      Marker(MarkerOptions()
        ..label = "Bitiş"
        ..position = toLatlng2
        ..map = map
        ..title = 'nereye');

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  pickData(double latitude, double longitude) async {
    LatLong center = LatLong(latitude, longitude);
    var client = http.Client();
    String url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1&accept-language=tr';

    var response = await client.post(Uri.parse(url));
    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<dynamic, dynamic>;
    String displayName = decodedResponse['display_name'];
    return PickedData(center, displayName, decodedResponse['address']);
  }
}
