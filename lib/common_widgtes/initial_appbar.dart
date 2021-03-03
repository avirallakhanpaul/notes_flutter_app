import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "../providers/theme_provider.dart";

class InitialAppBar extends StatelessWidget {

  @override
  PreferredSizeWidget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
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
    );
  }
}