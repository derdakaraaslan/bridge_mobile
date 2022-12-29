import 'package:bridge_mobile/globals/desing.dart';
import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'globals/constants.dart';
import 'dart:convert';
import 'dart:io';

class Companion extends StatefulWidget {
  const Companion({Key? key}) : super(key: key);

  @override
  State<Companion> createState() => _CompanionState();
}

class _CompanionState extends State<Companion> {
  final _storageService = GetIt.I.get<SimpleStorage>();
  late DateTime _selectedDate;
  final _dateController = TextEditingController();
  final TextEditingController _commetController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  double? _startLat;
  double? _startLng;

  double? _finishLat;
  double? _finishLng;
  final _format = DateFormat("dd-MM-yyyy HH:mm");

  var lat = 39.925533;
  var lng = 32.866287;
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
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 340),
                        child: DateTimeField(
                          format: _format,
                          controller: _dateController,
                          decoration:
                              InputDecoration(hintText: "Tarih Saat Seçiniz"),
                          onShowPicker: _onShowDateTimePicker,
                          validator: (value) {
                            if (value == null) {
                              return 'Lütfen bir tarih seçiniz';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: (MediaQuery.of(context).size.width >= 1200)
                            ? MediaQuery.of(context).size.width - 300
                            : MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (MediaQuery.of(context).size.width >= 900)
                                ? Row(
                                    children: _getMaps(),
                                  )
                                : Column(
                                    children: _getMaps(),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width >= 900)
                            ? 800
                            : 350,
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Başlık',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width >= 900)
                            ? 800
                            : 350,
                        child: TextField(
                          minLines: 6,
                          maxLines: 8,
                          controller: _commetController,
                          decoration: const InputDecoration(
                            labelText: 'Açıklama',
                            border: OutlineInputBorder(),
                          ),
                        ),
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
      http.post(
        Uri.parse(url),
        body: jsonEncode(<String, Object>{
          "owner": {"id": _storageService.id},
          "date": _format.parse(_dateController.text).toString(),
          "start_latitude": _startLat.toString(),
          "start_longitude": _startLng.toString(),
          "finish_latitude": _finishLat.toString(),
          "finish_longitude": _finishLng.toString(),
          "comment": _commetController.text,
          "title": _titleController.text,
        }),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${_storageService.apiToken}',
        },
      ).then((value) {
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

  List<Widget> _getMaps() {
    return [
      Container(
        height: 350,
        width: 350,
        child: Center(
          child: FlutterLocationPicker(
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              trackMyPosition: true,
              searchBarHintText: 'Nereden',
              selectLocationButtonText: 'Başlangıç Noktası Seç',
              searchBarBackgroundColor: Colors.white,
              mapLanguage: 'tr',
              onError: (e) => print(e),
              onPicked: (pickedData) {
                _startLat = pickedData.latLong.latitude;
                _startLng = pickedData.latLong.longitude;
              }),
        ),
      ),
      (MediaQuery.of(context).size.width >= 900)
          ? Icon(Icons.arrow_right_alt_sharp, size: 100)
          : Icon(Icons.arrow_downward_sharp, size: 100),
      Container(
        height: 350,
        width: 350,
        child: Center(
          child: FlutterLocationPicker(
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              trackMyPosition: true,
              searchBarBackgroundColor: Colors.white,
              searchBarHintText: 'Nereye',
              selectLocationButtonText: 'Bitiş Noktası Seç',
              mapLanguage: 'tr',
              onError: (e) => print(e),
              onPicked: (pickedData) {
                _finishLat = pickedData.latLong.latitude;
                _finishLng = pickedData.latLong.longitude;
              }),
        ),
      ),
    ];
  }

  Future<DateTime?> _onShowDateTimePicker(
    BuildContext context,
    DateTime? _,
  ) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 90)));
    if (date == null) {
      return null;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    return DateTimeField.combine(date, time);
  }
}
