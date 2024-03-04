import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/auth/auth.dart';
import 'package:minimal_social_media_app/theme/dark_theme.dart';
import 'package:minimal_social_media_app/theme/light_theme.dart';


void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      darkTheme: darkTheme,
      home: const AuthPage(),
    );
  }
}
