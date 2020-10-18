import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/utils/Style.dart';

import 'models/userModel.dart';

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
                autovalidate: true,
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

class CustomCardUserList extends StatelessWidget {
  final UseR userList;

  const CustomCardUserList({Key key, @required this.userList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CardContainer(
        color: Theme.of(context).cardColor,
        color2: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: CachedNetworkImageProvider(userList.photoUrl),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userList.displayName,
                    style: Style().cardTitle,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    userList.userEmail,
                    style: Style().cardSubTitle,
                  )
                ],
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ));
  }
}

class CardContainer extends StatelessWidget {
  final child;
  final color;

  final double height;
  final double width;
  final color2;

  const CardContainer({
    Key key,
    this.child,
    this.color,
    this.height,
    this.width,
    this.color2,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: color,
                gradient: LinearGradient(
                  colors: [color, color2],
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: child,
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
        top: 8,
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
          child: MaterialButton(
              animationDuration: Duration(milliseconds: 200),
              focusElevation: 0.5,
              elevation: 0,
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
                padding: const EdgeInsets.all(8.0),
                child: icon,
              )),
        ));
  }
}
