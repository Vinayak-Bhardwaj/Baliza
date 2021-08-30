import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService extends ChangeNotifier {
  final String? uid;
  Map userInfo = {};
  List userNotes = [];
  Map userNotesMap = {};
  int NumberOfNotes = 0;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('userData');

  Future updateUserData(
      String name, String emailId, String numberOfNotes) async {
    await userCollection.doc(uid).set({
      'name': name,
      'emailId': emailId,
      'numberOfNotes': numberOfNotes,
    });
    notifyListeners();
  }

  Future<void> updateNotes(String uid, String? heading, String? content, String index) async {
    try {
      await userCollection.doc(uid).collection('notes').doc(index).set({
        'heading': heading,
        'content': content,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteNotes(String index) async {
    try {
      await userCollection.doc(uid).collection('notes').doc(index).delete();
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getNumberOfNotes(String uid) async {
    QuerySnapshot doc = await userCollection.doc(uid).collection('notes').get();
    NumberOfNotes = doc.docs.length;
  }

  
  Future<void> getData(String uid) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      userInfo = doc.data() as Map;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getUserNotes(String uid) async {
    try {
      userNotes.clear();
      QuerySnapshot doc =
          await userCollection.doc(uid).collection('notes').get();
      doc.docs.forEach((doc) {
        userNotes.add(doc.data());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
