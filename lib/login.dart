import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'globals/desing.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'globals/simple_storage.dart';
import 'routes.dart';
import 'globals/constants.dart';

enum FormType {
  signIn,
  signUp,
  forgotPassword,
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final Timer timer;
  final _storageService = GetIt.I.get<SimpleStorage>();

  final values = [
    "../assets/images/slideimage1.png",
    "../assets/images/slideimage2.png",
    "../assets/images/slideimage3.png",
    "../assets/images/slideimage4.png"
  ];

  int _index = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _mailControllerSignUp = TextEditingController();
  final _passwordControllerSignUp = TextEditingController();
  final _passwordControllerSignIn = TextEditingController();
  final _mailControllerSignIn = TextEditingController();
  final _mailControllerForgotPassword = TextEditingController();
  bool _isDisabled = false;
  bool _passwordVisible = false;
  FormType _enumValue = FormType.signIn;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() => _index++);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (MediaQuery.of(context).size.width >= 1200) ...[
                  SizedBox(
                    width: 360,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Hoş geldiniz!',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Image.asset(
                            values[_index %
                                values
                                    .length], // manually change the text here, and hot reload
                            key: UniqueKey(),
                          ),
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
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                  decoration: BoxDecoration(
                    border: Border.all(color: BridgeColors.secondaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: 300,
                    child: (_enumValue == FormType.signIn)
                        ? _formSignIn()
                        : (_enumValue == FormType.signUp)
                            ? _formSignUp()
                            : (_enumValue == FormType.forgotPassword)
                                ? _formForgotPassword()
                                : null,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _formSignIn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              'Bridge',
              style: TextStyle(
                fontSize: 40,
                color: BridgeColors.secondaryColor,
              ),
            ),
          ),
        ),
        TextField(
          controller: _mailControllerSignIn,
          decoration: InputDecoration(
            hintText: 'E-mail',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          obscureText: !_passwordVisible,
          controller: _passwordControllerSignIn,
          decoration: InputDecoration(
            hintText: 'Şifre',
            suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: BridgeColors.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                }),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: _onSignInButtonPressed,
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
                child: Center(child: Text("Giriş Yap"))),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            _changeFormType(FormType.forgotPassword);
          },
          child: Text("Şifremi unuttum",
              style: TextStyle(color: BridgeColors.primaryColor)),
        ),
        const SizedBox(height: 5),
        TextButton(
          onPressed: () {
            _changeFormType(FormType.signUp);
          },
          child: Text("Hesabın yok mu? Hemen kaydol",
              style: TextStyle(color: BridgeColors.primaryColor)),
        ),
      ],
    );
  }

  Widget _formForgotPassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              'Bridge',
              style: TextStyle(
                fontSize: 40,
                color: BridgeColors.secondaryColor,
              ),
            ),
          ),
        ),
        TextField(
          controller: _mailControllerForgotPassword,
          decoration: InputDecoration(
            hintText: 'E-mail',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: _onForgotPasswordButtonPressed,
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
                child: Center(child: Text("Onayla"))),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            _changeFormType(FormType.signIn);
          },
          child: Text("Giriş yapmak için tıklayınız",
              style: TextStyle(color: BridgeColors.primaryColor)),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _formSignUp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              'Bridge',
              style: TextStyle(
                fontSize: 40,
                color: BridgeColors.secondaryColor,
              ),
            ),
          ),
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'İsim',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _surnameController,
          decoration: InputDecoration(
            hintText: 'Soy isim',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _mailControllerSignUp,
          decoration: InputDecoration(
            hintText: 'E-mail',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          obscureText: !_passwordVisible,
          controller: _passwordControllerSignUp,
          decoration: InputDecoration(
            hintText: 'Şifre',
            suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: BridgeColors.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                }),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: const TextStyle(fontSize: 12),
            contentPadding: const EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: BridgeColors.secondaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              shape: const CircleBorder(),
              checkColor: Colors.white,
              activeColor: BridgeColors.primaryColor,
              value: _isDisabled,
              onChanged: (bool? value) {
                setState(() {
                  _isDisabled = value!;
                });
              },
            ),
            const Text("Engelli bir bireyim."),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: _onSignUpButtonPressed,
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
                child: Center(child: Text("Kayıt Ol"))),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            _changeFormType(FormType.signIn);
          },
          child: Text("Hesabın var mı? Giriş yap.",
              style: TextStyle(color: BridgeColors.primaryColor)),
        ),
      ],
    );
  }

  _changeFormType(FormType newType) {
    setState(() {
      _enumValue = newType;
    });
  }

  _onSignInButtonPressed() {
    var url = "${globalUrl}login/app_user";
    try {
      http
          .post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{
          'email': _mailControllerSignIn.text,
          'password': _passwordControllerSignIn.text,
        }),
      )
          .then((value) async {
        if (value.statusCode == 200) {
          var responseBody = jsonDecode(value.body);

          _storageService.id = responseBody["id"];
          _storageService.profilePhoto = responseBody["profile_photo"];
          _storageService.firstName = responseBody["first_name"];
          _storageService.lastName = responseBody["last_name"];
          _storageService.email = responseBody["email"];
          _storageService.isDisabled = responseBody["is_disabled"];
          BridgeToast.showSuccessToastMessage("Giriş başarılı");
          context.go(Routes.home);
        } else {
          BridgeToast.showErrorToastMessage("Hatalı şifre ya da mail adresi.");
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu, kayıt başarısız.");
    }
  }

  _onForgotPasswordButtonPressed() {
    var url = "${globalUrl}login/app_user/forgot_password";
    try {
      http
          .post(Uri.parse(url),
              body: jsonEncode(<String, String>{
                'email': _mailControllerForgotPassword.text,
              }))
          .then((value) {
        if (value.statusCode == 200) {
          BridgeToast.showSuccessToastMessage(
              "Yeni şifreniz mail adresinize gönderildi");
        } else {
          BridgeToast.showErrorToastMessage("Şifre sıfırlama işlemi başarısız");
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu");
    }
  }

  _onSignUpButtonPressed() async {
    var url = "${globalUrl}app_users";
    try {
      http
          .post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{
          'first_name': _nameController.text,
          'last_name': _surnameController.text,
          'email': _mailControllerSignUp.text,
          'is_disabled': _isDisabled.toString(),
          'password': _passwordControllerSignUp.text,
        }),
      )
          .then((value) {
        if (value.statusCode == 200) {
          BridgeToast.showSuccessToastMessage("Kayıt başarıyla yapıldı.");
          setState(() {
            _nameController.text = "";
            _surnameController.text = "";
            _mailControllerSignUp.text = "";
            _isDisabled = false;
            _passwordControllerSignUp.text = "";
            _changeFormType(FormType.signIn);
          });
        } else if (value.statusCode == 400) {
          BridgeToast.showWarningToastMessage("Bu mail adresi zaten kayıtlı.");
        } else {
          BridgeToast.showErrorToastMessage(value.body);
        }
      });
    } catch (e) {
      BridgeToast.showErrorToastMessage("Bir hata oluştu, kayıt başarısız.");
    }
  }
}
