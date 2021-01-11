import 'package:flutter/material.dart';

import 'LogInView.dart';
import 'SignUpView.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: RichText(
                text: TextSpan(text: "hey"),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  RoundedFlatBtn(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPage.routeName);
                    },
                    color: Colors.deepOrange,
                    text: 'Get Started',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedFlatBtn(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    },
                    color: Colors.white,
                    text: 'Login',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoundedFlatBtn extends StatefulWidget {
  final onPressed;
  final String text;
  final Color color;
  final bool isBorder;

  RoundedFlatBtn(
      {Key key, this.onPressed, this.text, this.color, this.isBorder})
      : super(key: key);

  @override
  _RoundedFlatBtnState createState() => _RoundedFlatBtnState();
}

class _RoundedFlatBtnState extends State<RoundedFlatBtn> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Colors.deepOrange)),
            color: widget.color,
            onPressed: () {
              widget.onPressed();
            },
            textColor:
                widget.color == Colors.white ? Colors.deepOrange : Colors.white,
            child: Text(
              widget.text,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
