import 'package:bridge_mobile/globals/desing.dart';
import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:intl/intl.dart';

class Companion extends StatefulWidget {
  const Companion({Key? key}) : super(key: key);

  @override
  State<Companion> createState() => _CompanionState();
}

class _CompanionState extends State<Companion> {
  late DateTime _selectedDate;
  final _dateController = TextEditingController();

  var lat = 39.925533;
  var lng = 32.866287;
  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    TextEditingController editingController2 = TextEditingController();
    TextEditingController editingController3 = TextEditingController();
    var text;
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
              padding: (MediaQuery.of(context).size.width >= 900)
                  ? const EdgeInsets.all(50.0)
                  : const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
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
                              mapLanguage: 'tr',
                              onError: (e) => print(e),
                              onPicked: (pickedData) {
                                print(pickedData.latLong.latitude);
                                print(pickedData.latLong.longitude);
                                print(pickedData.address);
                                print(pickedData.addressData['country']);
                              }),
                        ),
                      ),
                      Icon(Icons.arrow_right_alt_sharp, size: 100),
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
                              mapLanguage: 'tr',
                              onError: (e) => print(e),
                              onPicked: (pickedData) {
                                print(pickedData.latLong.latitude);
                                print(pickedData.latLong.longitude);
                                print(pickedData.address);
                                print(pickedData.addressData['country']);
                              }),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: DateTimeField(
                        format: DateFormat("yyyy-MM-dd"),
                        controller: _dateController,
                        decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: BridgeColors.primaryColor,
                            size: 24,
                          ),
                          hintText: "Tarih Seçiniz",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onShowPicker: _onDatePickerShown,
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

  Future<DateTime?> _onDatePickerShown(
    BuildContext context,
    DateTime? currentValue,
  ) {
    return showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: currentValue ?? DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)));
  }

  Widget getMap() {
    String address;
    var lat = 39.925533;
    var lng = 32.866286;
    return Center(
      child: FlutterLocationPicker(
          initZoom: 11,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          trackMyPosition: true,
          searchBarBackgroundColor: Colors.white,
          mapLanguage: 'ar',
          onError: (e) => print(e),
          onPicked: (pickedData) {
            lat = pickedData.latLong.latitude;
            lng = pickedData.latLong.longitude;
            address = pickedData.address;
          }),
    );
  }
}
