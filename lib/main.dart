import "package:flutter/material.dart";
import "package:provider/provider.dart";

import 'providers/note_provider.dart';
import 'screens/home_screen/home_screen.dart';
import "screens/note_screen.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteProvider>(create: (context) => NoteProvider(),),
      ],
      child: MaterialApp(
        home: Home(),
        theme: ThemeData(
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme(
            // color: Color(noteArgs.color)
          ),
        ),
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