import 'package:baliza/screens/Authentication/SignIn/signIn.dart';
import 'package:baliza/screens/Authentication/SignUp/signUp.dart';
import 'package:baliza/screens/Home/home.dart';
import 'package:baliza/screens/Home/note_editor.dart';
import 'package:baliza/screens/wrapper.dart';
import 'package:baliza/service_providers/auth.dart';
import 'package:baliza/service_providers/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthService auth = AuthService();
  return runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AuthService()),
      ChangeNotifierProvider(create: (context) => DatabaseService(uid: auth.user!.uid)),
    ],
    child: MyApp()),
  );
}

  class MyApp extends StatelessWidget {
    
    @override
    Widget build(BuildContext context) {
      final auth = Provider.of<AuthService>(context);
      return MaterialApp(
        title: "Bazila",
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/SignUp' : (context) => auth.isAuthenticated ? Home() : SignUp(),
          '/SignIn' : (context) => auth.isAuthenticated ? Home() : SignIn(),
          '/NoteEditor' : (context) => NoteEditor(),
          '/Home' : (context) => auth.isAuthenticated ? Home() : SignIn(),
        },
        debugShowCheckedModeBanner: false,
      );
    }
  }
