import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ZAK'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout)
          )
        ],
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
