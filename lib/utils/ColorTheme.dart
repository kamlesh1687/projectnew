import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color lightbg = Color(0xFFFAFAFB);
Color darkbg = Color(0xFF233355);

themeDataLight() {
  return ThemeData(
      splashColor: Colors.cyan.shade100,
      accentColor: Colors.white,
      primarySwatch: Colors.cyan,
      backgroundColor: Colors.cyan.shade300,
      secondaryHeaderColor: Colors.cyan.shade300,
      hoverColor: Colors.yellow,
      scaffoldBackgroundColor: lightbg,
      buttonColor: Colors.cyan,
      textTheme: GoogleFonts.ubuntuTextTheme()
      // textTheme: TextTheme(
      //     headline4: TextStyle(
      //         fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
      //     headline2: TextStyle(
      //       fontSize: 12,
      //     ),
      //     headline3: TextStyle(
      //       fontSize: 16,
      //     ),
      //     button: TextStyle(color: Colors.white, fontSize: 16),
      //     headline6: TextStyle(color: Color(0xFF00BCD4), fontSize: 30))
      ,
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          color: Colors.cyan.shade300,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white, size: 30)),
      cardTheme: CardTheme(),
      iconTheme: IconThemeData(color: Colors.cyan, size: 30),
      cardColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.cyan[500],
      ),
      bottomAppBarColor: lightbg,
      tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.cyan))),
          unselectedLabelColor: Colors.grey,
          labelColor: Color(0xFF38434F)));
}

themeDataDark() {
  return ThemeData(
      primaryColor: Colors.cyan,
      primarySwatch: Colors.cyan,
      buttonBarTheme: ButtonBarThemeData(),
      splashColor: Colors.grey,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF37474F),
      ),
      textTheme: GoogleFonts.ubuntuTextTheme(),
      // textTheme: TextTheme(
      //     headline4: GoogleFonts.ubuntuTextTheme().headline4,
      //     headline2: TextStyle(
      //       fontSize: 12,
      //     ),
      //     headline3: TextStyle(
      //       fontSize: 16,
      //     ),
      //     headline1: GoogleFonts.ubuntuTextTheme().headline1,
      //     button: TextStyle(color: Colors.white, fontSize: 16),
      //     headline6: TextStyle(color: Color(0xFF00BCD4), fontSize: 30)),
      tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.cyan))),
          unselectedLabelColor: Colors.white60,
          labelColor: Color(0xFF38434F)),
      scaffoldBackgroundColor: darkbg,
      cardColor: Color(0xFF294261),
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              headline6: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          color: darkbg,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF38434F), size: 30)));
}
