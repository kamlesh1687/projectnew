import 'package:flutter/material.dart';

class TextFormFieldPassword extends StatefulWidget {
  final controller;
  final String hinttext;

  const TextFormFieldPassword({Key key, this.controller, this.hinttext})
      : super(key: key);

  @override
  _TextFormFieldPasswordState createState() => _TextFormFieldPasswordState();
}

class _TextFormFieldPasswordState extends State<TextFormFieldPassword> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.hinttext,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: widget.controller,
              obscureText: isObscure,
              validator: (value) {
                if (value.length < 5) {
                  return 'Your password is short';
                }
                return null;
              },
              expands: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Theme.of(context).cardColor,
                filled: true,
                suffix: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  child: InkWell(
                    child: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        if (isObscure) {
                          isObscure = false;
                        } else {
                          isObscure = true;
                        }
                      });
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class TextFormFieldOther extends StatelessWidget {
  final controller;
  final String hinttext;

  const TextFormFieldOther({Key key, this.controller, this.hinttext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// -----------------------------------------
          /// text title widget.
          /// -----------------------------------------
          Text(
            hinttext,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),

          SizedBox(
            height: 10,
          ),

          /// -----------------------------------------
          /// TextField widget with some styling.
          /// -----------------------------------------
          TextFormField(
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Theme.of(context).cardColor,
                filled: true,
              ))
        ],
      ),
    );
  }
}
