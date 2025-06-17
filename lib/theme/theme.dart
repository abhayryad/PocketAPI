import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Space Grotesk',
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Colors.black12,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(color: Colors.black),
    ),
    iconTheme: WidgetStatePropertyAll(
      IconThemeData(color: Colors.black),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Space Grotesk',
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.black,
    indicatorColor: Colors.white12,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(color: Colors.white),
    ),
    iconTheme: WidgetStatePropertyAll(
      IconThemeData(color: Colors.white),
    ),
  ),
);