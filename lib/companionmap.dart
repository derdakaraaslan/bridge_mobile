import 'package:bridge_mobile/globals/desing.dart';
import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';

import 'dart:html';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'globals/constants.dart';
import 'dart:convert';

class Companion extends StatefulWidget {
  const Companion({Key? key}) : super(key: key);

  @override
  State<Companion> createState() => _CompanionState();
}

class _CompanionState extends State<Companion> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  final TextEditingController _commetController = TextEditingController();
  double? _startLat;
  double? _startLng;

  double? _finishLat;
  double? _finishLng;

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
              child: SingleChildScrollView(
                child: Container(
                  padding: (MediaQuery.of(context).size.width >= 900)
                      ? const EdgeInsets.all(50.0)
                      : const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 800,
                        height: 350,
                        child: _getMap(),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: _onCreateRequestButtonPressed,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: BridgeColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(child: Text("Talep Oluştur"))),
                        ),
                      ),
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

  _onCreateRequestButtonPressed() {
    var url = "${globalUrl}companion_request/create";
    try {
      http
          .post(
        Uri.parse(url),
        body: jsonEncode(<String, Object>{
          "owner": {"id": _storageService.id},
          "start_latitude": _startLat.toString(),
          "start_longitude": _startLng.toString(),
          "finish_latitude": _finishLat.toString(),
          "finish_longitude": _finishLng.toString(),
          "comment": _commetController.text,
        }),
      )
          .then((value) {
        if (value.statusCode == 200) {
          BridgeToast.showSuccessToastMessage("Kayıt başarıyla yapıldı.");
        } else {
          BridgeToast.showErrorToastMessage(value.body);
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu, kayıt başarısız.");
    }
  }

  Widget _getMap() {
    var lat = 39.925533;
    var lng = 32.866287;
    String htmlId = "2";

    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(lat, lng);
      final myLatlng2 = LatLng(39.825533, 32.866287);

      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = LatLng(lat, lng);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      Marker(MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = 'nereden');
      Marker(MarkerOptions()
        ..position = myLatlng2
        ..map = map
        ..title = 'nereye');

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
