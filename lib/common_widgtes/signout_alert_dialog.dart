import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../models/note.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class SignoutAlertDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    void signout() async {
      print("signout Function");

      await authProvider.signOut();
      Navigator.of(context).pop();    
    }

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        return AlertDialog(
          backgroundColor: theme.isDarkTheme
          ? Color(0xFF424242)
          : Colors.white,
          title: Text(
            "Sign Out?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
            ),
          ),
          content: Text(
            "Are you sure you want to sign out?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () async => signout(),
              color: theme.isDarkTheme
              ? Color(0xFFf44336)
              : Colors.red.shade700,
              child: Text(
                "Sign Out",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              splashColor: Colors.grey.shade300,
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: theme.isDarkTheme
                  ? Colors.white
                  : Colors.black,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}