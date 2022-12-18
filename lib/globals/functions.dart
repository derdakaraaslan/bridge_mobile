import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget getProfilePhoto(String base64) {
  Uint8List bytes = base64Decode(base64 ?? "");
  return Image.memory(bytes);
}
