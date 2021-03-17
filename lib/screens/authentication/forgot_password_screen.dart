import 'dart:async';

import "package:flutter/material.dart";
import 'package:notes_app/helpers/authException.dart';
import 'package:notes_app/helpers/networkException.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../providers/theme_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {

  final Function toLoginPage;
  ForgotPasswordScreen({this.toLoginPage});

  static const routeName = "/resetPassword";

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    var _errorMessage = "";

    bool checkValidation() {
      final isValid = _formKey.currentState.validate();
      return isValid;
    }

    void showErrorSnackBar(String error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0.0,
          backgroundColor: Colors.red.shade800,
          content: Text(
            error,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    void forgotPass() async {

      setState(() {
        _isLoading = true;      
      });

      if(emailController.text.isEmpty) {
        setState(() {
          _isLoading = false;      
        });
        return;
      }
      try {
        await authProvider.forgotPassword(email: emailController.text.trim());
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0.0,
            backgroundColor: themeProvider.isDarkTheme
            ? Color(0xFF64B5F6)
            : Color(0xFF2196F3),
            content: Text(
              "A password reset email has been sent to the given email address",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      Timer(Duration(seconds: 5), () => widget.toLoginPage());
      } on NetworkException catch(e) {
        print("Network Exception:- ${e.errorText}");
        _errorMessage = e.errorText;
        showErrorSnackBar(_errorMessage);
      } on AuthException catch(e) {
        print("Auth Exception:- ${e.errorText}");
        _errorMessage = e.errorText;
        showErrorSnackBar(_errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        brightness: themeProvider.isDarkTheme
        ? Brightness.dark
        : Brightness.light,
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
                            text: "Forgot password?",
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
                            text: "\twe'll help you with a new one",
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
                          height: 50,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              forgotPass();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: themeProvider.isDarkTheme
                              ? Color(0xFF64B5F6)
                              : Color(0xFF2196F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Reset Password",
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
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          child: OutlinedButton(
                            onPressed: () => widget.toLoginPage(),
                            style: OutlinedButton.styleFrom(
                              primary: themeProvider.isDarkTheme
                            ? Colors.grey
                            : Colors.grey.shade50,
                            side: BorderSide(
                              color: themeProvider.isDarkTheme
                              ? Color(0xFF64B5F6)
                              : Color(0xFF2196F3),
                              width: 3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            ),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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