// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';

class SimpleStorage {
  late SharedPreferences _prefs;

  String? get id {
    return _stringGetter("id");
  }

  set id(String? id) {
    _stringSetter("id", id);
  }

  String? get profilePhoto {
    return _stringGetter("profilePhoto");
  }

  set profilePhoto(String? profilePhoto) {
    _stringSetter("profilePhoto", profilePhoto);
  }

  String? get firstName {
    return _stringGetter("firstName");
  }

  set firstName(String? firstName) {
    _stringSetter("firstName", firstName);
  }

  String? get lastName {
    return _stringGetter("lastName");
  }

  set lastName(String? lastName) {
    _stringSetter("lastName", lastName);
  }

  String? get email {
    return _stringGetter("email");
  }

  set email(String? email) {
    _stringSetter("email", email);
  }

  bool? get isDisabled {
    return _boolGetter("isDisabled");
  }

  set isDisabled(bool? isDisabled) {
    _boolSetter("isDisabled", isDisabled);
  }

  String? get avatarId {
    return _stringGetter("avatar_id");
  }

  set avatarId(String? avatarId) {
    _stringSetter("avatar_id", avatarId);
  }

  String? get apiToken {
    return _stringGetter("api_token");
  }

  set apiToken(String? apiToken) {
    _stringSetter("api_token", apiToken);
  }

  final _avatars = [
    "../assets/images/avatar1.png",
    "../assets/images/avatar2.png",
    "../assets/images/avatar3.png",
    "../assets/images/avatar4.png",
    "../assets/images/avatar5.png"
  ];

  String getAvatarAsset({String? newAvatarId}) {
    return _avatars[int.parse(newAvatarId ?? avatarId!) - 1];
  }

  clearDatas() {
    id = null;
    profilePhoto = null;
    firstName = null;
    lastName = null;
    email = null;
    isDisabled = null;
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
