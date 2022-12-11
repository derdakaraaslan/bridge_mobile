import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

final values = [
  "../assets/images/slideimage1.png",
  "../assets/images/slideimage2.png",
  "../assets/images/slideimage3.png",
  "../assets/images/slideimage4.png"
];
int _index = 0;

class _LoginState extends State<Login> {
  late final Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() => _index++);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
//sorun yok
//sorun yok
//sorun yok
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Container(
        alignment: Alignment.center,
        child:
            //Menu(),
            // MediaQuery.of(context).size.width >= 980
            //     ? Menu()
            //     : SizedBox(), // Responsive
            Body(),
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

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (MediaQuery.of(context).size.width >= 1200) ...[
                SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: Image.asset(
                          values[_index %
                              values
                                  .length], // manually change the text here, and hot reload
                          key: UniqueKey(),
                        ),
                      ),
                      const Text(
                        'Hoşgeldin Gardaş',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 200,
                ),
              ],
              // MediaQuery.of(context).size.width >= 1300 //Responsive
              //     ? Image.asset(
              //         'images/illustration-1.png',
              //         width: 300,
              //       )
              //     : SizedBox(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 150),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 320,
                  child: _formLogin(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _formLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter email or Phone number',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple[400]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          decoration: InputDecoration(
            hintText: 'Password',
            counterText: 'Forgot password?',
            suffixIcon: const Icon(
              Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple[400]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple[100]!,
                spreadRadius: 10,
                blurRadius: 20,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => print("it's pressed"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(child: Text("Giriş Yap"))),
          ),
        ),
        const SizedBox(height: 40),
        TextButton(
          onPressed: _onSignUpButtpnPressed,
          child: const Text("Hesabın yok mu? Hemen Kaydol",
              style: TextStyle(color: Colors.deepPurple)),
        ),
      ],
    );
  }

  _onSignUpButtpnPressed() {}
  Widget _loginWithButton({String? image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[400]!),
            ),
      child: Center(
          child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400]!,
                    spreadRadius: 2,
                    blurRadius: 15,
                  )
                ],
              )
            : const BoxDecoration(),
        child: Image.asset(
          '$image',
          width: 35,
        ),
      )),
    );
  }
}
