import 'package:flutter/material.dart';

var cardShadowpositive = BoxShadow(
  color: Color.fromRGBO(0, 0, 0, 0.1),
  blurRadius: 6, // soften the shadow
  spreadRadius: 3, //end the shadow
  offset: Offset(
    6.0, // Move to right 10  horizontally
    2.0, // Move to bottom 10 Vertically
  ),
);
var cardShadownegative = BoxShadow(
  color: Color.fromRGBO(255, 255, 255, 0.5),
  blurRadius: 6, // soften the shadow
  spreadRadius: 3, //end the shadow
  offset: Offset(
    -6.0, // Move to right 10  horizontally
    -2.0, // Move to bottom 10 Vertically
  ),
);
