import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {

  FirebaseAuth _firebaseAuth;
  
  AuthProvider(this._firebaseAuth) {
    _loadFromPrefs();
  }

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  SharedPreferences _prefs;
  String key = "uId";

  String _userId;
  String get userId {
    if(_userId == null) {
      print("User id is NULL");
      return null;
    } else {
      return _userId;
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
    notifyListeners();
  }

  void _saveUId(String uId) async {
    await _initPrefs();
    _prefs.setString(key, uId);
  }

  Future<void> signIn({String email, String password}) async {

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((UserCredential userCred) {
        _userId = userCred.user.uid;
        _saveUId(_userId);
        
        notifyListeners();
        print("User: $_userId");
      });

      notifyListeners();
      return true;
    } on FirebaseAuthException catch(error) {
      return error.message;
    }
  }

  Future<void> signUp({String email, String password}) async {

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch(error) {
      return error.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print("User Signed Out!");
  }
}