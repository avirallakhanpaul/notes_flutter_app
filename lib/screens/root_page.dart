import "package:flutter/material.dart";
import 'package:notes_app/screens/authentication/forgot_password_screen.dart';
import 'package:notes_app/screens/settings/settings_screen.dart';

import "../providers/auth_provider.dart";
import 'authentication/login_screen.dart';
import 'home_screen/home_screen.dart';
import 'authentication/signup_screen.dart';
import 'email_verification/verification.dart';

class RootPage extends StatefulWidget {

  final AuthBaseClass auth;
  RootPage({this.auth});

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notSignedUp,
  notLoggedIn,
  loggedIn,
  verifying,
  verified,
  forgotPass,
  settings,
}

class _RootPageState extends State<RootPage> {

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((uId) {
      print("uId in Root: $uId");
      setState(() {
        uId == null
        ? _authStatus = AuthStatus.notSignedUp
        : _authStatus = AuthStatus.loggedIn;
      });
    });
  }

  AuthStatus _authStatus;

  void signedUp() {
    setState(() {
      _authStatus = AuthStatus.verifying;    
    });
  }

  void login() {
    setState(() {
      _authStatus = AuthStatus.loggedIn;  
    });
  }

  void logout() {
    setState(() {
      _authStatus = AuthStatus.notLoggedIn;
    });
  }

  void verified() {
    setState(() {
      _authStatus = AuthStatus.verified; 
    });
  }

  void switchToSignup() {
    setState(() {
      _authStatus = AuthStatus.notSignedUp;    
    });
  }

  void switchToLogin() {
    setState(() {
      _authStatus = AuthStatus.notLoggedIn;    
    });
  }

  void switchToForgotPass() {
    setState(() {
      _authStatus = AuthStatus.forgotPass;    
    });
  }

  void switchToSettings() {
    setState(() {
      _authStatus = AuthStatus.settings;          
    });
  }

  @override
  Widget build(BuildContext context) {

    print("AuthStatus: $_authStatus");

    switch(_authStatus) {
      case AuthStatus.notSignedUp:
        return SignupScreen(
          userSignedUp: signedUp, 
          toLoginpage: switchToLogin,
        );
      case AuthStatus.notLoggedIn:
        return LoginScreen(
          signedInFunction: login, 
          toSingupPage: switchToSignup,
          toForgotPassPage: switchToForgotPass,
        );
      case AuthStatus.verifying:
        return Verification(
          userVerified: verified, 
          toSignUpPage: switchToSignup,
        );
      case AuthStatus.verified:
        return LoginScreen(
          signedInFunction: login,
          toSingupPage: switchToSignup,
          toForgotPassPage: switchToForgotPass,
        );
      case AuthStatus.loggedIn:
        return HomeScreen(
          signOutFunction: logout,
          settingsFunction: switchToSettings,
        );
      case AuthStatus.forgotPass:
        return ForgotPasswordScreen(
          toLoginPage: switchToLogin,
        );
      case AuthStatus.settings:
      return SettingsScreen(
        toHomeFunction: login,
        signOutFunction: logout,
      );
    }

    return Container();
  }
}