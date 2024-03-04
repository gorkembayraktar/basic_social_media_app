import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/button.dart';
import 'package:minimal_social_media_app/componets/text_field.dart';
import 'package:minimal_social_media_app/utils/widget.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    ShowDialogLoading(context);

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      if(context.mounted){
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      var codes = {
        'invalid-email': 'Email adresiniz geçersiz',
        'invalid-credential': 'Email adresi veya şifre hatalı.'
      };
      print(e.code);
      DisplayMessage(
          context,
          codes.containsKey(e.code) ?
          codes[e.code].toString() :
          e.code
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeIn(
                      duration: Duration(milliseconds: 1000),
                      child: Image.asset(
                        'assets/login.png',
                        width: 300,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Tekrar hoşgeldin, seni özledik!",
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(
                      height: 25,
                    ),
                    FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: MyTextField(
                          controller: emailController,
                          hintText: 'Email adresiniz',
                          obscureText: false),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInDown(
                        duration: Duration(milliseconds: 600),
                        child: MyTextField(
                            controller: passwordController,
                            hintText: 'Şifreniz',
                            obscureText: true)),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 700),
                        child: MyButton(onTap: signIn, text: "Giriş yap")),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Üye değil misin?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Kayıt ol',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
