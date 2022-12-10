import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (MediaQuery.of(context).size.width > 1200)
              Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    border: Border.all(color: Colors.grey)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 35),
                        child: const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Iaculis urna id volutpat lacus laoreet non curabitur. Sit amet cursus sit amet. Sed blandit libero volutpat sed cras ornare arcu dui vivamus. Id consectetur purus ut faucibus pulvinar elementum integer enim neque. Aliquet eget sit amet tellus cras adipiscing enim eu turpis. Massa tincidunt nunc pulvinar sapien et ligula ullamcorper. Urna id volutpat lacus laoreet non curabitur gravida arcu. Et molestie ac feugiat sed lectus vestibulum mattis. Sapien nec sagittis aliquam malesuada bibendum arcu vitae. Ipsum faucibus vitae aliquet nec ullamcorper sit amet risus. Phasellus egestas tellus rutrum tellus pellentesque eu tincidunt tortor aliquam. Donec pretium vulputate sapien nec sagittis aliquam malesuada bibendum arcu. Consequat mauris nunc congue nisi vitae suscipit tellus. Feugiat nisl pretium fusce id velit. Felis donec et odio pellentesque diam volutpat commodo sed. Et magnis dis parturient montes nascetur ridiculus mus mauris vitae. Id neque aliquam vestibulum morbi blandit cursus. Nisi lacus sed viverra tellus in. Sollicitudin ac orci phasellus egestas tellus rutrum tellus pellentesque eu.")),
                  ],
                ),
              ),
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
                        'Giriş Yap',
                      ),
                      const SizedBox(height: 15),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _mailController,
                              decoration: InputDecoration(
                                labelText: "Şifre",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              onFieldSubmitted: (_) => _onLoginButtonPressed(),
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _onLoginButtonPressed,
                          child: Text("GİRİŞ YAP"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        child: Text("Kaydol"),
                        onPressed: _onSignUpPressed,
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

  _onSignUpPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  _onLoginButtonPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
  }
}
