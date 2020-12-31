import 'package:flutter/material.dart';

Route customPageRouteSlideAnimation(Widget nextScreen, bool isRight) {
  return PageRouteBuilder(transitionsBuilder: (BuildContext context,
      Animation<double> animation,
      Animation<double> secAnimation,
      Widget child) {
    return SlideTransition(
        transformHitTests: true,
        position: Tween<Offset>(
                begin: isRight ? Offset(1.0, 0.0) : Offset(-1.0, 0.0),
                end: Offset(0.0, 0.0))
            .animate(CurvedAnimation(
                parent: animation, curve: Curves.fastOutSlowIn)),
        child: nextScreen);
  }, pageBuilder: (BuildContext context, Animation<double> animation,
      Animation<double> secAnimation) {
    return nextScreen;
  });
}
