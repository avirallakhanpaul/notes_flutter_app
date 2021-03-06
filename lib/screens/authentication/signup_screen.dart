import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:notes_app/helpers/authException.dart';
import 'package:notes_app/helpers/networkException.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {

  static const routeName = "/signup";

  final userSignedUp;
  final toLoginpage;

  SignupScreen({this.userSignedUp, this.toLoginpage});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final emailRegEx = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;

  var errorMessage = "";

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    String currentPass;

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

    void signup({@required String email, @required String pass}) async {
      try {
        await authProvider.signUp(
          context: context,
          email: email,
          password: pass,
          verify: widget.userSignedUp,
        );
      } on FirebaseAuthException catch(e) {
        if(e.message.contains("email address is already in use")) {
          errorMessage = "Email id is already in use";
        } 
        print(e.message);
        showErrorSnackBar(errorMessage);
      } on NetworkException catch(e) {
        errorMessage = e.errorText;
        showErrorSnackBar(errorMessage);
      } on AuthException catch(e) {
        errorMessage = e.errorText;
        showErrorSnackBar(errorMessage);
      }

      setState(() {
        _isLoading = false;
        print("User added!");
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
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Create an account",
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
                          TextSpan(
                            text: "\tto start your notes journey",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                              height: 1.2,
                              letterSpacing: 0.1,
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
                          // onChanged: (_) => checkValidation(),
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
                          onChanged: (value) {
                            currentPass = value;
                            checkValidation();
                          },
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: confirmPassController,
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
                            if(value != currentPass) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
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
                        signup(
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
                            "Signup",
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
                    height: 50,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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
                          onPressed: () => widget.toLoginpage(),
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
                            "Login",
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