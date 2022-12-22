import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget geteEquipmentPhoto(String? base64, {double? width}) {
  if (base64 == null) {
    return Image.asset("../../assets/images/noImage.png",
        fit: BoxFit.cover, width: width);
  }
  Uint8List bytes = base64Decode(base64);
  return Image.memory(bytes, width: width ?? 80);
}
