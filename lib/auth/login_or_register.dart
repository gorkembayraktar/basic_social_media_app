import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/screens/Login.dart';
import 'package:minimal_social_media_app/screens/Register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return Login(onTap: togglePages);
    }
    return RegisterPage(onTap: togglePages);
  }
}
