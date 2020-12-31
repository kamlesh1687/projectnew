import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:projectnew/utils/Theming/Gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModelProvider extends ChangeNotifier {
  final String key = 'theme';
  final String key2 = 'color';

  SharedPreferences _pref;
  LinearGradient _gradientCurrent;
  get gradientCurrent => _gradientCurrent;
  int gradientIndex;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;
  ThemeModelProvider() {
    _darkTheme = false;
    gradientIndex = 0;
    _loadFromPrefs();
  }

  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref.getBool(key) ?? false;
    gradientIndex = _pref.getInt(key2) ?? 0;
    _gradientCurrent = listColors[gradientIndex];

    notifyListeners();
  }

  _saveToPrefs() async {
    print(gradientIndex);
    await _initPrefs();
    _pref.setBool(key, _darkTheme);
    _pref.setInt(key2, gradientIndex);
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  gradientSelection(index) {
    gradientIndex = index;
    _gradientCurrent = listColors[index];
    _saveToPrefs();
    notifyListeners();
  }
}

ThemeData light = ThemeData(
  fontFamily: 'Ubuntu',
);

ThemeData dark = ThemeData(
  fontFamily: 'Ubuntu',
  brightness: Brightness.dark,
);

Color lightbg = Color(0xFFFAFAFB);
Color darkbg = Color(0xFF233355);
Color darkTextColor = Colors.grey;
Color lightTextColor = Colors.black;

// themeDataLight() {
//   return ThemeData(
//       splashColor: Colors.cyan.shade100,
//       accentColor: Colors.white,
//       primarySwatch: Colors.cyan,
//       backgroundColor: Colors.cyan.shade300,
//       secondaryHeaderColor: Colors.cyan.shade300,
//       hoverColor: Colors.yellow,
//       scaffoldBackgroundColor: Color(0xFFFAFAFB),
//       buttonColor: Colors.cyan,
//       textTheme: GoogleFonts.ubuntuTextTheme(),
//       appBarTheme: AppBarTheme(
//           textTheme: TextTheme(
//               headline6: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.5)),
//           color: Colors.cyan.shade300,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.white, size: 30)),
//       cardTheme: CardTheme(),
//       iconTheme: IconThemeData(color: Colors.cyan, size: 30),
//       cardColor: Colors.white,
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: Colors.cyan[500],
//       ),
//       bottomAppBarColor: Color(0xFFFAFAFB),
//       tabBarTheme: TabBarTheme(
//         labelStyle: TextStyle(
//           fontSize: 20,
//         ),
//         unselectedLabelStyle: TextStyle(
//           fontSize: 20,
//         ),
//         indicator:
//             BoxDecoration(border: Border(top: BorderSide(color: Colors.cyan))),
//         unselectedLabelColor: Colors.grey,
//       ));
// }

// themeDark() {
//   return ThemeData(
//       brightness: Brightness.dark,
//       iconTheme: IconThemeData(color: Colors.cyan, size: 30),
//       primaryColor: Colors.cyan,
//       primarySwatch: Colors.cyan,
//       buttonBarTheme: ButtonBarThemeData(),
//       splashColor: Colors.grey,
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: Color(0xFF37474F),
//       ),
//       textTheme: GoogleFonts.ubuntuTextTheme(),
//       tabBarTheme: TabBarTheme(
//           indicator: BoxDecoration(
//               border: Border(top: BorderSide(color: Colors.cyan))),
//           unselectedLabelColor: Colors.white60,
//           labelColor: Color(0xFF38434F)),
//       scaffoldBackgroundColor: darkbg,
//       cardColor: Color(0xFF294261),
//       appBarTheme: AppBarTheme(
//           textTheme: TextTheme(
//               headline6: TextStyle(
//                   color: Color(0xFF9E9E9E),
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.5)),
//           color: darkbg,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Color(0xFF38434F), size: 30)));
// }
