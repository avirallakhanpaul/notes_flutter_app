import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:notes_app/helpers/networkException.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {

  final Function signedInFunction;
  final Function toSingupPage;
  final Function toForgotPassPage;

  LoginScreen({
    this.signedInFunction, 
    this.toSingupPage,
    this.toForgotPassPage
  });

  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailRegEx = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var errorMessage = "";

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool checkValidation() {
      final isValid = _formKey.currentState.validate();
      return isValid;
    }

    void showErrorSnackBar(String error) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
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

    void signin({@required String email, @required String pass}) async {

      if((email.isEmpty || pass.isEmpty) || (email.isEmpty && pass.isEmpty)) {
        setState(() {
          _isLoading = false;        
        });
        return;
      } else if(_formKey.currentState.validate()) {
        try {
          await authProvider.signIn(
            email: email,
            password: pass,
            userSignedIn: widget.signedInFunction,
          );
        } on FirebaseAuthException catch(e) {
          if(e.message.contains("no user")) {
            errorMessage = "No user found, please check email id and try again";
          } else if(e.message.contains("password is invalid")) {
            errorMessage = "Password is incorrect, please try again";
          } else if(e.message.contains("badly formatted")) {
            errorMessage = "Email id is not valid, please check and try again";
          }
          showErrorSnackBar(errorMessage);
          
        } on NetworkException catch(e) {
          errorMessage = e.errorText;
          showErrorSnackBar(errorMessage);
        }
        setState(() {
          _isLoading = false;
        });
      }
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
                          // onSaved: (_) => checkValidation(),
                          // onFieldSubmitted: (_) => checkValidation(),
                          // onEditingComplete: () => checkValidation(),
                          // onChanged: (_) {
                          //   checkValidation();
                          // },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter an email";
                            }
                            // if(!emailRegEx.hasMatch(value)) {
                            //   return "Please enter a valid mail id";
                            // }
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
                          // onSaved: (_) => checkValidation(),
                          // onFieldSubmitted: (_) => checkValidation(),
                          // onEditingComplete: () => checkValidation(),
                          onChanged: (_) => checkValidation(),
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter a password";
                            }
                            // if(!(value.length > 3)) {
                            //   return "Password must be atleast 4 characters long";
                            // }
                            // if(!(value.length <= 15)) {
                            //   return "Password must not exceed 15 characters";
                            // }
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
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });
                        signin(
                          email: emailController.text,
                          pass: passwordController.text,
                        );
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
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    onPressed: () => widget.toForgotPassPage(),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.48,
                        color: Colors.grey.shade500,
                      ),
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
                        child: OutlinedButton(
                          onPressed: () => widget.toSingupPage(),
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
                            "Signup",
                            style: TextStyle(
                              color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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