import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/button.dart';
import 'package:minimal_social_media_app/componets/text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                    Image.asset(
                      'assets/login.png',
                      width: 300,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Tekrar hoşgeldin, seni özledik!",style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextField(
                        controller: emailController,
                        hintText: 'Email adresiniz',
                        obscureText: false),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: passwordController,
                        hintText: 'Şifreniz',
                        obscureText: true),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(onTap: () {}, text: "Giriş yap"),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Üye değil misin?', style: TextStyle(color: Colors.grey[700]),),
                        SizedBox(width: 4,),
                        GestureDetector(
                          onTap: (){
          
                          },
                          child: Text('Kayıt ol',
                            style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
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
