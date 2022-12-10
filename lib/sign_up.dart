import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Kayıt Ol',
                      ),
                      const SizedBox(height: 15),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: "Adın",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _surnameController,
                              decoration: InputDecoration(
                                labelText: "Soyadın",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _mailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Şifre",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isDisabled,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isDisabled = !_isDisabled;
                                    });
                                  },
                                ),
                                const Text(
                                    "Herhangi bir engeliniz varsa işaretleyin."),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onSignUpButtonPressed,
                          child: Text("Kaydol"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        child: Text("Zetan bir hesabın mı var? Giriş Yap"),
                        onPressed: _onLogInButtonPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onSignUpButtonPressed() async {
    final url = "http://localhost:8000/appusers";
    try {
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
