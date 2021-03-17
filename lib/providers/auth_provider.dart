import 'dart:async';

import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:notes_app/helpers/authException.dart';
import 'package:notes_app/helpers/networkException.dart';
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
  String mailKey = "mailId";

  final emailRegEx = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String _userId;
  String get userId => _userId;
  String _userMailId;
  String get userMailId => _userMailId;

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
    _userId = _prefs.getString(key) ?? "";
    _userMailId = _prefs.getString(mailKey) ?? "";
    print("Stored user info: $_userId & Stored Mail Id: $_userMailId");
    notifyListeners();
  }

  void _saveUId(String uId) async {
    await _initPrefs();
    _prefs.setString(key, uId);
    print("Id Saved!");
  }

  void _saveUMailId(String mailId) async {
    await _initPrefs();
    _prefs.setString(mailKey, mailId);
    print("Mail id Saved!");
  }

  Future<void> signIn({String email, String password, VoidCallback userSignedIn}) async {

    try {
      var connectionResult = await (Connectivity().checkConnectivity());
      if(connectionResult == ConnectivityResult.none) {
        print("NetworkException Found");
        throw NetworkException(errorText: "Couldn't connect to the server, please try again later");
      } else {
        await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
        ).then((UserCredential userCred) {
          _userId = userCred.user.uid;
          _userMailId = userCred.user.email;
          _saveUId(_userId);
          _saveUMailId(_userMailId);
          userSignedIn();
          notifyListeners();
        });
      }
    } on FirebaseAuthException catch(error) {
      print("FirebaseAuthException: ${error.message}");
      notifyListeners();
      throw error;
    }

    notifyListeners();
  }

  Future<void> signUp({@required BuildContext context, VoidCallback verify, @required String email, @required String password}) async {

    try {
      var connectionResult = await (Connectivity().checkConnectivity());
      if(connectionResult == ConnectivityResult.none) {
        print("NetworkException Found");
        throw NetworkException(errorText: "Couldn't connect to the server, please try again later");
      } else {
        if(!emailRegEx.hasMatch(email)) {
          throw AuthException(errorText: "Email id is not valid, please check and try again");
        } else if(!(password.length > 6)) {
          throw AuthException(errorText: "Password must be at least 6 characters long");
        } else if(!(password.length <= 15)) {
          throw AuthException(errorText: "Password must not exceed 15 characters");
        } else {
          await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ).then((UserCredential userCred) {

            _userId = userCred.user.uid;
            debugPrint("Signed Up User Id: $_userId");
            debugPrint("Signed Up Firebase User: ${userCred.user}");

            verify();
          });
        }
      }
    } on FirebaseAuthException catch(error) {
      print("FirebaseAuth Exception: ${error.message}");
      notifyListeners();
      throw error;
    } 
  }

  Future<void> signOut({VoidCallback userSignedOut}) async {

    await firebaseAuth.signOut();
    await _initPrefs();
    _prefs.setString(key, "");
    _prefs.setString(mailKey, "");
    print("User Signed Out!");
    userSignedOut();
    notifyListeners();
  }

  Future<void> forgotPassword({String email}) async {
    try {
      var connectionResult = await (Connectivity().checkConnectivity());
      if(connectionResult == ConnectivityResult.none) {
        print("NetworkException Found");
        throw NetworkException(errorText: "Couldn't connect to the server, please try again later");
      } else if(!emailRegEx.hasMatch(email)) {
        throw AuthException(errorText: "Email id is not valid, please check and try again");
      } else {
        await firebaseAuth.sendPasswordResetEmail(email: email);
      }
    } on FirebaseAuthException catch(e) {
      print("FirebaseAuth Exception:- $e");
    }
  }
}