library my_prj.storage;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: unused_element

class SimpleStorage {
  late SharedPreferences _prefs;

  String? get id {
    return _stringGetter("id");
  }

  set id(String? id) {
    _stringSetter("id", id);
  }

  static Future<SimpleStorage> create() async {
    SimpleStorage storage = SimpleStorage();
    storage._prefs = await SharedPreferences.getInstance();

    return storage;
  }

  String? _stringGetter(String key) {
    var value = _prefs.getString(key);

    return value == null || value.isEmpty ? null : value;
  }

  void _stringSetter(String key, String? value) {
    if (value == null) {
      _prefs.remove(key);
    } else {
      _prefs.setString(key, value);
    }
  }

  bool? _boolGetter(String key) {
    return _prefs.getBool(key);
  }

  void _boolSetter(String key, bool? value) {
    if (value == null) {
      _prefs.remove(key);
    } else {
      _prefs.setBool(key, value);
    }
  }
}

String? id;
String? firstName;
String? lastName;
String? email;
String? base64ProfilePhoto;
bool? isDisabled;
String? base64;

Image getProfilePhoto({double? width}) {
  var base_64 = base64;
  if (base_64 == null) {
    return Image.asset("../../assets/images/defaultProfilePhoto.jpg",
        width: width);
  }

  Uint8List bytes = base64Decode(base_64);

  return Image.memory(bytes, width: width);
}

setUser(String id2, String firstName2, String lastName2, String email2,
    /*String base64ProfilePhoto,*/ bool isDisabled2) {
  id = id2;
  firstName = firstName2;
  lastName = lastName2;
  email = email2;
  //simple.base64ProfilePhoto = base64ProfilePhoto;
  isDisabled = isDisabled2;
}
