import 'dart:ui';

import 'package:flutter/material.dart';

class TextColor {
  var color1;
  var color2;
}

var txtColor = Colors.black;
var defaultColor = Colors.white;

class Style {
  Style();

  var profileName =
      TextStyle(color: txtColor, fontWeight: FontWeight.w600, fontSize: 32);
  var headingText =
      TextStyle(color: txtColor, fontSize: 24, fontWeight: FontWeight.w600);
  var bodyText = TextStyle(color: txtColor, fontSize: 16);
  var cardTitle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: txtColor);
  var cardSubTitle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: txtColor);
  var buttonTxtXl =
      TextStyle(color: defaultColor, fontSize: 25, fontWeight: FontWeight.w800);
  var buttonTxtSm =
      TextStyle(fontSize: 16, color: defaultColor, fontWeight: FontWeight.w600);
  var textSm = TextStyle(fontSize: 12, color: txtColor);
  var textMd = TextStyle(fontSize: 20, color: txtColor);
  var textLg = TextStyle(fontSize: 24, color: txtColor);
}
