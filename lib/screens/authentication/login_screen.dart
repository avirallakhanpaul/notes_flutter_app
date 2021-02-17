import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/screens/authentication/signup_screen.dart';

import '../../providers/auth_provider.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool checkValidation() {

      final isValid = _formKey.currentState.validate();
      return isValid;
    }

    void signin({@required String email, @required String pass}) async {

      if(_formKey.currentState.validate()) {
        await authProvider.signIn(
          email: email,
          password: pass,
        );

        // setState(() {
        //   _isLoading = false;
        // });

        print("Login Successful!");
      }
    }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0,
            right: 20,
            bottom: 20,
            left: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 62,
                    height: 62,
                    child: SvgPicture.asset(
                      "assets/icons/justnotes_logo.svg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: RichText(
                      // maxLines: 2,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.1,
                              color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                            ),
                          ),
                          // SizedBox(),
                          TextSpan(
                            text: "\tto start creating some awesome notes",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              height: 1.2,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: themeProvider.isDarkTheme
                            ? Colors.grey.shade300
                            : Colors.grey.shade800,
                          ),
                          onChanged: (_) {
                            checkValidation();
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter an email";
                            }
                            if(!value.contains("@")) {
                              return "Please enter a valid email";
                            }
                            if(!value.contains(".com")) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Color(0xFF969696)
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: themeProvider.isDarkTheme
                                ? Color(0xFF404040)
                                : Colors.black,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.5,
                                color: themeProvider.isDarkTheme
                                ? Color(0xFF64B5F6)
                                : Color(0xFF2196F3),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: passwordController,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: themeProvider.isDarkTheme
                            ? Colors.grey.shade300
                            : Colors.grey.shade800,
                          ),
                          onChanged: (_) {
                            checkValidation();
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter a password";
                            }
                            if(!(value.length > 3)) {
                              return "Password must be atleast 4 characters long";
                            }
                            if(!(value.length <= 15)) {
                              return "Password must not exceed 15 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Color(0xFF969696)
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: themeProvider.isDarkTheme
                                ? Color(0xFF404040)
                                : Colors.black,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.5,
                                color: themeProvider.isDarkTheme
                                ? Color(0xFF64B5F6)
                                : Color(0xFF2196F3),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        signin(
                          email: emailController.text,
                          pass: passwordController.text,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _isLoading
                          ? Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ],
                          )
                          : Container(),
                        ],
                      ),
                      color: themeProvider.isDarkTheme
                      ? Color(0xFF64B5F6)
                      : Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.48,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 45,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignupScreen.routeName,
                            );
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: themeProvider.isDarkTheme
                              ? Color(0xFF64B5F6)
                              : Color(0xFF2196F3),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: themeProvider.isDarkTheme
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}