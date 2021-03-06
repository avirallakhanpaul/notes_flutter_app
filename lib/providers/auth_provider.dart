import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthBaseClass {
  Future<String> getCurrentUser();
}

class AuthProvider with ChangeNotifier implements AuthBaseClass {

  FirebaseAuth firebaseAuth;
  
  AuthProvider({this.firebaseAuth}) {
    _loadFromPrefs();
    print("FirebaseAuth: $firebaseAuth");
  }

  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();

  SharedPreferences _prefs;
  String key = "uId";

  String _userId;
  String get userId => _userId;

  Future<String> getCurrentUser() async {
    // print("uId in Auth: ${firebaseAuth.currentUser.uid}");
    final user = firebaseAuth.currentUser;
    if(user == null) {
      return null;
    } else {
      return user.uid.toString();
    }
  }

  Future<void> _initPrefs() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      return;
    }
  }

  void _loadFromPrefs() async {
    await _initPrefs();
    _userId = _prefs.getString(key) ?? null;
    print("Stored user info: $_userId");
    notifyListeners();
  }

  void _saveUId(String uId) async {
    await _initPrefs();
    _prefs.setString(key, uId);
    print("Id Saved!");
  }

  Future<void> signIn({String email, String password, VoidCallback userSignedIn}) async {

    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((UserCredential userCred) {
        _userId = userCred.user.uid;
        _saveUId(_userId);
        userSignedIn();
        notifyListeners();
      });
    } on FirebaseAuthException catch(error) {
      return error.message;
    }

    notifyListeners();
  }

  Future<void> signUp({@required BuildContext context, VoidCallback verify, @required String email, @required String password}) async {

    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((UserCredential userCred) {

        _userId = userCred.user.uid;
        debugPrint("Signed Up User Id: $_userId");
        debugPrint("Signed Up Firebase User: ${userCred.user}");

        verify();

        // Navigator.pushReplacementNamed(
        //   context,
        //   Verification.routeName,
        // );
      });
    } on FirebaseAuthException catch(error) {
      return error.message;
    }
  }

  Future<void> signOut({VoidCallback userSignedOut}) async {

    await firebaseAuth.signOut();
    await _initPrefs();
    _prefs.setString(key, null);
    print("User Signed Out!");
    userSignedOut();
    notifyListeners();
  }
}