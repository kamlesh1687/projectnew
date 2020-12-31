import 'package:flutter/material.dart';

Widget customAppBar(mytitle, context) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 70,
    title: Text(
      mytitle,
      style: Theme.of(context).textTheme.headline4,
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    shadowColor: Colors.transparent,
  );
}
