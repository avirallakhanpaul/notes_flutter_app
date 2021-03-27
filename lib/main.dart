import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes_app/providers/reminder_provider.dart';
import 'package:notes_app/screens/reminder/reminder_screen.dart';
import "package:provider/provider.dart";
import 'package:timezone/data/latest.dart' as tz;

import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/home_screen/home_screen.dart';
import "screens/note_screen/note_screen.dart";
import "screens/authentication/login_screen.dart";
import 'screens/authentication/signup_screen.dart';
import 'screens/email_verification/verification.dart';
import 'screens/root_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {

  tz.initializeTimeZones();

  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/justnotes_icon");
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if(payload != null) {
        debugPrint("Payload:- $payload");
      }
    }
  );

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
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider(firebaseAuth: FirebaseAuth.instance),),
        ChangeNotifierProvider<ReminderProvider>(create: (context) => ReminderProvider(),),
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
          initialData: "",
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
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          ReminderScreen.routeName: (ctx) => ReminderScreen(),
        },
      ),
    );
  }
}

class Authentication extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // final _firebaseUser = context.watch<User>();

    // if(_firebaseUser != null) {
    //   print("Home Screen");
    //   return HomeScreen();
    // } else {
    //   print("Login Screen");
    //   return LoginScreen();
    // }

    return RootPage(auth: AuthProvider(firebaseAuth: FirebaseAuth.instance));

  }
}