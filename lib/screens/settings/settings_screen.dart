import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:flutter_switch/flutter_switch.dart";

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../home_screen/home_screen.dart';
import '../../common_widgtes/signout_alert_dialog.dart';

class SettingsScreen extends StatelessWidget {

  final signOutFunction;
  final Function toHomeFunction;
  SettingsScreen({this.signOutFunction, this.toHomeFunction});

  static const routeName = "/settings";

  @override
  Widget build(BuildContext context) {

    final userMail = Provider.of<AuthProvider>(context).userMailId;
    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Settings",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: theme.isDarkTheme
                ? Colors.white
                : Colors.black,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme.isDarkTheme
                ? Colors.white
                : Colors.black,
              ),
              onPressed: toHomeFunction,
            ),
          ),
          backgroundColor: theme.isDarkTheme
          ? Color(0xFF121212)
          : Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 60,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: theme.isDarkTheme
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Designed & Developed by",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Aviral Lakhanpaul",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: theme.isDarkTheme
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Mail Id",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          userMail,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: theme.isDarkTheme
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
                      children: [
                        Text(
                          "Enable Dark Theme",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: theme.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Transform.scale(
                          scale: 0.65,
                          child: FlutterSwitch(
                            value: theme.isDarkTheme, 
                            onToggle: (value) {
                              theme.toggleTheme();
                            },
                            padding: 0,
                            toggleSize: 35,
                            activeColor: Colors.white.withOpacity(0.2),
                            activeIcon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            activeToggleColor: Color(0xFF64B5F6),
                            inactiveColor: Colors.black.withOpacity(0.2),
                            inactiveIcon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            inactiveToggleColor: Color(0xFF78909C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    primary: theme.isDarkTheme
                    ? Color(0xFFEF5350)
                    : Color(0xFFE53935),
                  ),
                  label: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => SignoutAlertDialog(signOutFunction: signOutFunction,),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}