// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bridge_mobile/globals/desing.dart';
import 'package:flutter/material.dart';
import 'globals/simple_storage.dart';
import './drawer/custom_drawer.dart';
import 'widgets/appbar.dart';
import 'package:get_it/get_it.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Companion extends StatefulWidget {
  const Companion({Key? key}) : super(key: key);

  @override
  State<Companion> createState() => _CompanionState();
}

var lat = 39.925533;
var lng = 32.866287;
final myLatlng = LatLng(lat, lng);

class _CompanionState extends State<Companion> {
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: myLatlng,
    zoom: 14.4746,
  );
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
                        child: GoogleMap(
                          mapType: MapType.hybrid,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
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
    // var url = "${globalUrl}companion_request/create";
    // try {
    //   http
    //       .post(
    //     Uri.parse(url),
    //     body: jsonEncode(<String, Object>{
    //       "owner": {"id": _storageService.id},
    //       "start_latitude": _startLat.toString(),
    //       "start_longitude": _startLng.toString(),
    //       "finish_latitude": _finishLat.toString(),
    //       "finish_longitude": _finishLng.toString(),
    //       "comment": _commetController.text,
    //     }),
    //   )
    //       .then((value) {
    //     if (value.statusCode == 200) {
    //       BridgeToast.showSuccessToastMessage("Kayıt başarıyla yapıldı.");
    //     } else {
    //       BridgeToast.showErrorToastMessage(value.body);
    //     }
    //   });
    // } catch (e) {
    //   BridgeToast.showErrorToastMessage("Bir hata oluştu, kayıt başarısız.");
    // }
  }
}
