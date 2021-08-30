import 'package:baliza/service_providers/auth.dart';
import 'package:baliza/shared/already_signIn_or_signUp.dart';
import 'package:baliza/shared/divider.dart';
import 'package:baliza/shared/input_fields.dart';
import 'package:baliza/shared/loading.dart';
import 'package:baliza/shared/password_field.dart';
import 'package:baliza/shared/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  //Declaring Variables
  late String name;
  late String emailId;
  late String password;
  late String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    Size size = MediaQuery.of(context).size;

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
                      SizedBox(height: size.height * 0.05),
                      SvgPicture.asset(
                        "assets/signUp/signup.svg",
                        height: size.height * 0.30,
                      ),
                      InputField(
                        valid: (val) {
                          return val!.isEmpty ? "Enter your Name" : null;
                        },
                        changed: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        hintText: "Enter your Name",
                        icon: Icons.person,
                      ),
                      InputField(
                        valid: (val) {
                          return val!.isEmpty ? "Enter an Email" : null;
                        },
                        changed: (val) {
                          setState(() {
                            emailId = val;
                          });
                        },
                        hintText: "Enter your EmailId",
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
                      PasswordField(
                        valid: (val) {
                          return val != password
                              ? "Password does not match!"
                              : null;
                        },
                        changed: (val) {
                          // No requirement
                        },
                        hintText: "Re-Enter the Password",
                        icon: Icons.lock,
                      ),
                      RoundedButton(
                        text: "SIGN UP",
                        pressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await auth.signUp(name, emailId, password);
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
                      SizedBox(height: size.height * 0.01),
                      AlreadySignInOrSignUp(
                        tap: () {
                          Navigator.pushReplacementNamed(context, '/SignIn');
                        },
                        text2: "SIGN IN",
                        text1: "Already have an Account ? ",
                      ),
                      GetDivider(),
                      RoundedButton(
                        color: Colors.red,
                        text: "Google LOGIN",
                        pressed: () async {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await auth.googleLogIn();
                          if (result == null) {
                            setState(() {
                              error = "Error Signing in with google";
                              loading = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
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
