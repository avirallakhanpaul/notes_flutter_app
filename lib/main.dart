import "package:flutter/material.dart";
import 'package:notes_app/screens/email_verification/verification.dart';
import "package:provider/provider.dart";

import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen/home_screen.dart';
import "screens/note_screen/note_screen.dart";
import "screens/authentication/login_screen.dart";
import 'screens/authentication/signup_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteProvider>(create: (context) => NoteProvider(),),
        ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider(),),
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider(FirebaseAuth.instance),),
        ChangeNotifierProxyProvider<ThemeProvider, NoteProvider>(
          create: (context) => NoteProvider(),
          update: (ctx, theme, note) {
            return note..isDarkMode = theme.isDarkTheme;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, NoteProvider>(
          create: (context) => NoteProvider(),
          update: (ctx, auth, note) {
            return note..setUserId(auth);
          }
        ),
        StreamProvider(
          create: (context) => context.read<AuthProvider>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        home: Authentication(),
        theme: ThemeData(
          fontFamily: "Poppins",
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          NoteScreen.routeName: (ctx) => NoteScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignupScreen.routeName: (ctx) => SignupScreen(),
          Verification.routeName: (ctx) => Verification(),
        },
      ),
    );
  }
}

class Authentication extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _firebaseUser = context.watch<User>();
    // final _firebaseUser = Provider.of<AuthProvider>(context).
    // debugPrint("Main User:- $_firebaseUser");

    if(_firebaseUser != null) {
      print("Home Screen");
      return HomeScreen();
    } else {
      print("Login Screen");
      return LoginScreen();
    }
  }
}