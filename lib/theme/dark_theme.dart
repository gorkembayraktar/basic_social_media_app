

import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!
  ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white
        )
    )
);