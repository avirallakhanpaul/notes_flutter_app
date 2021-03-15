import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class SignoutAlertDialog extends StatelessWidget {

  final Function signOutFunction;
  SignoutAlertDialog({this.signOutFunction});

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    void signout() async {

      await authProvider.signOut(userSignedOut: signOutFunction);
      Navigator.of(context).pop(true);
    }

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        return AlertDialog(
          backgroundColor: theme.isDarkTheme
          ? Color(0xFF424242)
          : Colors.white,
          title: Text(
            "Are you sure?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                primary: Colors.grey.shade300,
              ),
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
            ElevatedButton(
              onPressed: () async => signout(),
              style: ElevatedButton.styleFrom(
                primary: theme.isDarkTheme
                ? Color(0xFFf44336)
                : Colors.red.shade700,
              ),
              child: Text(
                "Sign Out",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}