import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import 'package:notes_app/screens/email_verification/verification.dart';
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
  String get userId => _userId;

  // bool _isLoggedIn = false;
  // bool get isLoggedIn => _isLoggedIn;

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
    if(_userId != null) {
      // _isLoggedIn = true;
    }
    print("Stored user info: $_userId");
    notifyListeners();
  }

  void _saveUId(String uId) async {
    await _initPrefs();
    _prefs.setString(key, uId);
    print("Id Saved!");
  }

  Future<void> signIn({String email, String password}) async {

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((UserCredential userCred) {
        _userId = userCred.user.uid;
        _saveUId(_userId);
        // _isLoggedIn = true;

        notifyListeners();
      });
    } on FirebaseAuthException catch(error) {
      return error.message;
    }

    notifyListeners();
  }

  Future<void> signUp({@required BuildContext context, @required String email, @required String password}) async {

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((UserCredential userCred) {

        _userId = userCred.user.uid;
        debugPrint("Signed Up User Id: $_userId");
        debugPrint("Signed Up Firebase User: ${userCred.user}");

        Navigator.pushReplacementNamed(
          context,
          Verification.routeName,
        );
      });
    } on FirebaseAuthException catch(error) {
      return error.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();

    notifyListeners();

    await _initPrefs();
    _prefs.setString(key, null);

    // _isLoggedIn = false;
    print("User Signed Out!");
  }
}