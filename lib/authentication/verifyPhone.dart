import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:untitled/modelClasses/userclass.dart';
class verifyByPhone extends StatefulWidget {
  const verifyByPhone({super.key});

  @override
  State<verifyByPhone> createState() => _verifyByPhoneState();
}

class _verifyByPhoneState extends State<verifyByPhone> {
  @override
  Widget build(BuildContext context) {
    UserModel user = ModalRoute.of(context)?.settings.arguments as UserModel;
    Toast.show(user.name);
    return Scaffold(
      body: Container(),
    );
  }
}
