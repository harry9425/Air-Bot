import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled/authentication/verifyPhone.dart';
import 'package:untitled/homePage.dart';
import 'package:untitled/bootup/splashScreen.dart';

import 'authentication/loginByPhone.dart';
import 'bootup/welcomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkTheme: ThemeData(brightness: Brightness.dark),
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: 'splashScreen',
      routes: {
        'splashScreen':(context) =>splashScreen(),
        'homePage':(context) =>homePage(),
        'welcomePage':(context) =>welcomePage(),
        'homePage':(context) =>homePage(),
        'loginByPhone':(context) =>loginByPhonePage(),
        'verifyByPhone':(context) =>verifyByPhone(),
      },
    );
  }
}
