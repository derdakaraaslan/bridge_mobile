import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sidebarx/sidebarx.dart';
import 'globals/storage.dart' as storage;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            child: ListView(
              children: <Widget>[
                ListTile(title: Text("Menu A")),
                ListTile(title: Text("Menu B")),
                ListTile(title: Text("Menu C")),
                ListTile(title: Text("Menu D")),
                ListTile(title: Text("Menu E")),
                ListTile(title: Text("Menu F")),
                ListTile(title: Text("Menu G")),
                ListTile(title: Text("Menu H")),
                ListTile(title: Text("Menu I")),
                ListTile(title: Text("Menu J")),
                ListTile(title: Text("Menu K")),
                ListTile(title: Text("Menu L")),
                ListTile(title: Text("Menu M")),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Center(child: Text('Content')),
              color: Colors.black26,
            ),
          ),
          // Your app screen body
        ],
      ),
    );
  }

  _onHomeButtonPressed() async {
    final url = "http://localhost:8000/appusers";
    try {
      Fluttertoast.showToast(
          msg: "This is Center Short Toast",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{
          'first_name': _nameController.text,
          'last_name': _surnameController.text,
          'email': _mailController.text,
          'is_disabled': _isDisabled.toString(),
          'password': _passwordController.text,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  _onLogInButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
