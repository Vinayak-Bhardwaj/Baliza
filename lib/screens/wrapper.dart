import 'package:baliza/screens/Authentication/SignIn/signIn.dart';
import 'package:baliza/screens/Home/home.dart';
import 'package:baliza/service_providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return (auth.isAuthenticated) ? Home() : SignIn();
  }
}