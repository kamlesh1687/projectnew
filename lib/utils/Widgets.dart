import 'package:flutter/material.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';

import 'package:provider/provider.dart';

class Inputtextfield extends StatelessWidget {
  final controllerText;
  final hinttext;
  Inputtextfield({@required this.hinttext, @required this.controllerText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5),
          elevation: 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                controller: controllerText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabled: true,
                  enabledBorder: InputBorder.none,
                  hintText: hinttext,
                  alignLabelWithHint: true,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ));
  }
}

class Buttons extends StatelessWidget {
  final functon;
  final text;
  final color;
  Buttons({@required this.functon, @required this.text, @required this.color});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: FlatButton(
          height: 50,
          minWidth: 100,
          color: color,
          onPressed: functon,
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }
}

class FollowBtn extends StatelessWidget {
  final String txt;

  final onPressed;

  final borderRadius;

  const FollowBtn({Key key, this.txt, this.onPressed, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: OutlineButton(
        child: Text(
          txt,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 15)),
        onPressed: onPressed,
      ),
    );
  }
}

class CrdConValue {
  final child;
  final Color color;

  final double height;
  final double width;

  final LinearGradient linearGradient;

  CrdConValue(
      {this.child, this.color, this.height, this.width, this.linearGradient});
}

class CardContainer extends StatelessWidget {
  final CrdConValue values;

  const CardContainer({Key key, this.values}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            height: values.height,
            width: values.width,
            decoration: BoxDecoration(
                color: values.color,
                gradient: values.linearGradient,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      spreadRadius: 1)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: values.child,
          ),
        )
      ],
    );
  }
}

class SpecialButton extends StatelessWidget {
  final double left;
  final double right;

  final isCurrentuser;

  final color;
  final icon;
  final clickFunction;

  const SpecialButton(
      {Key key,
      this.left,
      this.right,
      this.isCurrentuser,
      this.color,
      this.icon,
      this.clickFunction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 10,
        right: right,
        left: left,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 2)
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25))),
          child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).cardColor,
              onPressed: clickFunction,
              shape: RoundedRectangleBorder(
                  borderRadius: isCurrentuser
                      ? BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25))
                      : BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: icon,
              )),
        ));
  }
}

class CircularBtn extends StatelessWidget {
  final onPressed;
  final textStyle;
  final String txt;
  final borderRadius;

  const CircularBtn(
      {Key key, this.onPressed, this.txt, this.borderRadius, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_statements

    return Container(
        decoration: BoxDecoration(
            gradient: context.watch<ThemeModelProvider>().curretGradient,
            borderRadius: BorderRadius.circular(borderRadius ?? 15)),
        child: MaterialButton(
          onPressed: onPressed,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
          ),
          child: Text(
            txt,
            // style: textStyle ?? Style().buttonTxtSm,
          ),
        ));
  }
}
