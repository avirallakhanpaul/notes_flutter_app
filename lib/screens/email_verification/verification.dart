import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/theme_provider.dart';
import '../authentication/signup_screen.dart';

class Verification extends StatefulWidget {

  static const routeName = "/verification";

  final Function userVerified;
  Verification({this.userVerified});

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {

    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) => checkEmailVerified());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    
    user = auth.currentUser;
    print("Function User:- $user");
    await user.reload();

    if(user.emailVerified) {
      timer.cancel();
      widget.userVerified();
    }
  }

  @override
  Widget build(BuildContext context) {

    // final args = ModalRoute.of(context).settings.arguments;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkTheme
        ? Color(0xFF121212)
        : Colors.white,
        elevation: 0,
        title: Row(
          children: <Widget>[
            Text(
              "Just",
              style: TextStyle(
                fontSize: 26,
                color: themeProvider.isDarkTheme
                ? Colors.white
                : Colors.black,
              ),
            ),
            Text(
              "Notes",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: themeProvider.isDarkTheme
                ? Color(0xFF64B5F6)
                : Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        actions: [],
      ),
      backgroundColor: themeProvider.isDarkTheme
        ? Color(0xFF121212)
        : Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(
        horizontal: 20,
        ),
        children: <Widget>[
          SizedBox(
            height: mediaQuery.height * 0.05,
          ),
          RichText(
            text: TextSpan(
              text: "A",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF858585),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "\tverification mail",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2196F3),
                  ),
                ),
                TextSpan(
                  text: "\thas been sent to",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF858585),
                  ),
                ),
                TextSpan(
                  text: "\t${user.email}",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.isDarkTheme
                    ? Colors.white
                    : Colors.black,
                  ),
                ),
                TextSpan(
                  text: ", please verify to continue",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.05,
          ),
          Text(
            "You will be redirected to your notes automatically once the mail id is verified",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF858585),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.2,
          ),
          Column(
            children: <Widget>[
              Text(
                "Didn't recieve the mail?",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF858585),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  onPressed: () => Navigator.of(context).pushReplacementNamed(SignupScreen.routeName),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Color(0xFF2196F3),
                      width: 3,
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: themeProvider.isDarkTheme
                      ? Colors.white
                      : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}