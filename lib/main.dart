import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import "package:provider/provider.dart";

import 'providers/note_provider.dart';
import 'screens/home_screen/home_screen.dart';
import "screens/note_screen/note_screen.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteProvider>(create: (context) => NoteProvider(),),
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider(),),
        ChangeNotifierProxyProvider<ThemeProvider, NoteProvider>(
          create: (context) => NoteProvider(),
          update: (ctx, theme, note) {
            print("Proxy Theme Dark Mode: ${theme.isDarkTheme}");
            print("Proxy Note Dark Theme: ${note.isDarkMode}");
            return note..isDarkMode = theme.isDarkTheme;
          },
        ),
      ],
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          NoteScreen.routeName: (ctx) => NoteScreen(),
        },
      ),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}