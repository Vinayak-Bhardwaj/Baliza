import 'package:baliza/service_providers/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService extends ChangeNotifier {  


  //Instances 
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  
  //variables
  User? _user;
  
  bool _currentUser() {
    return (_auth.currentUser != null) ? true : false;
  }


  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanges);
  } 
   
   
  //Getter Function
  bool get isAuthenticated => _currentUser();
  User? get user => _user;


  //Setter Functions
  void _onAuthStateChanges(User? user) async{
    _user = user;
    notifyListeners();
  }

  
  //Functions

  //SignIn Authentication
  Future signIn(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //SignUp Authentication
  Future signUp(String name, String emailId, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: emailId, password: password);
      await DatabaseService(uid: user!.uid).updateUserData(name, emailId, '0');
      //We have to make database of user
      return result;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //Google SignIn
  Future googleLogIn() async{
    try{
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      return result;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  //Google SignOut
  Future signOutGoogle() async {
    try{
      return await _googleSignIn.signOut();
    } catch(e) {
      print(e.toString());
    }
  }


  //SignOut
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
    }
  }


}