import 'package:flutter/material.dart';
import 'package:untitled/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    startanimate();
    super.initState();
  }

  Future startanimate() async {
    await Future.delayed(Duration(milliseconds: 1500)).then((value){
      _checkCurrentUser();
    });
  }

  Future<void> _checkCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, 'loginByPhone');
    } else {
      Navigator.pushReplacementNamed(context, 'welcomePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Text(
                  "SPLASH SCREEN",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
