import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/button.dart';
import 'package:minimal_social_media_app/componets/text_field.dart';
import 'package:animate_do/animate_do.dart';
import 'package:minimal_social_media_app/string_constants.dart';
import 'package:minimal_social_media_app/utils/widget.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  Future<void> SignUp() async {
    ShowDialogLoading(context);

    if(passwordController.text != password2Controller.text){
      Navigator.pop(context);
      DisplayMessage(context, 'Şifreler eşleşmiyor');
    }
    try{
      UserCredential credential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      await FirebaseFirestore.instance.collection(STRINGS.CollectionUsers).doc(
          credential.user!.email
      ).set(
        {
          'username' : emailController.text.split('@')[0], // inital username
          'bio': 'Boş bio'
        }
      );

      if(context.mounted){
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch(e){
      var codes = {
        'email-already-in-use': 'Email adresi zaten kullanılıyor',
        'weak-password': 'En az 6 karakterli şifre giriniz',
        'invalid-email': 'Email adresi geçersiz!',
        'invalid-credential': 'Email adresi veya şifre hatalı.'
      };
      Navigator.pop(context);
      DisplayMessage(context, codes.containsKey(e.code) ?
      codes[e.code].toString() :
      e.code);
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
                        child:  Image.asset(
                          'assets/login.png',
                          width: 200,
                        ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Text("Senin için bir hesap oluşturalım.",
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(
                      height: 25,
                    ),
                    BounceInDown(
                      duration: Duration(milliseconds: 800),
                      child: MyTextField(
                          controller: emailController,
                          hintText: 'Email adresiniz',
                          obscureText: false),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BounceInDown(
                      duration: Duration(milliseconds: 1000),
                        child:  MyTextField(
                            controller: passwordController,
                            hintText: 'Şifreniz',
                            obscureText: true)
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    BounceInDown(
                        duration: Duration(milliseconds: 1200),
                        child:  MyTextField(
                            controller: password2Controller,
                            hintText: 'Şifreniz Tekrar',
                            obscureText: true)
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    BounceInUp(
                        duration: Duration(milliseconds: 1000),
                        child:  MyButton(onTap: SignUp, text: "Kayıt ol")
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Zaten üyeyim!',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Giriş yap!',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
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
