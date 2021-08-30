import 'package:baliza/service_providers/auth.dart';
import 'package:baliza/shared/already_signIn_or_signUp.dart';
import 'package:baliza/shared/input_fields.dart';
import 'package:baliza/shared/loading.dart';
import 'package:baliza/shared/password_field.dart';
import 'package:baliza/shared/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  //Declaring Variables
  late String emailId;
  late String password;
  late String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final auth = Provider.of<AuthService>(context);
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              width: double.infinity,
              height: size.height,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.085),
                      Text("Baliza",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Billabong',
                              fontSize: size.height * 0.085)),
                      SizedBox(height: size.height * 0.0365),
                      SvgPicture.asset(
                        "assets/signIn/login.svg",
                        height: size.height * 0.35,
                      ),
                      SizedBox(height: size.height * 0.03),
                      InputField(
                        valid: (val) {
                          return val!.isEmpty ? 'Enter an Email' : null;
                        },
                        changed: (val) {
                          setState(() {
                            emailId = val;
                          });
                        },
                        hintText: "Enter Your Email Id",
                        icon: Icons.email,
                      ),
                      PasswordField(
                        valid: (val) {
                          return val!.length < 6
                              ? 'Enter a Password 6+ chars long'
                              : null;
                        },
                        changed: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        hintText: "Enter the Password",
                        icon: Icons.lock,
                      ),
                      RoundedButton(
                        text: "LOGIN",
                        pressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await auth.signIn(emailId, password);
                            if (result == null) {
                              setState(() {
                                error =
                                    "Please Supply a valid EmailId and Password";
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                      AlreadySignInOrSignUp(
                        text2: "SIGN UP",
                        text1: "Don't have an account ?",
                        tap: () {
                          Navigator.pushReplacementNamed(context, '/SignUp');
                        },
                      ),
                      SizedBox(height: size.height * 0.00609),
                      Text(
                        error,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
